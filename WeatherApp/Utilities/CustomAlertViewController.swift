//
//  CustomAlertViewController.swift
//  WeatherApp
//
//  Created by Marwan Osama on 1/15/21.
//  Copyright © 2021 Marwan Osama. All rights reserved.
//

import Foundation
import CleanyModal

class CustomAlertViewController: CleanyAlertViewController {
    
    @available(iOS 13.0, *)
    init(title: String?, message: String?, imageName: String? = nil, preferredStyle: CleanyAlertViewController.Style = .alert) {
        let styleSettings = CleanyAlertConfig.getDefaultStyleSettings()
        styleSettings[.tintColor] = .yellow
        styleSettings[.destructiveColor] = .systemPink
        styleSettings[.backgroundColor] = .systemBackground
        super.init(title: title, message: message, imageName: imageName, preferredStyle: preferredStyle, styleSettings: styleSettings)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
