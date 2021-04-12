//
//  MsgViewController.swift
//  ninja
//
//  Created by wesley on 2021/3/30.
//

import UIKit

class MsgViewController: UIViewController {
        
        @IBOutlet weak var sender: UITextView!
        @IBOutlet weak var receiver: UITextView!
        @IBOutlet weak var peerNickName: UINavigationItem!
        var peerUid:String?
        var contactData:ContactItem?
        
        override func viewDidLoad() {
                super.viewDidLoad()
                self.hideKeyboardWhenTappedAround()
                self.populateView()
        }
        
        private func populateView(){
                guard let uid = peerUid else {
                        return
                }
                
                contactData = ContactItem.cache[uid]
                self.peerNickName.title = contactData?.nickName
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
extension MsgViewController:UITextViewDelegate{
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                
                if (text == "\n"){
                        textView.resignFirstResponder()
                        guard let msg = self.sender.text else{
                                return false
                        }
                        let cliMsg = CliMessage.init(data: msg.data(using: .utf8)!)
                        guard let err = WebsocketSrv.shared.SendIMMsg(to: peerUid!, payLoad: cliMsg) else{
                                return false
                        }
                        self.toastMessage(title: err.localizedDescription)
                        return false
                }
                return true
        }
}
