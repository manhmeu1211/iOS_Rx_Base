//
//  Token.swift
//  RxBase
//
//  Created by Lương Mạnh on 14/03/2022.
//

struct Token: Codable {
    var accessToken: String
    var refreshToken: String?
    var firstLogin: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case firstLogin = "first_login"
    }
}
