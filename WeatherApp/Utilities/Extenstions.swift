//
//  Extenstions.swift
//  WeatherApp
//
//  Created by Marwan Osama on 1/15/21.
//  Copyright © 2021 Marwan Osama. All rights reserved.
//


import UIKit
import MBProgressHUD
import CleanyModal

extension UIViewController {
    
    func showIndicator(withTitle title: String, andDescription description: String ) {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.animationType = .zoom
        hud.mode = .indeterminate
        hud.label.text = title
        hud.detailsLabel.text = description
        hud.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        hud.show(animated: true)
        
    }
    
    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.view.isUserInteractionEnabled = true
    }
    
    @available(iOS 13.0, *)
    func showAlert(withTitle title: String?, andDescription description: String?, andImageName imageName: String?, completion: (()-> Void)?) {
        let alert = CustomAlertViewController(title: title, message: description, imageName: imageName, preferredStyle: .alert)
        let action = CleanyAlertAction(title: "OK", style: .cancel) { (_) in
            (completion ?? {})()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
