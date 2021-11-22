//
//  ViewModel.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import Foundation

protocol ViewModel : AnyObject {
    var coordinator : BaseCoordinator? { get set }
    func tryRequest()
}

class BaseViewModel<C : BaseCoordinator>: ViewModel {
    func tryRequest() { }
    
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
