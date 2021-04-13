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
                                                               name: NotifyMessageAdded, object: nil)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        
        @objc func notifiAction(notification:NSNotification){
                guard  let uid = notification.userInfo?[MessageItem.NotiKey] as? String else {
                        return
                }
                
                if uid != self.peerUid{
                        return
                }
                
                guard let msges = MessageItem.cache[self.peerUid!] else{
                        return
                }
                
                DispatchQueue.main.async {
                        self.receiver.text = msges.toString()
                }
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
                        guard let msg = self.sender.text else{
                                return false
                        }
                        let cliMsg = CliMessage.init(to:peerUid!, data: msg)
                        guard let err = WebsocketSrv.shared.SendIMMsg(cliMsg: cliMsg) else{
                                textView.text = nil
                                receiver.insertText(msg + "\r\n")
                                return false
                        }
                        self.toastMessage(title: err.localizedDescription)
                        return false
                }
                return true
        }
}
