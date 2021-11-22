//
//  ViewModel.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import Foundation

public protocol ViewModel : AnyObject {
    var coordinator : BaseCoordinator? { get set }
}

public class BaseViewModel<C : BaseCoordinator>: ViewModel {
    public var coordinator: BaseCoordinator?
    
    public var safeCoordinator : C {
        return (coordinator as! C)
    }

    init(coordinator : C) {
        self.coordinator = coordinator
    }
    /// Pop function
    func pop( _ animated : Bool = true) {
        coordinator?.pop(animated)
    }
}
