//
//  UIAlertController+AZ.swift
//  AZAlertController
//
//  Created by minkook yoo on 2023/03/03.
//

import UIKit

extension UIAlertController {
    
    struct az {
        private let alert: UIAlertController
        
        init(title: String? = nil, message: String?, preferredStyle: UIAlertController.Style = .alert) {
            alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        }
        
        func show(_ viewController: UIViewController? = nil) {
            if let vc = viewController {
                _show(vc)
            } else {
                guard let vc = UIApplication.shared.topmostViewController else { return }
                _show(vc)
            }
        }
        
        func addDefaultAction(_ handler: ((UIAlertAction) -> Void)? = nil) -> Self {
            _addAction("확인", style: .cancel, handler: handler)
            return self
        }
        
        func addCancelAction(_ title: String = "취소", handler: ((UIAlertAction) -> Void)? = nil) -> Self {
            _addAction(title, style: .cancel, handler: handler)
            return self
        }
        
        func addDestructiveAction(_ title: String, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
            _addAction(title, style: .destructive, handler: handler)
            return self
        }
        
        func addCustomAction(_ title: String, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
            _addAction(title, style: .default, handler: handler)
            return self
        }
        
        struct Action {
            let title: String
            var handler: ((UIAlertAction) -> Void)? = nil
        }
        
        func addCustomActions(_ actions: [Action]) -> Self {
            actions.forEach { _addAction($0.title, style: .default, handler: $0.handler) }
            return self
        }
    }
}

// MARK: -
fileprivate extension UIAlertController.az {
    
    func _show(_ vc: UIViewController) {
        if alert.actions.isEmpty {
            _ = addDefaultAction()
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                // ActionSheet가 표현되는 위치를 지정
                popoverController.sourceView = vc.view
                popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        
        if Thread.isMainThread {
            vc.present(alert, animated: true)
        } else {
            DispatchQueue.main.async {
                vc.present(alert, animated: true)
            }
        }
    }
    
    func _addAction(_ title: String, style: UIAlertAction.Style,  handler: ((UIAlertAction) -> Void)?) {
        if style == .cancel && alert.actions.contains(where: { $0.style == .cancel }) { return }
        if style == .destructive && alert.actions.contains(where: { $0.style == .destructive }) { return }
        
        alert.addAction(.init(title: title, style: style, handler: { act in
            if Thread.isMainThread {
                handler?(act)
            } else {
                DispatchQueue.main.async {
                    handler?(act)
                }
            }
        }))
    }
}
