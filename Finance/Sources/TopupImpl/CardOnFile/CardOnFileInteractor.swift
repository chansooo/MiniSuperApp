//
//  CardOnFileInteractor.swift
//  MiniSuperApp
//
//  Created by 김찬수 on 2023/03/16.
//

import ModernRIBs
import FinanceEntity


protocol CardOnFileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFilePresentable: Presentable {
    var listener: CardOnFilePresentableListener? { get set }
    
    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func cardOnFileDidTapClose()
    func cardOnfileDidTapAddCard()
    func cardOnFiledidSelect(at index: Int)
}

final class CardOnFileInteractor: PresentableInteractor<CardOnFilePresentable>, CardOnFileInteractable, CardOnFilePresentableListener {

    weak var router: CardOnFileRouting?
    weak var listener: CardOnFileListener?
    
    private let paymentMethods: [PaymentMethod]

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CardOnFilePresentable,
        paymentMethods: [PaymentMethod]
    ) {
        self.paymentMethods = paymentMethods
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        presenter.update(with: self.paymentMethods.map(PaymentMethodViewModel.init))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapClose() {
        listener?.cardOnFileDidTapClose()
    }
    
    func didSelectItem(at index: Int) {
        if index >= paymentMethods.count {
            listener?.cardOnfileDidTapAddCard()
        } else {
            listener?.cardOnFiledidSelect(at: index)
        }
    }
}
