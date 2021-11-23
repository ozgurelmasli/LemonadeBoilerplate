//
//  ExampleCoordinator.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

class ExampleCoordinator : BaseCoordinator {
    
    
    override func start() {
        let coordinator : ExampleCoordinator = .init()
        let viewModel   : ExampleViewModel = .init(coordinator: coordinator)
        let exampleVC = ExampleViewController(viewModel: viewModel)
        segue(viewController: exampleVC)
    }
}
