//
//  ThreeViewController.swift
//  SwiftSample
//
//  Created by stringCode on 11/25/14.
//

import UIKit
import SnowGlobe

class ThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.title = title
        let snowGlobeView = SnowGlobeView(frame:view.bounds)
        snowGlobeView.lighterSnowMode = true
        view.insertSubview(snowGlobeView, at: 0)        
    }
}
