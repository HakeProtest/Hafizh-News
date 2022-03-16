//
//  Network.swift
//  News-Hafizh
//
//  Created by Hafizh Caesandro Kevinoza on 16/03/22.
//

import Foundation

class NetworkManager {
    
    static let singleton = NetworkManager()
    
    let urlSession = URLSession.shared
    let baseURL = "https://newsapi.org/v2/"
    let APIKEY = "\(Secret.apiKey.rawValue)"
    
    enum EndPoints {
        case articles
        case category(categoryIn: String, pageNumber: String)
        case search(q: String)
        case sources
        case getFromNewsSource(Category: String)
        
        func getPath() -> String {
            switch self {
            case .articles, .category, .getFromNewsSource:
                return "top-headlines"
            case .search:
                return "everything"
            case .sources:
                return "sources"
            }
        }
        
        func getHTTPRequestMethod() -> String {
            return "GET"
        }
        
        func getHeaders(secretKey: String) -> [String: String] {
            
            return ["Accept": "application/json",
                    "Content-Type": "application/json",
                    "Authorization": "X-Api-Key \(secretKey)",
                    "Host": "newsapi.org"
            ]
        }
        
        func getParams() -> [String: String] {
            switch self {
            case .articles:
                return ["country": "us"
                ]
            case .category(let categoryIn, let pageNum):
                return ["country": "us",
                        "category": categoryIn,
                        "page": pageNum
                ]
            case .search(let qInput):
                return ["q": qInput
                ]
            case .sources:
                return ["language": "en"
                ]
            case .getFromNewsSource(let inputNewsSource):
                return ["sources": inputNewsSource
                ]
            }
        }
        
        func paramsToString() -> String {
            let parameterArray = getParams().map{ key, value in
                return "\(key)=\(value)"
            }
            
            return parameterArray.joined(separator: "&")
        }
    }
    
    enum Result<T> {
        case success(T?)
        case failure(Error)
    }
    
    enum EndPointError: Error {
        case couldNotParse
        case noData
    }
    
    
    private func makeRequest(for endPoint: EndPoints) -> URLRequest {
        let path = endPoint.getPath()
        let stringParams = endPoint.paramsToString()
        let fullURL = URL(string: baseURL.appending("\(path)?\(stringParams)"))
        print("Full URL : \(fullURL)")
        var request = URLRequest(url: fullURL!)
        request.httpMethod = endPoint.getHTTPRequestMethod()
        request.allHTTPHeaderFields = endPoint.getHeaders(secretKey: APIKEY)
        return request
        
    }
    
    func getArticles(passedInCategory: String, passedInPageNumber: String="1", _ completion: @escaping (Result<[Article]>) -> Void)  {
        let articleRequest = makeRequest(for: .category(categoryIn: passedInCategory, pageNumber: passedInPageNumber))
        print("Article request : \(articleRequest)")
        
        let task = urlSession.dataTask(with: articleRequest) { (data, response, error) in
            if let error = error {
                return completion(Result.failure(error))
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: [])
            } catch {
                print(error.localizedDescription)
            }
            
            guard let safeData = data else {
                return completion(Result.failure(EndPointError.noData))
                
            }
            
            guard let result = try? JSONDecoder().decode(ArticleList.self, from: safeData) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            let articles = result.articles
            
            DispatchQueue.main.async {
                completion(Result.success(articles))
            }
        }
        task.resume()
    }
    
    func getSearchArticles(passedInQuery: String, _ completion: @escaping (Result<[Article]>) -> Void)  {
        let articleRequest = makeRequest(for: .search(q: passedInQuery))
        
        let task = urlSession.dataTask(with: articleRequest) { (data, response, error) in
            if let error = error {
                return completion(Result.failure(error))
            }
            guard let safeData = data else {
                return completion(Result.failure(EndPointError.noData))
                
            }
            guard let result = try? JSONDecoder().decode(ArticleList.self, from: safeData) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            let articles = result.articles
            
            DispatchQueue.main.async {
                completion(Result.success(articles))
            }
        }
        task.resume()
    }
    
    func getSources(_ completion: @escaping (Result<AllNewsSources>) -> Void)  {
        let articleRequest = makeRequest(for: .sources)
        
        let task = urlSession.dataTask(with: articleRequest) { (data, response, error) in
            if let error = error {
                return completion(Result.failure(error))
            }
            guard let safeData = data else {
                return completion(Result.failure(EndPointError.noData))
                
            }
            guard let result = try? JSONDecoder().decode(AllNewsSources.self, from: safeData) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            let sources = result
            
            DispatchQueue.main.async {
                completion(Result.success(sources))
            }
        }
        task.resume()
    }
    
    func getArticlesFromSource(from Category: String, _ completion: @escaping (Result<[Article]>) -> Void)  {
        let articleRequest = makeRequest(for: .getFromNewsSource(Category: Category))
        
        let task = urlSession.dataTask(with: articleRequest) { (data, response, error) in
            if let error = error {
                return completion(Result.failure(error))
            }

            guard let safeData = data else {
                return completion(Result.failure(EndPointError.noData))
                
            }
            guard let result = try? JSONDecoder().decode(ArticleList.self, from: safeData) else {
                return completion(Result.failure(EndPointError.couldNotParse))
            }
            
            let articles = result.articles
            
            DispatchQueue.main.async {
                completion(Result.success(articles))
            }
        }
        task.resume()
    }
    
}
