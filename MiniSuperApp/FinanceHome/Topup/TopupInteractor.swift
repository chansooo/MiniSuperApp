//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by kimchansoo on 2023/03/14.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    
    func attachAddPaymentMethod(closebuttonType: DismissButtonType)
    func detachAddPaymentMethod()
    
    func attachEnterAmount()
    func detachEnterAmount()
    
    func attachCardOnFile(paymentMethod: [PaymentModel])
    func detachCardOnFile()
    
    func popToRoot()
}

protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
}

protocol TopupInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
    var paymentMethodStream: CurrentValuePublisher<PaymentModel> { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy

    private var isEnterAmountRoot = false
    
    weak var router: TopupRouting?
    weak var listener: TopupListener?

    private let dependency: TopupInteractorDependency
    
    private var paymentMethods: [PaymentModel] {
        dependency.cardsOnFileRepository.cardOnFile.value
    }
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(dependency: TopupInteractorDependency) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        if let card = dependency.cardsOnFileRepository.cardOnFile.value.first {
            isEnterAmountRoot = true
            dependency.paymentMethodStream.send(card)
            router?.attachEnterAmount()
        } else {
            isEnterAmountRoot = false
            router?.attachAddPaymentMethod(closebuttonType: .close)
        }
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func addPaymentMethodDidTapClose() {
        router?.detachAddPaymentMethod()
        if isEnterAmountRoot == false {
            listener?.topupDidClose()
        }
//        listener?.topupDidClose()
    }
    
    func presentationControllerDidDismiss() {
        listener?.topupDidClose()
    }
    
    func addPaymentMethodDidAddCard(paymentMethod: PaymentModel) {
        dependency.paymentMethodStream.send(paymentMethod)
        
        if isEnterAmountRoot {
            router?.popToRoot()
        } else {
            isEnterAmountRoot = true
            router?.attachEnterAmount()
        }
    }
    
    
    func enteramountDidTapClose() {
        router?.detachEnterAmount()
        listener?.topupDidClose()
    }
    
    func enteramountDidTapPaymentMethod() {
        router?.attachCardOnFile(paymentMethod: paymentMethods)
    }
    
    func enterAmountDidFinishTopup() {
        listener?.topupDidFinish()
    }
    
    func cardOnFileDidTapClose() {
        router?.detachCardOnFile()
    }
    
    func cardOnfileDidTapAddCard() {
        router?.attachAddPaymentMethod(closebuttonType: .back)
    }

    func cardOnFiledidSelect(at index: Int) {
        if let selected = paymentMethods[safe: index] {
            dependency.paymentMethodStream.send(selected)
        }
        
        router?.detachCardOnFile()
    }
}
