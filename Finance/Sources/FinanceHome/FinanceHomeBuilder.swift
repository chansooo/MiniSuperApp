import ModernRIBs
import FinanceRepository
import AddPaymentMethod
import CombineUtil
import Topup

public protocol FinanceHomeDependency: Dependency {
    var cardsOnFileRepository: CardOnFileRepository { get }
    var superPayRepository: SuperPayRepository { get }
    var topupBuildable: TopupBuildable { get }
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency {
        
    var cardsOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
    var superPayRepository: SuperPayRepository { dependency.superPayRepository }

    var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
    
    var topupBuildable: TopupBuildable { dependency.topupBuildable }
    
    var addPaymentMethodBuildable: AddPaymentMethodBuildable { dependency.addPaymentMethodBuildable }
}

// MARK: - Builder

public protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> ViewableRouting
}

public final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    public override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    // 근데 그럼 interactor는 어디서 잡아두고 있을까?
    // builder에서 프로퍼티고 FinanceHomeInteractor를 잡고 있어야 메모리에서 해제가 되지 않는 것 아닌가?
    public func build(withListener listener: FinanceHomeListener) -> ViewableRouting {
        
        let viewController = FinanceHomeViewController()
        
        let component = FinanceHomeComponent(dependency: dependency)
        
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let superPayDashoardBuilder = SuperPayDashboardBuilder(dependency: component)
        
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashboardBuildable: superPayDashoardBuilder,
            cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
            addPaymentMethodBuildable: component.addPaymentMethodBuildable,
            topupBuildable: component.topupBuildable
        )
    }
}
