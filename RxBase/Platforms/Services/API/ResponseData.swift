//
//  ResponseData.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//


import Foundation
//
//struct ResponseData<T: Codable>: Codable {
//    var pagination: Pagination?
//    var data: T?
//    var message: String?
//    var status: Int?
//    var code: String?
//    var version: String?
//}

struct ResponseData<T: Codable>: Codable {
    var articles: T?
    var status: String?
    var totalResults: Int?
}

struct MessageResponse: Codable {
    var message: String?
    var status: Int?
}

struct Pagination: Codable {
    var currentPage: Int?
    var nextPage: Int?
    var prevPage: Int?
    var totalRecord: Int?
    var point: Double?
    var money: Double?
    
    enum CodingKeys: String, CodingKey {
        case point, money
        case prevPage = "prev_page"
        case currentPage = "current_page"
        case nextPage = "next_page"
        case totalRecord = "total_record"
    }
}

struct PagingInfo<T>: Then {
    var page: Int
    var items: [T]
    var hasMorePages: Bool
    
    init(page: Int = 1, items: [T] = [], hasMorePages: Bool = false) {
        self.page = page
        self.items = items
        self.hasMorePages = hasMorePages
    }
}
