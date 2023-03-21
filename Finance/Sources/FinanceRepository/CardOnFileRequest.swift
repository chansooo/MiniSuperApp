//
//  File.swift
//  
//
//  Created by 김찬수 on 2023/03/21.
//

import Foundation
import Network
import FinanceEntity

struct CardOnFileRequest: Request {
    typealias Output = CardOnFileResponse
    
    var endpoint: URL
    var method: HTTPMethod
    var query: QueryItems
    var header: HTTPHeader
    
    init(baseURL: URL) {
        self.endpoint = baseURL.appendingPathComponent("/cards")
        self.method = .get
        self.query = [:]
        self.header = [:]
    }
}

struct CardOnFileResponse: Decodable {
    let cards: [PaymentMethod]
}
