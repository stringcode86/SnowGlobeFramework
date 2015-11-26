//
//  AppDelegate.swift
//  SnowGlobe
//
//  Created by stringcode on 11/26/2015.
//  Copyright (c) 2015 stringcode. All rights reserved.
//

import UIKit
import SnowGlobe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var snowGlobeView: SnowGlobeView?
    
    func applicationDidBecomeActive(application: UIApplication) {
        if snowGlobeView == nil {
            let bounds = application.keyWindow?.bounds
            snowGlobeView = SnowGlobeView(frame: bounds!)
            snowGlobeView?.shakeToSnow = true
            application.keyWindow?.addSubview(snowGlobeView!)
        }
    }
}

