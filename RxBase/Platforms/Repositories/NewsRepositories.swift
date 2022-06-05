//
//  NewsRepositories.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import Foundation
protocol NewsRepositoryType {
    func getNews() -> Observable<ResponseData<[News]>>
}

final class NewsRepository: NewsRepositoryType {
    
    func getNews() -> Observable<ResponseData<[News]>> {
        return NetworkingManager.request(APIRouter.news("tesla", from: "2022-02-14", sortBy: "publishedAt", apiKey: "bce6a058a84b4d3d914d5534f500681d"))
    }
}
