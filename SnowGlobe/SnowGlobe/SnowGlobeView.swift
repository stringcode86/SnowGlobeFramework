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

open class SnowGlobeView: UIView {
    
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
    open var shakeToSnow: Bool = false {
        didSet {
            if oldValue != shakeToSnow {
                shouldShakeToSnow(shakeToSnow)
            }
        }
    }
    
    /// When set to true snow fall is ligther, less dense.
    open var lighterSnowMode: Bool = false {
        didSet {
            if (oldValue != lighterSnowMode) {
                emitterCell = SnowGlobeView.newEmitterCell(lighterSnowMode, image: snowFlakeImage)
                emitter.emitterCells = [emitterCell]
            }
        }
    }
    
    /// Snow flake image, recomended size 74 X 74 pixels @2x.
    open var snowFlakeImage: UIImage? {
        get {
            if let image: Any = emitterCell.contents {
                return UIImage(cgImage: image as! CGImage)
            }
            return nil
        }
        set {
            emitterCell = SnowGlobeView.newEmitterCell(lighterSnowMode, image: newValue)
            emitter.emitterCells = [emitterCell]
        }
    }
    
    open var soundEffectsEnabled: Bool = true
    
    open var sensitivity: SnowGlobeSensitivity = .medium
    
    /// default ligth snow flake image
    open class func lightSnowFlakeImage() -> (UIImage?) {
        if let image = UIImage(named: "flake") {
            return image;
        }
        return SnowGlobeView.frameworkImage(named: "flake@2x")
    }
    
    /// default dark snow flake image
    open class func darkSnowFlakeImage() -> (UIImage?) {
        if let image = UIImage(named: "flake2") {
            return image;
        }
        return SnowGlobeView.frameworkImage(named: "flake2@2x")
    }
    
    //MARK: -
    
    open override class var layerClass: AnyClass {
        return CAEmitterLayer.self
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        emitter.emitterSize = CGSize(width: bounds.size.width, height: bounds.size.height)
        emitter.position = CGPoint(x: bounds.size.width, y: bounds.size.height / 2)
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
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
        anim.fromValue = emitter.presentation()?.lifetime
        anim.toValue = 1
        anim.setValue(animDuration, forKeyPath: "duration")
        emitter.removeAnimation(forKey: lifetimeKey)
        emitter.add(anim, forKey: lifetimeKey)
        emitter.lifetime = 1
    }
    
    /**
        Animates emitter's lifetime property to 0, causing emitter to stop emitting
    */
    func stopAnimating () {
        if emitter.presentation() == nil {
            return
        }
        let animDuration = 4.0
        let anim = CAKeyframeAnimation(keyPath: lifetimeKey)
        anim.values = [emitter.presentation()!.lifetime, emitter.presentation()!.lifetime, 0.0]
        anim.keyTimes = [0.0, 0.5, 1.0]
        anim.setValue(animDuration, forKeyPath: "duration")
        emitter.add(anim, forKey: lifetimeKey)
        emitter.lifetime = 0.0
        DispatchQueue.main.asyncAfter( deadline: DispatchTime.now() + Double(Int64(animDuration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {[weak self] ()->() in
            self?.shouldPlaySound = true
        })

    }
    
    /// Queue that recieves accelerometer updates from CMMotionManager
    fileprivate lazy var queue = OperationQueue()
    fileprivate lazy var emitterCell: CAEmitterCell = SnowGlobeView.newEmitterCell()
    fileprivate var emitter: CAEmitterLayer {  get { return layer as! CAEmitterLayer } }
    fileprivate var isAnimating : Bool {
        get { return self.emitter.lifetime == 1.0 }
    }

    fileprivate func initialSetup() {
        backgroundColor = UIColor.clear
        autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        isUserInteractionEnabled = false
        emitter.emitterCells = [emitterCell]
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.renderMode = kCAEmitterLayerOldestLast
        emitter.lifetime = 0
    }
    
    fileprivate func shouldShakeToSnow(_ shakeToSnow: Bool) {
        let motionManager = CMMotionManager.sharedManager
        motionManager.accelerometerUpdateInterval = 0.15
        if motionManager.isAccelerometerActive || !shakeToSnow {
            motionManager.stopAccelerometerUpdates()
        }
        motionManager.startAccelerometerUpdates(to: queue) { [weak self] accelerometerData, error in
            let data = accelerometerData!.acceleration
            let sensitivity = self?.sensitivity ?? .medium
            let magnitude = sqrt( sq(data.x) + sq(data.y) + sq(data.z) )
            if (magnitude >= sensitivity && self?.isAnimating == false) {
                return
            }
            if let welf = self {
                DispatchQueue.main.async { welf.animate(toLifetime: magnitude) }
            }
        }
    }
    
    fileprivate func animate(toLifetime rate:Double) {
        if rate <= 0.0 && self.emitter.lifetime != 0.0 {
            stopAnimating()
        } else if rate > 0.0 && isAnimating == false {
            startAnimating()
        }
    }
    
    fileprivate class func newEmitterCell(_ slowSnow:Bool = false, image: UIImage? = nil) -> CAEmitterCell {
        let cell = CAEmitterCell()
        var currentImage = image
        if currentImage == nil {
            currentImage = SnowGlobeView.lightSnowFlakeImage()
        }
        
        cell.contents = currentImage?.cgImage
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
        let frameworkBundle = Bundle(identifier: "uk.co.stringCode.SnowGlobe")
        if let imagePath = frameworkBundle?.path(forResource: name, ofType: "png") {
            image = UIImage(contentsOfFile: imagePath)
        }
        return image
    }
    
    //MARK: Sound effects
    
    fileprivate var shouldPlaySound:Bool = true
    
    fileprivate func playSoundIfNeeded() {
        if shouldPlaySound && soundEffectsEnabled {
            shouldPlaySound = false
            AudioServicesPlaySystemSound(sleighBellsSoundId);
        }
    }
    
    fileprivate lazy var sleighBellsSoundId: SystemSoundID = {
        var soundId: SystemSoundID = 0
        if let url = Bundle.main.url(forResource: "SleighBells", withExtension: "mp3") {
            AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
        } else if let url = Bundle(identifier: "uk.co.stringCode.SnowGlobe")?.url(forResource: "SleighBells", withExtension: "mp3") {
            AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
        } else if let cocoaPodBundlePath =  Bundle(for: SnowGlobeView.self).path(forResource: "SnowGlobe", ofType: "bundle") {
            if let url = Bundle(path: cocoaPodBundlePath)?.url(forResource: "SleighBells", withExtension: "mp3") {
                AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
            }

        }
        return soundId
    }()
}
