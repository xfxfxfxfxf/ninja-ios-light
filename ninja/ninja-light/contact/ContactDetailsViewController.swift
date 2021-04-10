//
//  NewContactViewController.swift
//  ninja-light
//
//  Created by hyperorchid on 2021/4/8.
//

import UIKit

class ContactDetailsViewController: UIViewController {
        
        @IBOutlet weak var remarks: UITextView!
        @IBOutlet weak var uid: UILabel!
        @IBOutlet weak var nickName: UITextField!
        @IBOutlet weak var avatar: UIImageView!
        var itemUID:String?
        var itemData:ContactItem?
        
        override func viewDidLoad() {
                super.viewDidLoad()
                if let newUid = self.itemUID{
                        if let obj = ContactItem.GetContact(newUid){
                                self.itemData = obj
                        }
                }
                
                self.populateView()
        }
        
        private func populateView(){
                guard let data = self.itemData else {
                        return
                }
                
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
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
