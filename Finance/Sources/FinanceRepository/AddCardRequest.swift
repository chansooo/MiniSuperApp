//
//  File.swift
//  
//
//  Created by 김찬수 on 2023/03/21.
//

import Foundation
import Network
import FinanceEntity

struct AddCardRequest: Request {
    
    typealias Output = AddCardResponse
    
    var endpoint: URL
    var method: HTTPMethod
    var query: QueryItems
    var header: HTTPHeader
    
    init(baseURL: URL, info: AddPaymentMethodInfo) {
        self.endpoint = baseURL.appendingPathComponent("/addCard")
        self.method = .post
        self.query = [
            "number": info.number,
            "cvc": info.cvc,
            "expiry": info.expriration
        ]
        self.header = [:]
    }
}

struct AddCardResponse: Decodable {
    let card: PaymentMethod
    
}
