//
//  UISearchBarExtension.swift
//  MapDemo
//
//  Created by dinh vien  on 12/03/2022.
//

import Foundation
import UIKit

extension UISearchBar{

    func getClearSearchButton()-> UIButton?{
        
        guard let searchTextField = self.textField else {return nil}
        guard let clearButton     = searchTextField.value(forKey: "_clearButton") as? UIButton else {return nil}
        return clearButton
    }
    
    public func clearSearchText(onTap: (() -> Void)?){
        
    }
    
    public func setDefaultSearchBar(){
        self.barTintColor = UIColor.link
        self.tintColor    = UIColor.link
        self.cursorColor = UIColor.link
        
        self.textField?.textColor = UIColor.black
        self.textField?.backgroundColor = UIColor.white

        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.link.cgColor
        
        self.backgroundColor = UIColor.link
        self.placeholder = "Search"
        self.setShowsCancelButton(true, animated: true)
        
        if let cancel_btn = self.cancelButton {
            cancel_btn.setTitle("Cancel", for: .normal)
            cancel_btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            cancel_btn.sizeToFit()
        }
    }
    
    public var cursorColor: UIColor! {
        set {
            for subView in self.subviews[0].subviews where ((subView as? UITextField) != nil) {
                subView.tintColor = newValue
            }
        }
        get {
            for subView in self.subviews[0].subviews where ((subView as? UITextField) != nil) {
                return subView.tintColor
            }
            // Return default tintColor
            return UIColor.link
        }
    }
    
    //get SearchTextField
    public var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        }
        return self.value(forKey: "searchField") as? UITextField
    }
    
    public var cancelButton: UIButton? {
        if #available(iOS 13, *) {
            return subviews.last?.subviews.last?.subviews.last(where: {String(describing: $0).contains("UINavigationButton")}) as? UIButton
        } else {
            guard let cancel_btn = self.value(forKey: "_cancelButton") as? UIButton else {return nil}
            return cancel_btn
        }
    }
}
