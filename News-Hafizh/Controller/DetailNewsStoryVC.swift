//
//  DetailNewsStoryVC.swift
//  News-Hafizh
//
//  Created by Hafizh Caesandro Kevinoza on 16/03/22.
//

import UIKit
import WebKit

class DetailNewsStoryVC: UIViewController {
    
    var url: String? = nil
    var webPage = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        getWebPage(from: url!)
        view.backgroundColor = .white
    }
    
    func setUp(){
        self.view.addSubview(webPage)
        webPage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webPage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            webPage.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            webPage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webPage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func getWebPage(from url: String) {
        var comps = URLComponents(string: url)!
        comps.scheme = "https"
        let https = comps.string!
        let toURL = URL(string: https)
        let request = URLRequest(url: toURL!)
        webPage.load(request)
    }
    
}
