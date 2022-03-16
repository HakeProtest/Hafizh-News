//
//  Article.swift
//  News-Hafizh
//
//  Created by Hafizh Caesandro Kevinoza on 16/03/22.
//

import Foundation

public struct Source: Decodable {
    let id: String?
    let name: String?
}

public struct Article: Decodable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let content: String?
}

public struct ArticleList: Decodable{
    public var articles: [Article]
}
