//
//  ViewController.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//
import UIKit

protocol ViewController : AnyObject {
    /// View controller view model
    var viewModel : ViewModel { get set }
    
    func alertCancelAction()
}

class BaseViewController<VM : ViewModel , V : UIView> : UIViewController, ViewController {
    /// Override this function if you want to give new operation when cancel button tapped in error state
    func alertCancelAction() { }
    
    var viewModel: ViewModel
    var safeViewModel : VM { return (viewModel as! VM) }
    var safeView : V { return (view as! V) }
    
    init(viewModel : VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        view = V()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: ViewModelAction function
extension BaseViewController : ViewModelErrorAction {
    func didErrorOccurred(_ state: UIError) {
        switch state {
        case .NETWORK_ERROR:
            break
            /// Sending NetworkError VC
          // let errorVC = NetworkErrorVC()
          // errorVC.modalPresentationStyle = .fullScreen
          // (errorVC.view as? NetworkErrorView)?.networkViewDelegate = self
          // present(errorVC , animated: true)
        case .REQUEST_ERROR:
            /// Create try request or cancel directly
            let alert = UIAlertController(title: "Alert", message: "Request has been failed. Try Again.", preferredStyle: .alert)
            let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
             //   self?.viewModel.tryRequest()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
                self?.alertCancelAction()
            })
            alert.addAction(tryAgainAction)
            alert.addAction(cancelAction)
            present(alert , animated: true)
        case .ALERT(let message):
            /// Create normal alert with custom message and cancel action
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
                self?.alertCancelAction()
            })
            alert.addAction(action)
            present(alert , animated: true)
        }
    }
}
