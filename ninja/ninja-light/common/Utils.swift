//
//  Utils.swift
//  ninja-light
//
//  Created by wesley on 2021/4/5.
//

import Foundation
import UIKit
import MBProgressHUD

public func instantiateViewController(vcID: String) -> UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main);
    return storyboard.instantiateViewController(withIdentifier: vcID);
}

public struct AlertPayload {
        var title:String!
        var placeholderTxt:String?
        var securityShow:Bool = true
        var keyType:UIKeyboardType = .default
        var action:((String?, Bool)->Void)!
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
        
        func showIndicator(withTitle title: String, and Description:String) {DispatchQueue.main.async {
                let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
                Indicator.label.text = title
                Indicator.isUserInteractionEnabled = false
                Indicator.detailsLabel.text = Description
                Indicator.show(animated: true)
        }}
        
        func createIndicator(withTitle title: String, and Description:String) -> MBProgressHUD{
                let Indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
                Indicator.label.text = title
                Indicator.isUserInteractionEnabled = false
                Indicator.detailsLabel.text = Description
                return Indicator
        }
        
        func toastMessage(title:String) ->Void {DispatchQueue.main.async {
                let hud : MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = MBProgressHUDMode.text
                hud.detailsLabel.text = title
                hud.removeFromSuperViewOnHide = true
                hud.margin = 10
                hud.offset.y = 250.0
                hud.hide(animated: true, afterDelay: 3)
        }}
        
 
        func CustomerAlert(name:String){ DispatchQueue.main.async {
                
                let alertVC = instantiateViewController(vcID:name)
                
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert);
                alertController.setValue(alertVC, forKey: "contentViewController");
                self.present(alertController, animated: true, completion: nil);
                }
        }
        
        func hideIndicator() {DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
        }}
        
        func ShowTips(msg:String){
                DispatchQueue.main.async {
                        let ac = UIAlertController(title: "Tips!", message: msg, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                }
        }
        
        func LoadAlertFromStoryBoard(payload:AlertPayload){ DispatchQueue.main.async {
                
                guard let alertVC = instantiateViewController(vcID: "PasswordViewControllerID")
                            as? PasswordViewController else{
                            return
                        }
                        
                        alertVC.payload = payload;
                        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert);
                        alertController.setValue(alertVC, forKey: "contentViewController");
                        self.present(alertController, animated: true, completion: nil);
                }
        }
}

extension MBProgressHUD{
        
        func setDetailText(msg:String) {
                 DispatchQueue.main.async {
                        self.detailsLabel.text = msg
                }
        }
}
