//
//  Post.swift
//  asn1
//
//  Created by Student on 11/1/23.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: Int
    let image: String
    let flow: String
    let amount: Int
    let createdAt: String
    let businessName: String
    let businessID: Int
    let username: String
    let userID: Int
    let isPrivate: Bool
    let caption: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case image
        case flow
        case amount
        case createdAt
        case businessName
        case businessID
        case username
        case userID
        case isPrivate = "private"
        case caption
    }
}
