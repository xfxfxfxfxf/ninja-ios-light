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
                        return//TODO::tips
                }
                if password != self.password2.text{
                        return//TODO::tips
                }
                
                do {
                        try Wallet.shared.New(password)
                        let sceneDelegate = UIApplication.shared.connectedScenes
                                .first!.delegate as! SceneDelegate
                            sceneDelegate.window!.rootViewController =  instantiateViewController(vcID: "NinjaHomeTabVC")
                }catch let err as NSError{
                        print("\(err)", "\(err.userInfo)")
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
