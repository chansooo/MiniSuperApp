//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by kimchansoo on 2023/02/28.
//

import ModernRIBs
import Combine
import Foundation

protocol SuperPayDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
    var listener: SuperPayDashboardPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func updateBalance(_ balance: String)
}

protocol SuperPayDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

// interactor 생성시 필요한 파라미터들 명세
protocol SuperPayDashboardInteractorDependency {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    var balanceFormatter: NumberFormatter { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {

    weak var router: SuperPayDashboardRouting?
    weak var listener: SuperPayDashboardListener?

    private let dependency: SuperPayDashboardInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    // dependency를 프로토콜로 선언하고 한 번에 받음으로써 생성하는 곳과 init에서 모두 고쳐야 하는 수고를 덜 수 있음
    // 여기의 dependency는 compoenent가 채택하는 dependency가 아닌 전달해야 하는 값을 모두 들고있는 추상화된 프로토콜
    
    init(
        presenter: SuperPayDashboardPresentable,
        dependency: SuperPayDashboardInteractorDependency
    ) {
        self.dependency = dependency
        
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        dependency.balance.sink { [weak self] balance in
            self?.dependency.balanceFormatter.string(from: NSNumber(value: balance)).map { self?.presenter.updateBalance($0)}
        }.store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
