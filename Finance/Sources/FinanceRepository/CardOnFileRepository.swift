//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by kimchansoo on 2023/03/06.
//

import Foundation
import Combine
import FinanceEntity
import CombineUtil
import Network

public protocol CardOnFileRepository {
    var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
    func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error>
    func fetch()
}

public final class CardOnFileRepositoryImpl: CardOnFileRepository {
    
    public var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodsSubject }
    
    private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([])
    
    public func addCard(info: AddPaymentMethodInfo) -> AnyPublisher<PaymentMethod, Error> {
        
        let request = AddCardRequest(
            baseURL: baseURL,
            info: info
        )
        
        return network.send(request)
            .map(\.output.card)
            .handleEvents(
                receiveSubscription: nil,
                receiveOutput: { [weak self] method in
                    guard let this = self else { return }
                    this.paymentMethodsSubject.send(this.paymentMethodsSubject.value + [method])
                },
                receiveCompletion: nil,
                receiveCancel: nil,
                receiveRequest: nil
            )
            .eraseToAnyPublisher()
        
        let paymentMethod = PaymentMethod(id: "00", name: "New 카드", digits: "\(info.number.suffix(4))", color: "", isPrimary: false)
        var new = paymentMethodsSubject.value
        new.append(paymentMethod)
        paymentMethodsSubject.send(new)
        return Just(paymentMethod).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    public func fetch() {
        let request = CardOnFileRequest(baseURL: baseURL)
        return network.send(request)
            .map(\.output.cards)
            .sink(
                receiveCompletion: {_ in },
                receiveValue: { [weak self] cards in
                    self?.paymentMethodsSubject.send(cards)
                }
            )
            .store(in: &cancellables)
            
    }
    
    private let network: Network
    private let baseURL: URL
    
    private var cancellables: Set<AnyCancellable>
    
    public init(network: Network, baseURL: URL) {
        self.network = network
        self.baseURL = baseURL
        self.cancellables = .init()
    }
}
