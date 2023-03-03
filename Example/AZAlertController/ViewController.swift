//
//  ViewController.swift
//  AZAlertController
//
//  Created by minkook on 03/03/2023.
//  Copyright (c) 2023 minkook. All rights reserved.
//

import UIKit
import AZAlertController

class ViewController: UIViewController {

    private let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button.setTitle("Test", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(touchButtonAction), for: .touchUpInside)
        button.frame = .init(origin: .zero, size: .init(width: 100, height: 50))
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 25.0
        self.view.addSubview(button)
        
        UIAlertController.az.config = CustomConfig()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        button.center = self.view.center
    }
    
    @objc
    func touchButtonAction(_ sender: UIButton) {
        UIAlertController.az(message: "Test Alert")
            .addCancelAction()
            .show(self)
    }
}


struct CustomConfig: AZAlertConfig {
    var defaultActionTitle: String { "확인" }
    var cancelActionTitle: String { "취소" }
}
