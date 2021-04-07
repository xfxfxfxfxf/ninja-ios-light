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
        
        
        var refreshControl = UIRefreshControl()
        override func viewDidLoad() {
                super.viewDidLoad()
                
                tableView.rowHeight = 80
                refreshControl.addTarget(self, action: #selector(self.reloadChatRoom(_:)), for: .valueChanged)
                tableView.addSubview(refreshControl)
        }
        //MARK: - object c
        @objc func reloadChatRoom(_ sender: Any?){
                guard Wallet.shared.IsActive() else{
                        self.online()
                        self.reloadChatRoom(nil)
                        return
                }
                
                ServiceDelegate.workQueue.async {
                        ChatItem.ReloadChatRoom()
                        DispatchQueue.main.async {
                                self.refreshControl.endRefreshing()
                                self.tableView.reloadData()
                        }
                }
        }
        
        override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                
                guard Wallet.shared.loaded else{
                        self.performSegue(withIdentifier: "CreateNewAccountSeg", sender: self)
                        return
                }
                
                guard Wallet.shared.IsActive() else{
                        self.online()
                        return
                }
        }
        
        private func online(){
                self.showIndicator(withTitle:"Wallet",  and: "Opening")
                
                let ap = AlertPayload(title: "Unlock", placeholderTxt: "Password"){
                        (password, isOK) in
                        
                        defer{
                                self.hideIndicator()
                        }
                        guard let pwd = password, isOK else{
                                self.tableTopConstraint.constant = 30
                                self.errorTips.isHidden = false
                                self.errorTips.text = "App is Locked"
                                return
                        }
                        guard let err = ServiceDelegate.InitService(pwd) else{
                                self.tableTopConstraint.constant = 0
                                self.errorTips.isHidden = true
                                return
                        }
                        
                        DispatchQueue.main.async{
                                self.tableTopConstraint.constant = 30
                                self.errorTips.isHidden = false
                                self.errorTips.text = err.localizedDescription
                        }
                }
                
                LoadAlertFromStoryBoard(payload: ap)
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
}
