//
//  Coordinator.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//
import UIKit

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    var presenterViewController: UIViewController? { get set }
    var parentCoordinator: Coordinator? { get set }
    /// Launch view controller and other elements in here
    func start(coordinator: Coordinator)
    /// After navigate back or dismiss func delete coordinator from child coordinators
    func didFinish(coordinator: Coordinator)
    /// Clear all chlids
    func removeChildCoordinators()
    /// Overrride this func use for creating VC , ViewModels and other elements
    func start()
    /// Navigate back func if navigation exists
    func pop( _ animated: Bool)
    /// Segue with view controller and custom animation
    func segue(viewController: UIViewController, _ animated: Bool, transition: UIView.AnimationOptions?)
    /// Present
    func present(modalPresentationStyle: UIModalPresentationStyle, viewController: UIViewController)
    /// Add child to parent
    func addAsChild(viewController: UIViewController, removeAll: Bool)
    
    func removeAllChild()
}

public class BaseCoordinator: Coordinator {
    /**
     Segue function
     
     - parameter viewController: Which view controller will be shown after segue.
     - parameter animated: default value 'false'
     - parameter transition: Default value is flipfromLeft. If you want use this function , send animated param as true
     ```
     */
    public func segue(viewController: UIViewController, _ animated: Bool = false, transition: UIView.AnimationOptions? = nil) {
        guard let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.appCoordinator?.window else { return }
        if animated {
            UIView.transition(with: window, duration: 0.5, options: transition ?? .transitionFlipFromLeft, animations: {
                                window.rootViewController = viewController
                                window.makeKeyAndVisible()
                              })

        } else {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
    
    /// Current coordinator navigation item
    public var navigationController: UINavigationController?
    public var presenterViewController: UIViewController?
    ///
    public var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    
    public func start() {
        fatalError("Start method should be implemented.")
    }
    /// Starting coordinator and adding coordinator as chlid
    public func start(coordinator: Coordinator) {
        childCoordinators += [coordinator]
        coordinator.parentCoordinator = self
        coordinator.navigationController = navigationController
        coordinator.start()
    }
    /// Remove coordinator ( segue , dismiss , navigate back )
    public func didFinish(coordinator: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: {$0 === coordinator}) else { return }
        childCoordinators.remove(at: index)
    }
    /// Navigation back
    public func pop(_ animated: Bool) {
        removeChildCoordinators()
        parentCoordinator?.didFinish(coordinator: self)
        navigationController?.popViewController(animated: true)
    }
    /// Clear all child coordinators.
    public func removeChildCoordinators() {
        childCoordinators.forEach { $0.removeChildCoordinators() }
        childCoordinators.removeAll()
    }
    
    public func present(modalPresentationStyle: UIModalPresentationStyle, viewController: UIViewController) {
        viewController.modalPresentationStyle = modalPresentationStyle
        parentCoordinator?.presenterViewController?.present(viewController, animated: true, completion: nil)
    }
    
    public func addAsChild(viewController: UIViewController, removeAll: Bool) {
        if removeAll {
            let childs: [UIViewController] = parentCoordinator?.presenterViewController?.children ?? []
            if !childs.isEmpty {
                for child in childs {
                    child.willMove(toParent: nil)
                    child.view.removeFromSuperview()
                    child.removeFromParent()
                }
            }
        }

        parentCoordinator?.presenterViewController?.addChild(viewController)
        parentCoordinator?.presenterViewController?.view.addSubview(viewController.view)
        viewController.didMove(toParent: parentCoordinator?.presenterViewController)
    }
    public func removeAllChild() {
        guard let children = parentCoordinator?.presenterViewController?.children, !children.isEmpty else { return }
        children.forEach { child in
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    
    
}
