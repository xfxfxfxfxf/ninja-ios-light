//
//  MessageListViewController.swift
//  ninja-light
//
//  Created by wesley on 2021/4/7.
//

import UIKit

class MessageListViewController: UIViewController {
        @IBOutlet weak var errorTips: UILabel!
        @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
        @IBOutlet weak var tableView: UITableView!
        
        var SelectedRowID:Int? = nil
        var refreshControl = UIRefreshControl()
        override func viewDidLoad() {
                super.viewDidLoad()
                
                tableView.rowHeight = 80
                refreshControl.addTarget(self, action: #selector(self.reloadChatRoom(_:)), for: .valueChanged)
                tableView.addSubview(refreshControl)
        }
        //MARK: - object c
        @objc func reloadChatRoom(_ sender: Any?){
                if !Wallet.shared.IsActive(){
                        self.activeAccount()
                }
                
//                ServiceDelegate.workQueue.async {
//                        ChatItem.ReloadChatRoom()
//                        DispatchQueue.main.async {
//                                self.refreshControl.endRefreshing()
//                                self.tableView.reloadData()
//                        }
//                }
        }
        
        override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                self.hideErrorTips()
                
                guard Wallet.shared.loaded else{
                        self.performSegue(withIdentifier: "CreateNewAccountSeg", sender: self)
                        return
                }
                
                guard Wallet.shared.IsActive() else{
                        self.activeAccount()
                        return
                }
                
                guard WebsocketSrv.shared.IsOnline() else {
                        guard let err = WebsocketSrv.shared.Online() else{
                                return
                        }
                        NSLog("\(err.localizedDescription)")
                        showErrorTips(err: err)
                        return
                }
        }
        private func showErrorTips(err:Error){
                DispatchQueue.main.async{
                        self.tableTopConstraint.constant = 30
                        self.errorTips.isHidden = false
                        self.errorTips.text = err.localizedDescription
                }
        }
        private func hideErrorTips(){
                DispatchQueue.main.async{
                        self.tableTopConstraint.constant = 0
                        self.errorTips.isHidden = true
                        self.errorTips.text = ""
                }
        }
        
        private func activeAccount(){
                self.showIndicator(withTitle:"Wallet",  and: "Opening")
                
                let ap = AlertPayload(title: "Unlock", placeholderTxt: "Password"){
                        (password, isOK) in
                        
                       
                        self.hideIndicator()
//                                self.refreshControl.endRefreshing()
                        guard let pwd = password, isOK else{
                                self.toastMessage(title: "Must unlock account")
                                return
                        }
                        
                        guard let err = Wallet.shared.Active(pwd) else{
                                self.hideErrorTips()
                                return
                        }
                        NSLog("======>\(err.localizedDescription)")
                        self.toastMessage(title: err.localizedDescription)
                        return
                }
                
                LoadAlertFromStoryBoard(payload: ap)
        }

    
    // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "ShowMessageDetailsSEG"{
                        guard let idx = self.SelectedRowID else{
                                return
                        }
                        guard let vc = segue.destination as? MsgViewController else{
                                return
                        }
                        
                        let item = ChatItem.CachedChats[idx]
                        vc.chatID = item.ItemID
                }
                
        }
}

// MARK: - tableview
extension MessageListViewController: UITableViewDelegate ,  UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return ChatItem.CachedChats.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MesasgeItemTableViewCell", for: indexPath)
                if let c = cell as? MesasgeItemTableViewCell{
                        
                        let item = ChatItem.CachedChats[indexPath.row]
                        c.initWith(details:item, idx: indexPath.row)
                        return c
                }
                return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                self.SelectedRowID = indexPath.row
                self.performSegue(withIdentifier: "ShowMessageDetailsSEG", sender: self)
        }
}
