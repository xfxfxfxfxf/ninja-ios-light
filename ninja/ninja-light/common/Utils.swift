//
//  Utils.swift
//  ninja-light
//
//  Created by wesley on 2021/4/5.
//

import Foundation
import UIKit

public func instantiateViewController(vcID: String) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main);
    return storyboard.instantiateViewController(withIdentifier: vcID);
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
