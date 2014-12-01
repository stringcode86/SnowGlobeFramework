//
//  CMMotionManager+shared.swift
//  SnowGlobe
//
//  Created by stringCode on 11/2/14.
//  Copyright (c) 2014 stringCode. All rights reserved.
//

import UIKit
import CoreMotion

extension CMMotionManager {

    public class var sharedManager: CMMotionManager {
        struct Singleton { static let instance = CMMotionManager() }
        return Singleton.instance
    }
    
    
}