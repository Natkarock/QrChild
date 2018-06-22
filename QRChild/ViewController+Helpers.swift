//
//  ViewController+Helpers.swift
//  QRChild
//
//  Created by Karapats on 18/06/ 15.
//  Copyright © 2018 Karapats. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func present(controller: UIViewController, with transition:CATransition?){
        var animated = true
        if let `transition` = transition {
            view.window?.layer.add(transition, forKey: kCATransition)
            animated = false
        }
        self.present(controller, animated: animated , completion: nil)
    }
    
    
    func showTextAlert(title:String,text:String, okaction: @escaping (UIAlertAction)->Void){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: okaction))
        self.present(alert, animated: true)
    }
    
    func showOkCancelAlert(title:String,text:String, okaction: @escaping (UIAlertAction)->Void){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: okaction))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setupActivityIndicator()->UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
        indicator.removeFromSuperview()
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        return indicator
    }
    
    func start(indicator: UIActivityIndicatorView){
        indicator.startAnimating()
    }
    
    func stop(indicator:UIActivityIndicatorView){
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
    
    public func isRegExp(by pattern: String) -> Bool {
        return false
    }
    
    func snapshot (by item:UIView)-> UIImage? {
        print("frame.size:\(item.frame.size)")
        print("frame.x:\(-item.frame.origin.x)")
        print("frame.y:\(-item.frame.origin.y)")
        UIGraphicsBeginImageContextWithOptions(CGSize(width: item.frame.size.width, height: item.frame.size.height), false, 0);
        view.drawHierarchy(in: CGRect(origin: CGPoint(x:-item.frame.origin.x ,y:-item.frame.origin.y),
                                 size: (view?.bounds.size)!), afterScreenUpdates: true)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return image
    }
}
