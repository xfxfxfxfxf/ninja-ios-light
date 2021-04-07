//
//  WalletViewController.swift
//  ninja
//
//  Created by wesley on 2021/3/30.
//

import UIKit

class WalletViewController: UIViewController {

        
        @IBOutlet weak var nickName: UILabel!
        @IBOutlet weak var avatarImg: UIImageView!
        @IBOutlet weak var address: UILabel!
        
        override func viewDidLoad() {
                super.viewDidLoad()
                address.text = Wallet.shared.Addr
        }
    
        @IBAction func QRCodeShow(_ sender: Any) {
                guard let addr = self.address.text else {
                        return
                }
                self.ShowQRAlertView(data: addr)
        }
        
        @IBAction func Copy(_ sender: UIButton) {
                UIPasteboard.general.string = Wallet.shared.Addr
                self.toastMessage(title: "Copy Success")
        }
        
        @IBAction func ChangeNickName(_ sender: UIButton) {
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
