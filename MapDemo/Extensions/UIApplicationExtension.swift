//
//  UIApplicationExtension.swift
//  MapDemo
//
//  Created by dinh vien  on 12/03/2022.
//

import Foundation
import UIKit

extension UIApplication {
    
    @objc public static func setSharedStatusBarStyle(_ style: UIStatusBarStyle = UIStatusBarStyle.default,animated:Bool = true) {
        UIApplication.shared.setStatusBarStyle(style, animated: animated)
    }
    
    @objc open class func topViewController(_ inputBase: UIViewController? = nil ) -> UIViewController {
        var base : UIViewController? = inputBase
        
        if(base == nil) {
            if let delegateWindow = UIApplication.shared.delegate?.window,let window = delegateWindow {
                base = window.rootViewController
            }
            else {
                base = UIApplication.shared.keyWindow?.rootViewController
            }
            
        }
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController ?? nav.topViewController ?? nav.viewControllers.first)
        }
        
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let split = base as? UISplitViewController {
            return topViewController(split.viewControllers.first)
        }
        
        if let presented = base?.presentedViewController {
            if (presented is UINavigationController) && (presented as! UINavigationController).viewControllers.count == 0 {
                return base!
            }
            return topViewController(presented)
        }
        
        return base ?? UIViewController()
    }
    
    @objc public static func setSharedStatusBarHidden(_ isHidden : Bool,animated:Bool = true, animationType: UIStatusBarAnimation = .fade) {
        UIApplication.shared.setStatusBarHidden(isHidden, with: animationType)
    }
    
    @objc public static func iOS_VERSION_GREATER_THAN(version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }
}
