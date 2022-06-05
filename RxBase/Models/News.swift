//
//  News.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import Foundation

struct News: Codable {
    var title: String
    var description: String
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case content
    }
}
extension Token: Then {}
