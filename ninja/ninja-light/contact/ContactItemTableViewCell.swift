//
//  ContactItemTableViewCell.swift
//  ninja-light
//
//  Created by hyperorchid on 2021/4/8.
//

import UIKit

class ContactItemTableViewCell: UITableViewCell {

        @IBOutlet weak var nickName: UILabel!
        @IBOutlet weak var avatar: UIImageView!
        override func awakeFromNib() {
        super.awakeFromNib()
                // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
                super.setSelected(selected, animated: animated)
        }

        func initWith(details:ContactItem, idx: Int){
                if details.avatar != nil{
                        self.avatar.image = UIImage.init(data: details.avatar!)
                }
                self.nickName.text = details.nickName
        }
}
