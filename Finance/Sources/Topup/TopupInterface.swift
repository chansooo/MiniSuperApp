//
//  File.swift
//  
//
//  Created by 김찬수 on 2023/03/20.
//

import Foundation
import ModernRIBs

public protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
}

public protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> Routing
}

