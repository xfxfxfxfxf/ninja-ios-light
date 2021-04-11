//
//  NewContactViewController.swift
//  ninja-light
//
//  Created by hyperorchid on 2021/4/8.
//

import UIKit

class ContactDetailsViewController: UIViewController {
        
        @IBOutlet weak var uid: UITextView!
        @IBOutlet weak var remarks: UITextView!
        @IBOutlet weak var nickName: UITextField!
        @IBOutlet weak var avatar: UIImageView!
        @IBOutlet weak var chatBtn: UIButton!
        var itemUID:String?
        var itemData:ContactItem?
        
        override func viewDidLoad() {
                super.viewDidLoad()
                self.hideKeyboardWhenTappedAround()
                self.populateView()
        }
        
        private func populateView(){
                
                if let newUid = self.itemUID{
                        if let obj = ContactItem.GetContact(newUid){
                                self.itemData = obj
                        }else{
                                self.uid.text = newUid
                                self.uid.isEditable = false
                        }
                }
                
                guard let data = self.itemData else {
                        return
                }
                self.chatBtn.isHidden = false
                self.uid.isEditable = false
                self.uid.text = data.uid
                self.nickName.text = data.nickName
                self.remarks.text = data.remark
                if data.avatar != nil{
                        self.avatar.image = UIImage.init(data: data.avatar!)
                }
        }
    
        private func closeWindow(){
                self.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
        }
        
        @IBAction func SaveContact(_ sender: UIButton) {
                let contact = ContactItem.init()
                contact.uid = self.uid.text
                contact.nickName = self.nickName.text
                contact.remark = remarks.text
//                contact.avatar = self.avatar.image?.pngData()//TODO::Load avatar from netework
                guard let err = ContactItem.AddNewContact(contact) else{
                        NotificationCenter.default.post(name:NotifyContactChanged,
                                                        object: nil, userInfo:nil)
                        self.closeWindow()
                        return
                }
                
                self.toastMessage(title: err.localizedDescription)
        }
        
        @IBAction func Cancel(_ sender: UIButton) {
                self.closeWindow()
        }
        
        @IBAction func StartChat(_ sender: UIButton) {
                guard self.itemData != nil else {
                        return
                }
                self.performSegue(withIdentifier: "ShowMessageDetailsSEG", sender: self)
        }
        
        
        /**/
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        }
}
