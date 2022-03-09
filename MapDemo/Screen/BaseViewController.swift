//
//  BaseViewController.swift
//  MapDemo
//
//  Created by dinh vien  on 24/02/2022.
//

import Foundation
import UIKit
import IQKeyboardManager
class BaseViewController: UIViewController {

    // MARK: - Properties
    private lazy var indicatorView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        let activity = UIActivityIndicatorView(style: .large)
        view.addSubview(activity)
        activity.tintColor = .white
        activity.startAnimating()
        activity.center = view.center
        
        return  view
    }()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Methods
    func showLoadingIndicator() {
        view.addSubview(indicatorView)
    }
    
    func hideLoadingIndicator() {
        if indicatorView.superview != nil {
            indicatorView.removeFromSuperview()
        }
    }
    
    func showAlertMessage(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
  
}
