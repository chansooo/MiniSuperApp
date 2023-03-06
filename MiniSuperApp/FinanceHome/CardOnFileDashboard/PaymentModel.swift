//
//  PaymentModel.swift
//  MiniSuperApp
//
//  Created by kimchansoo on 2023/03/06.
//

import Foundation

struct PaymentModel: Decodable {
    let id: String
    let name: String
    let digits: String
    let color: String
    let isPrimary: Bool
}
