//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by kimchansoo on 2023/03/06.
//

import Foundation
import Combine

protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentModel]> { get }
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentModel, Error>
}

final class CardOnFileRepositoryImpl: CardOnFileRepository {
    
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentModel]> { paymentMethodsSubject }
    
    private let paymentMethodsSubject = CurrentValuePublisher<[PaymentModel]>([
        PaymentModel(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
        PaymentModel(id: "1", name: "신한카드", digits: "0143", color: "#3478f66ff", isPrimary: false),
        PaymentModel(id: "2", name: "현대카드", digits: "8121", color: "#78c5f5ff", isPrimary: false),
        PaymentModel(id: "3", name: "국민카드", digits: "2812", color: "#65c466ff", isPrimary: false),
        PaymentModel(id: "4", name: "카카오뱅크", digits: "9686", color: "#ffcc00ff", isPrimary: false),
    ])
    
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentModel, Error> {
        let paymentMethod = PaymentModel(id: "00", name: "New 카드", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)
        var new = paymentMethodsSubject.value
        new.append(paymentMethod)
        paymentMethodsSubject.send(new)
        return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
