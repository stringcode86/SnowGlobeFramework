//
//  SnowGlobeView.swift
//  SnowGlobe
//
//  Created by stringCode on 11/2/14.
//

import UIKit
import CoreMotion
import AudioToolbox

private let lifetimeKey = "lifetime"

public class SnowGlobeView: UIView {
    
    //MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }

    //MARK: - Public
    
    /** 
        When true, Creates CMMotionManager, monitors accelerometer and starts emitting snow flakes upon shaking.
        When set to flase emits snow flakes upon view's appearance on screen.
    */
    public var shakeToSnow: Bool = false {
        didSet {
            if oldValue != shakeToSnow {
                shouldShakeToSnow(shakeToSnow)
            }
        }
    }
    
    /// When set to true snow fall is ligther, less dense.
    public var lighterSnowMode: Bool = false {
        didSet {
            if (oldValue != lighterSnowMode) {
                emitterCell = SnowGlobeView.newEmitterCell(lighterSnowMode, image: snowFlakeImage)
                emitter.emitterCells = [emitterCell]
            }
        }
    }
    
    /// Snow flake image, recomended size 74 X 74 pixels @2x.
    public var snowFlakeImage: UIImage? {
        get {
            if let image: AnyObject = emitterCell.contents {
                return UIImage(CGImage: image as! CGImage)
            }
            return nil
        }
        set {
            emitterCell = SnowGlobeView.newEmitterCell(lighterSnowMode, image: newValue)
            emitter.emitterCells = [emitterCell]
        }
    }
    
    public var soundEffectsEnabled: Bool = true
    
    /// default ligth snow flake image
    public class func lightSnowFlakeImage() -> (UIImage?) {
        if let image = UIImage(named: "flake") {
            return image;
        }
        return SnowGlobeView.frameworkImage(named: "flake@2x")
    }
    
    /// default dark snow flake image
    public class func darkSnowFlakeImage() -> (UIImage?) {
        if let image = UIImage(named: "flake2") {
            return image;
        }
        return SnowGlobeView.frameworkImage(named: "flake2@2x")
    }
    
    //MARK: -
    
    public override class func layerClass() -> AnyClass {
        return CAEmitterLayer.self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        emitter.emitterSize = CGSizeMake(bounds.size.width, bounds.size.height)
        emitter.position = CGPointMake(bounds.size.width, bounds.size.height / 2)
    }
    
