//
//  HeadlinesVC.swift
//  News-Hafizh
//
//  Created by Hafizh Caesandro Kevinoza on 16/03/22.
//

import UIKit

class HeadlinesVC: UIViewController {
    
    @IBOutlet weak var headlinesTableView: UITableView!
    var category: String? = nil
    var sourceName: String? = nil
    var searchQuery: String? = nil
    var headlines: [Article] = []
    var currentAPICallPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setUpTitle()
    }
    
    func setUpTitle() {
        if category != nil {
            self.title = category
        }
        if sourceName != nil {
            self.title = sourceName
        }
        if searchQuery != nil {
            self.title = searchQuery
        }
    }
    
    func configureTableView() {
        view.addSubview(headlinesTableView)
        headlinesTableView.delegate = self
        headlinesTableView.dataSource = self
    }
}

extension HeadlinesVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headlineCell", for: indexPath) as! HeadlinesCell
        let article = headlines[indexPath.row]
        cell.setHeadlines(for: article)
        
        if category != nil {
            if indexPath.row == headlines.count - 1 {
                currentAPICallPage += 1
                NetworkManager.singleton.getArticles(passedInCategory: category!, passedInPageNumber: String(currentAPICallPage)) { result in
                    switch result {
                    case let .success(moreArticles):
                        self.headlines.append(contentsOf: moreArticles!)
                        self.headlinesTableView.reloadData()
                    case let .failure(gotError):
                        print(gotError)
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailNewsStoryVC()
        vc.url = headlines[indexPath.row].url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

