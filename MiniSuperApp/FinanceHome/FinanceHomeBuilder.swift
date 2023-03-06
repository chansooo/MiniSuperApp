import ModernRIBs

protocol FinanceHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency {
    var cardsOnFileRepository: CardOnFileRepository
    var balance: ReadOnlyCurrentValuePublisher<Double> { balancePublisher }
    
    private let balancePublisher: CurrentValuePublisher<Double>
    
    init(
        dependency: FinanceHomeDependency,
        balancePublisher: CurrentValuePublisher<Double>,
        cardOnFileRepository: CardOnFileRepository
    ) {
        self.balancePublisher = balancePublisher
        self.cardsOnFileRepository = cardOnFileRepository
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
        let balancePublisher = CurrentValuePublisher<Double>(10000)
        
        let component = FinanceHomeComponent(
            dependency: dependency,
            balancePublisher: balancePublisher,
            cardOnFileRepository: CardOnFileRepositoryImpl()
        )
        let viewController = FinanceHomeViewController()
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashoardBuilder = SuperPayDashboardBuilder(dependency: component)
        
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        
        let addPaymentBuilder = AddPaymentMethodBuilder(dependency: component)
        
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashboardBuildable: superPayDashoardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentMethodBuildable: addPaymentBuilder
        )
    }
}
