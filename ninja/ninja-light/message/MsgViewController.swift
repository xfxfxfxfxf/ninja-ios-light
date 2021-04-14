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
        var peerUid:String = ""
        var contactData:ContactItem?
        
        override func viewDidLoad() {
                super.viewDidLoad()
                self.hideKeyboardWhenTappedAround()
                self.populateView()
                NotificationCenter.default.addObserver(self,
                                                       selector:#selector(newMsg(notification:)),
                                                       name: NotifyMessageAdded,
                                                       object: nil)
                
                NotificationCenter.default.addObserver(self,
                                                       selector:#selector(contactUpdate(notification:)),
                                                       name: NotifyContactChanged,
                                                       object: nil)
                guard let msges = MessageItem.cache[self.peerUid] else{
                        return
                }
                self.receiver.text = msges.toString()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        override func viewDidDisappear(_ animated: Bool) {
                super.viewDidDisappear(animated)
                ServiceDelegate.workQueue.async {
                        ChatItem.CachedChats[self.peerUid]?.resetUnread()
                        MessageItem.removeRead(self.peerUid)
                }
        }
        
        @objc func contactUpdate(notification:NSNotification){
                contactData = ContactItem.cache[peerUid]
                DispatchQueue.main.async {
                        self.peerNickName.title = self.contactData?.nickName ?? self.peerUid
                }
        }
        @objc func newMsg(notification:NSNotification){
                guard  let uid = notification.userInfo?[MessageItem.NotiKey] as? String else {
                        return
                }
                
                if uid != self.peerUid{
                        return
                }
                
                guard let msges = MessageItem.cache[self.peerUid] else{
                        return
                }
                
                DispatchQueue.main.async {
                        self.receiver.text = msges.toString()
                }
        }
        @IBAction func EditContactInfo(_ sender: UIBarButtonItem) {
                self.performSegue(withIdentifier: "EditContactDetailsSEG", sender: self)
        }
        
        private func populateView(){
                contactData = ContactItem.cache[peerUid]
                self.peerNickName.title = contactData?.nickName ?? peerUid
        }
    
        // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "EditContactDetailsSEG"{
                        let vc : ContactDetailsViewController = segue.destination as! ContactDetailsViewController
                        vc.itemUID = peerUid
                }
        }
}

extension MsgViewController:UITextViewDelegate{
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
                
                if (text == "\n"){
                        guard let msg = self.sender.text else{
                                return false
                        }
                        let cliMsg = CliMessage.init(to:peerUid, data: msg)
                        guard let err = WebsocketSrv.shared.SendIMMsg(cliMsg: cliMsg) else{
                                textView.text = nil
                                receiver.insertText("[me]:" + msg + "\r\n")
                                return false
                        }
                        self.toastMessage(title: err.localizedDescription)
                        return false
                }
                return true
        }
}
