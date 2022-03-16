//
//  Category.swift
//  News-Hafizh
//
//  Created by Hafizh Caesandro Kevinoza on 16/03/22.
//

import Foundation

public struct Category: Decodable, Hashable {
    let id: String?
    let name: String?
    let category: String?
}

public struct AllNewsSources: Decodable {
    let sources: [Category]
}
