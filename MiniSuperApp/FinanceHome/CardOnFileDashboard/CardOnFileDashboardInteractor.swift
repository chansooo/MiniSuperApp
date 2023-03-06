//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by kimchansoo on 2023/03/06.
//

import ModernRIBs
import Combine

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileFashboardInteractorDependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    

    
    private var cancellables: Set<AnyCancellable>
    
    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener?
    
    private let dependency: CardOnFileFashboardInteractorDependency

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: CardOnFileDashboardPresentable,
        dependency: CardOnFileFashboardInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        dependency.cardsOnFileRepository.cardOnFile.sink { models in
            // 여기 init 바로 넣은거 잘 봐
            let viewmodels = models.prefix(3).map(PaymentMethodViewModel.init)
            self.presenter.update(with: viewmodels)
        }.store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
        
        // didbecomeactive에서 weak self 안해줘도 되는게 여기서 cancellable 비워주면 잡혀있는 애들도 사라짐. 근데 이 로직을 다시 한번 생각해봐야함
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didTapAddPaymentMethod() {
        listener?.cardOnFileDashboardDidTapAddPaymentMethod()
    }
}
