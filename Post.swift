//
//  Post.swift
//  asn1
//
//  Created by Student on 10/31/23.
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
    
    enum Typing: String, Codable {                          
        case isPrivate = "private"
    }
}

