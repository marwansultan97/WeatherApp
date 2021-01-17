//
//  SceneDelegate.swift
//  WeatherApp
//
//  Created by Marwan Osama on 1/16/21.
//  Copyright © 2021 Marwan Osama. All rights reserved.
//

import UIKit


@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let rootVC = UIStoryboard(name: "Launch", bundle: nil).instantiateInitialViewController()
            window.rootViewController = rootVC
            self.window = window
            window.makeKeyAndVisible()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
                let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                window.rootViewController = rootVC
                self.window = window
                window.makeKeyAndVisible()
            }
            
            
        }
        
        
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    
    
    
}
