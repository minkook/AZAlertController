//
//  UIViewController+TopMostViewController.swift
//  AZAlertController
//
//  Created by minkook yoo on 2023/03/03.
//

import UIKit

extension UIViewController {
    var topmostViewController: UIViewController? {
        var vc = self
        while let newViewController = vc.presentedViewController {
            vc = newViewController
        }
        return vc
    }
}

extension UIApplication {
    var topmostViewController: UIViewController? {
        self.windows.first?.topmostViewController
    }
}

extension UIWindow {
    var topmostViewController: UIViewController? {
        self.rootViewController?.topmostViewController
    }
}
