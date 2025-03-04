//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by 김찬수 on 2023/03/20.
//

import Foundation
import ModernRIBs

import AppHome
import FinanceHome
import ProfileHome
import FinanceRepository

import TransportHome
import TransportHomeImpl

import Topup
import TopupImpl

import AddPaymentMethod
import AddPaymentMethodImpl

import Network
import NetworkImpl

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency, TopupDependency, AddPaymentMethodDependency  {

    var cardsOnFileRepository: CardOnFileRepository
    var superPayRepository: SuperPayRepository
    
    lazy var transportHomeBuildable: TransportHomeBuildable = {
        return TransportHomeBuilder(dependency: self)
    }()
    
    lazy var topupBuildable: TopupBuildable = {
        return TopupBuilder(dependency: self)
    }()
    
    lazy var addPaymentMethodBuildable: AddPaymentMethodBuildable = {
       return AddPaymentMethodBuilder(dependency: self)
    }()
    
    var topupBaseViewController: ViewControllable { rootViewcontroller.topViewControllable }
    
    private let rootViewcontroller: ViewControllable
    
    init(
        dependency: AppRootDependency,
        rootViewcontroller: ViewControllable
    ) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [SuperAppURLProtocol.self]
        
        setupURLProtocol()
        
        let network = NetworkImp(session: URLSession(configuration: config))
        
        self.cardsOnFileRepository = CardOnFileRepositoryImpl(
            network: network,
            baseURL: BaseURL().financeBaseURL
        )
        
        self.cardsOnFileRepository.fetch()
        
        self.superPayRepository = SuperPayRepositoryImpl(
            network: network,
            baseURL: BaseURL().financeBaseURL
        )
        self.rootViewcontroller = rootViewcontroller
        super.init(dependency: dependency)
    }
}