    public override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        if newWindow != nil && shakeToSnow == false && isAnimating == false {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
    
    deinit {
        self.shakeToSnow = false
        AudioServicesDisposeSystemSoundID(sleighBellsSoundId)
    }
    
    //MARK: - Private
    
    /**
        Animates emitter's lifetime property to 1, causing emitter to start emitting
    */
    func startAnimating () {
        playSoundIfNeeded()
        let animDuration = 0.1
        let anim = CABasicAnimation(keyPath: lifetimeKey)
        anim.fromValue = emitter.presentationLayer()?.lifetime
        anim.toValue = 1
        anim.setValue(animDuration, forKeyPath: "duration")
        emitter.removeAnimationForKey(lifetimeKey)
        emitter.addAnimation(anim, forKey: lifetimeKey)
        emitter.lifetime = 1
    }
    
    /**
        Animates emitter's lifetime property to 0, causing emitter to stop emitting
    */
    func stopAnimating () {
        if emitter.presentationLayer() == nil {
            return
        }
        let animDuration = 4.0
        let anim = CAKeyframeAnimation(keyPath: lifetimeKey)
        anim.values = [emitter.presentationLayer()!.lifetime, emitter.presentationLayer()!.lifetime, 0.0]
        anim.keyTimes = [0.0, 0.5, 1.0]
        anim.setValue(animDuration, forKeyPath: "duration")
        emitter.addAnimation(anim, forKey: lifetimeKey)
        emitter.lifetime = 0.0
        dispatch_after( dispatch_time( DISPATCH_TIME_NOW, Int64(animDuration * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), {[weak self] ()->() in
            self?.shouldPlaySound = true
        })

    }
    
    /// Queue that recieves accelerometer updates from CMMotionManager
    private lazy var queue = NSOperationQueue()
    private lazy var emitterCell: CAEmitterCell = SnowGlobeView.newEmitterCell()
    private var emitter: CAEmitterLayer {  get { return layer as! CAEmitterLayer } }
    private var isAnimating : Bool {
        get { return self.emitter.lifetime == 1.0 }
    }

    private func initialSetup() {
        backgroundColor = UIColor.clearColor()
        autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        userInteractionEnabled = false
        emitter.emitterCells = [emitterCell]
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.renderMode = kCAEmitterLayerOldestLast
        emitter.lifetime = 0
    }
    
    private func shouldShakeToSnow(shakeToSnow: Bool) {
        let motionManager = CMMotionManager.sharedManager
        motionManager.accelerometerUpdateInterval = 0.15
        if motionManager.accelerometerActive || !shakeToSnow {
            motionManager.stopAccelerometerUpdates()
        }
        motionManager.startAccelerometerUpdatesToQueue(queue) { [weak self] accelerometerData, error in
            let data = accelerometerData!.acceleration
            var magnitude = sqrt( sq(data.x) + sq(data.y) + sq(data.z) )
            magnitude = (magnitude < 3.0) ? 0.0 : magnitude
            if (magnitude == 0.0 && self?.isAnimating == false) {
                return
            }
            if let welf = self {
                dispatch_async(dispatch_get_main_queue()) { welf.animate(toLifetime: magnitude) }
            }
        }
    }
    
    private func animate(toLifetime rate:Double) {
        if rate <= 0.0 && self.emitter.lifetime != 0.0 {
            stopAnimating()
        } else if rate > 0.0 && isAnimating == false {
            startAnimating()
        }
    }
    
    private class func newEmitterCell(slowSnow:Bool = false, image: UIImage? = nil) -> CAEmitterCell {
        let cell = CAEmitterCell()
        var currentImage = image
        if currentImage == nil {
            currentImage = SnowGlobeView.lightSnowFlakeImage()
        }
        
        cell.contents = currentImage?.CGImage
        cell.birthRate = 60
        cell.lifetime = 25
        cell.scale = 0.2
        cell.scaleRange = 0.75
        cell.spin = 0
        cell.spinRange = 2
        cell.velocity = -150
        cell.velocityRange = -70.0
        if slowSnow == true {
            cell.birthRate = 10
            cell.velocity = -80
            cell.velocityRange = -40.0
        }
        return cell
    }
    
    class func frameworkImage(named name: String?) -> (UIImage? ) {
        var image: UIImage? = nil
        let frameworkBundle = NSBundle(identifier: "uk.co.stringCode.SnowGlobe")
        if let imagePath = frameworkBundle?.pathForResource(name, ofType: "png") {
            image = UIImage(contentsOfFile: imagePath)
        }
        return image
    }
    
    //MARK: Sound effects
    
    private var shouldPlaySound:Bool = true
    
    private func playSoundIfNeeded() {
        if shouldPlaySound && soundEffectsEnabled {
            shouldPlaySound = false
            AudioServicesPlaySystemSound(sleighBellsSoundId);
        }
    }
    
    private lazy var sleighBellsSoundId: SystemSoundID = {
        var soundId: SystemSoundID = 0
        if let url = NSBundle.mainBundle().URLForResource("SleighBells", withExtension: "mp3") {
            AudioServicesCreateSystemSoundID(url, &soundId)
        } else if let url = NSBundle(identifier: "uk.co.stringCode.SnowGlobe")?.URLForResource("SleighBells", withExtension: "mp3") {
            AudioServicesCreateSystemSoundID(url, &soundId)
        }
        return soundId
    }()
}
