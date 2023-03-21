//
//  AddPaymentMethodInfo.swift
//  MiniSuperApp
//
//  Created by kimchansoo on 2023/03/14.
//

import Foundation

public struct AddPaymentMethodInfo {
    public let number: String
    public let cvc: String
    public let expriration: String
    
    public init(
        number: String,
        cvc: String,
        expriration: String
    ) {
        self.number = number
        self.cvc = cvc
        self.expriration = expriration
    }
}
