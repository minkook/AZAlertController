//
//  UIAlertController+AZ.swift
//  AZAlertController
//
//  Created by minkook yoo on 2023/03/03.
//

import UIKit

extension UIAlertController {
    
    public struct az {
        
        /// Create Alert
        /// - Parameters:
        ///   - title: title (default is nil)
        ///   - message: message
        ///   - preferredStyle: UIAlertController.Style (default is .alert)
        public init(title: String? = nil, message: String?, preferredStyle: UIAlertController.Style = .alert) {
            alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        }
        
        /// Show Alert
        /// - Parameter viewController: UIViewController (default is TopmostViewController)
        /// If no action is added, the default action of AZAlertConfig is added.
        public func show(_ viewController: UIViewController? = nil) {
            if let vc = viewController {
                _show(vc)
            } else {
                guard let vc = UIApplication.shared.topmostViewController else { return }
                _show(vc)
            }
        }
        
        /// Alert Confing
        /// This can be changed using the AZAlertConfig protocol.
        public static var config: AZAlertConfig = DefaultConfig()
        
        private let alert: UIAlertController
    }
}


// MARK: -
/// Add Action Item
extension UIAlertController.az {
    
    /// Add Cancel Action
    /// - Parameters:
    ///   - title: title (default is AZAlertConfig.cancelActionTitle)
    ///   - handler: handler
    /// - Returns: az
    public func addCancelAction(_ title: String = "", handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        let _title = title.isEmpty ? UIAlertController.az.config.cancelActionTitle : title
        _addAction(_title, style: .cancel, handler: handler)
        return self
    }
    
    /// Add Destructive Action
    /// - Parameters:
    ///   - title: title
    ///   - handler: handler
    /// - Returns: az
    public func addDestructiveAction(_ title: String, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        _addAction(title, style: .destructive, handler: handler)
        return self
    }
    
    /// Add Custom Action
    /// - Parameters:
    ///   - title: title
    ///   - handler: handler
    /// - Returns: az
    public func addCustomAction(_ title: String, handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        _addAction(title, style: .default, handler: handler)
        return self
    }
}


// MARK: -
/// Add Action Items
extension UIAlertController.az {
    
    public struct Action {
        let title: String
        var handler: ((UIAlertAction) -> Void)? = nil
        
        public init(title: String, handler: ((UIAlertAction) -> Void)? = nil) {
            self.title = title
            self.handler = handler
        }
    }
    
    /// Add Custom Actions
    /// - Parameter actions: Action struct type array
    /// - Returns: az
    public func addCustomActions(_ actions: [Action]) -> Self {
        actions.forEach { _addAction($0.title, style: .default, handler: $0.handler) }
        return self
    }
}


// MARK: -
/// Config Protocol
public protocol AZAlertConfig {
    var defaultActionTitle: String { get }
    var cancelActionTitle: String { get }
}


// MARK: -
fileprivate extension UIAlertController.az {
    
    /// Default Action
    /// - Parameter handler: handler
    /// - Returns: az
    func addDefaultAction(_ handler: ((UIAlertAction) -> Void)? = nil) -> Self {
        _addAction(UIAlertController.az.config.defaultActionTitle, style: .cancel, handler: handler)
        return self
    }
}

fileprivate extension UIAlertController.az {
    
    /// Add Action (in MainThread)
    /// - Parameters:
    ///   - title: title
    ///   - style: alert action style
    ///   - handler: handler
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

fileprivate extension UIAlertController.az {
    
    /// Show (in MainThread)
    /// - Parameter vc: UIViewController
    /// If you use it as an actionSheet type on iPad, it will be displayed in the center.
    func _show(_ vc: UIViewController) {
        if alert.actions.isEmpty {
            _ = addDefaultAction()
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad && alert.preferredStyle == .actionSheet {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = vc.view
                popoverController.sourceRect = .init(origin: vc.view.center, size: .zero)
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
}

fileprivate struct DefaultConfig: AZAlertConfig {
    var defaultActionTitle: String { "Confirm" }
    var cancelActionTitle: String { "Cancel" }
}
