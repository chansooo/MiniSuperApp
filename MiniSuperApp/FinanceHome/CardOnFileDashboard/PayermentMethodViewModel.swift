//
//  PayermentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by kimchansoo on 2023/03/06.
//

import UIKit

struct PaymentMethodViewModel {
    let name: String
    let digits: String
    let color: UIColor
    
    init(paymentModel: PaymentModel) {
        self.name = paymentModel.name
        self.digits = "**** \(paymentModel.digits)"
        self.color = UIColor(hex: paymentModel.color) ?? .systemGray2
    }
}
