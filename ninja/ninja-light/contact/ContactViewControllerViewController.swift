//
//  ViewController.swift
//  ninja
//
//  Created by wesley on 2021/3/30.
//

import UIKit

class ContactViewController: UIViewController{

        var selectedRow:Int?
        var NewCodeStr:String?
        
        @IBOutlet weak var tableview: UITableView!
        override func viewDidLoad() {
                super.viewDidLoad()
                
                NotificationCenter.default.addObserver(self, selector:#selector(notifiAction(notification:)),
                                                               name: NotifyContactChanged, object: nil)
                
                self.tableview.rowHeight = 60
                self.reload()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        @objc func notifiAction(notification:NSNotification){
                self.reload()
        }
        
        override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                guard Wallet.shared.IsActive() else{
                        self.activeAccount()
                        return
                }
        }
        
        private func activeAccount(){
                self.showIndicator(withTitle:"Wallet",  and: "Opening")
                
                let ap = AlertPayload(title: "Unlock", placeholderTxt: "Password"){
                        (password, isOK) in
                        
                        defer{
                                self.hideIndicator()
                        }
                        guard let pwd = password, isOK else{
                                self.toastMessage(title: "no right to load contact")
                                return
                        }
                        guard let err = ServiceDelegate.InitService(pwd) else{
                                self.reload()
                                return
                        }
                        self.toastMessage(title: err.localizedDescription)
                }
                
                LoadAlertFromStoryBoard(payload: ap)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "ShowQRScanerID"{
                        let vc : ScannerViewController = segue.destination as! ScannerViewController
                        vc.delegate = self
                }else if segue.identifier == "ContactDetailsViewController"{
                        let vc : ContactDetailsViewController = segue.destination as! ContactDetailsViewController
                        guard let idx = self.selectedRow else{
                                vc.itemUID = self.NewCodeStr
                                return
                        }
                        let item = ContactItem.cache[idx]
                        vc.itemData = item
                }
        }
        
        @IBAction func NewContact(_ sender: UIBarButtonItem) {
                self.performSegue(withIdentifier: "ShowQRScanerID", sender: self)
        }
        
        private func reload(){
                ContactItem.LocalSavedContact()
                DispatchQueue.main.async {
                        self.tableview.reloadData()
                }
        }
}

extension ContactViewController:ScannerViewControllerDelegate{
        
        func codeDetected(code: String) {
                NSLog("\(code)")
                if !ContactItem.IsValidContactID(code){
                        self.toastMessage(title: "invalid ninja address")
                        return
                }
                
                self.NewCodeStr = code
                self.performSegue(withIdentifier: "ContactDetailsViewController", sender: self)
        }
}
extension ContactViewController:UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return ContactItem.cache.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactItemTableViewCell", for: indexPath)
                if let c = cell as? ContactItemTableViewCell{
                        let item = ContactItem.cache[indexPath.row]
                        c.initWith(details:item, idx: indexPath.row)
                        return c
                }
                return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                self.selectedRow = indexPath.row
                self.performSegue(withIdentifier: "ContactDetailsViewController", sender: self)
        }
}
