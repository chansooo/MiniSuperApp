import ModernRIBs

protocol FinanceHomeDependency: Dependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {
        
    var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }

    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    
    var topupBaseViewController: ViewControllable
    
    init(
        dependency: FinanceHomeDependency,
        topupBaseViewController: ViewControllable
    ) {
        self.topupBaseViewController = topupBaseViewController
        super.init(dependency: dependency)
    }
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    // 근데 그럼 interactor는 어디서 잡아두고 있을까?
    // builder에서 프로퍼티고 FinanceHomeInteractor를 잡고 있어야 메모리에서 해제가 되지 않는 것 아닌가?
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
        
        let viewController = FinanceHomeViewController()
        
        let component = FinanceHomeComponent(
            dependency: dependency,
            topupBaseViewController: viewController
        )
        
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashoardBuilder = SuperPayDashboardBuilder(dependency: component)
        
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        
        let addPaymentBuilder = AddPaymentMethodBuilder(dependency: component)
        
        let topupBuilder = TopupBuilder(dependency: component)
        
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashboardBuildable: superPayDashoardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentMethodBuildable: addPaymentBuilder,
            topupBuildable: topupBuilder
        )
    }
}
