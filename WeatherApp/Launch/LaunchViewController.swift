//
//  LaunchViewController.swift
//  WeatherApp
//
//  Created by Marwan Osama on 1/16/21.
//  Copyright © 2021 Marwan Osama. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var sunImage: UIImageView!
    @IBOutlet weak var cloudImage: UIImageView!

    var gradient: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = false
        cloudImage.layer.add(animateCloudAndSun(byValue: [-110,0]), forKey: "position")
        sunImage.layer.add(animateCloudAndSun(byValue: [110,0]), forKey: "position")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gradient = CAGradientLayer()
        gradient?.frame = view.bounds
        gradient?.startPoint = CGPoint(x: 0, y: 0)
        gradient?.colors = [UIColor.orange.withAlphaComponent(0.7).cgColor, UIColor.red.withAlphaComponent(1).cgColor]
        view.layer.insertSublayer(gradient!, at: 0)
        animateLayer()
    }
    
    func animateLayer() {
        let fromColors = self.gradient?.colors
        let toColors = [UIColor.blue.withAlphaComponent(0.7).cgColor, UIColor.black.withAlphaComponent(1).cgColor]
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 1
        animation.beginTime = CACurrentMediaTime()+0.5
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        self.gradient?.add(animation, forKey: "colors")
        
    }

    func animateCloudAndSun(byValue: Any) -> CABasicAnimation {

        let animation = CABasicAnimation(keyPath: "position")
        animation.byValue = byValue
        animation.duration = 1
        animation.beginTime = CACurrentMediaTime()+0.5
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
   
    

    

}
