//
//  ViewController.swift
//  ninja
//
//  Created by wesley on 2021/3/30.
//

import UIKit

class ContactViewController: UIViewController{

        override func viewDidLoad() {
                super.viewDidLoad()
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "ShowQRScanerID"{
                        let vc : ScannerViewController = segue.destination as! ScannerViewController
                        vc.delegate = self
                }
        }
        
        @IBAction func NewContact(_ sender: UIBarButtonItem) {
                self.performSegue(withIdentifier: "ShowQRScanerID", sender: self)
        }
        
}

extension ContactViewController:ScannerViewControllerDelegate{
        
        func codeDetected(code: String) {
                NSLog("\(code)")
                guard let err = ContactItem.AddNewContact(code) else{
                        return
                }
                
                self.toastMessage(title: err.localizedDescription)
        }
}
