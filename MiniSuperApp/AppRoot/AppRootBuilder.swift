import ModernRIBs
import UIKit

protocol AppRootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency  {
    var cardsOnFileRepository: CardOnFileRepository
    var superPayRepository: SuperPayRepository
    
    init(
        dependency: AppRootDependency,
        cardOnFileRepository: CardOnFileRepository,
        superPayRepository: SuperPayRepository
    ) {
        self.cardsOnFileRepository = cardOnFileRepository
        self.superPayRepository = superPayRepository
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol AppRootBuildable: Buildable {
    func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler)
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {
    
    override init(dependency: AppRootDependency) {
        super.init(dependency: dependency)
    }
    
    func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler) {
        let component = AppRootComponent(
            dependency: dependency,
            cardOnFileRepository: CardOnFileRepositoryImpl(),
            superPayRepository: SuperPayRepositoryImpl()
        )
        
        let tabBar = RootTabBarController()
        
        let interactor = AppRootInteractor(presenter: tabBar)
        
        // 세가지 자식 riblet을 붙이기 위해서 생성
        let appHome = AppHomeBuilder(dependency: component)
        let financeHome = FinanceHomeBuilder(dependency: component)
        let profileHome = ProfileHomeBuilder(dependency: component)
        let router = AppRootRouter(
            interactor: interactor,
            viewController: tabBar,
            appHome: appHome,
            financeHome: financeHome,
            profileHome: profileHome
        )
        
        return (router, interactor)
    }
}
