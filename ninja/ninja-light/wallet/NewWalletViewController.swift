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

                // Do any additional setup after loading the view.
        }
    
        @IBAction func CreateWallet(_ sender: UIButton) {
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
