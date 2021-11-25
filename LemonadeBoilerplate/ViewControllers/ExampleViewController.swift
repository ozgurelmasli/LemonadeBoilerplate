//
//  ExampleViewController.swift
//  LemonadeBoilerplate
//
//  Created by Mac on 22.11.2021.
//

import UIKit

class ExampleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ExampleViewController: BaseViewController<ExampleViewModel, ExampleView> {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
