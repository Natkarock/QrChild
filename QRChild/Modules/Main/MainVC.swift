//
//  ViewController.swift
//  QRChild
//
//  Created by Karapats on 18/06/ 15.
//  Copyright © 2018 Karapats. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func  qrBtnAction(sender:Any?){
        let scanVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ScanVC") as? ScanVC
        if let `scanVC` = scanVC {
            let transitionT = CATransition()
            transitionT.duration = 1
            transitionT.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transitionT.type = kCATransitionReveal
            transitionT.subtype = kCATransitionFromTop
            present(controller: scanVC, with: transitionT)
        }
        
    }


}

