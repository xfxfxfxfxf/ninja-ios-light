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
                NotificationCenter.default.addObserver(self, selector:#selector(notifiAction(notification:)),
                                                               name: NotifyMessageChanged, object: nil)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        // MARK: -TOOD::
        @objc func notifiAction(notification:NSNotification){
                //TODO::
        }
        
        private func populateView(){
                guard let uid = peerUid else {
                        return
                }
                
                contactData = ContactItem.cache[uid]
                self.peerNickName.title = contactData?.nickName
        }
    
        // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        }
    
}

extension MsgViewController:UITextViewDelegate{
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                
                if (text == "\n"){
                        textView.resignFirstResponder()
                        guard let msg = self.sender.text else{
                                return false
                        }
                        let cliMsg = CliMessage.init(to:peerUid!, data: msg.data(using: .utf8)!)
                        guard let err = WebsocketSrv.shared.SendIMMsg(cliMsg: cliMsg) else{
                                textView.text = nil
                                return false
                        }
                        self.toastMessage(title: err.localizedDescription)
                        return false
                }
                return true
        }
}
