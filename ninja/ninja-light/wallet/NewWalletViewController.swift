//
//  NewWalletViewController.swift
//  ninja-light
//
//  Created by wesley on 2021/4/5.
//

import UIKit

class NewWalletViewController: UIViewController {

        @IBOutlet weak var password2: UITextField!
        @IBOutlet weak var password1: UITextField!
        
        override func viewDidLoad() {
                super.viewDidLoad()
                self.hideKeyboardWhenTappedAround()
        }
    
        @IBAction func CreateWallet(_ sender: UIButton) {
                guard let password = self.password1.text,password != ""else {
                        self.toastMessage(title: "Password can't be empty")
                        return
                }
                if password != self.password2.text{
                        self.toastMessage(title: "2 passwords are not same")
                        return
                }
                
                do {
                        try Wallet.shared.New(password)
                        ServiceDelegate.InitService()
                        _ = Wallet.shared.Active(password)
                        
                        if #available(iOS 13.0, *) {
                                let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                                sceneDelegate.window!.rootViewController =  instantiateViewController(vcID: "NinjaHomeTabVC")
                        } else {
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.window?.rootViewController = instantiateViewController(vcID: "NinjaHomeTabVC")
                                appDelegate.window?.makeKeyAndVisible()
                        }
                        
                }catch let err as NSError{
                        self.toastMessage(title: err.localizedDescription)
                }
        }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
