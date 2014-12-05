SnowGlobe.framework
===================
SnowGlobe.framework its easy to use, open source iOS framework written in swift. It allows you to ad delightful / cheesy Christmas easter egg to your awesome app for holiday season. When user shakes the device, your app “turns into a snow globe”. Leveraging [CAEmitterLayer](https://developer.apple.com/library/mac/Documentation/GraphicsImaging/Reference/CAEmitterLayer_class/index.html) to create snow fall, snow globe like animation while device is shaken. I am a sucker for that kinda of thing. I don’t see anything wrong with falling for spirit of the holiday season and getting bit cheesy.

For more info and better formated docs head over to http://www.stringcode.co.uk/snowglobe-framework-ios-xmas-easter-egg/
If you have any questions tweet at me [@stringcode](https://twitter.com/stringcode)

###How to build and run sample project
Download source form repo. To build and run it on device open Sample.xcworkspace. This workspace contains three projects. SnowGlobe framework project, Swift and Objective-C sample projects. Select either SwiftSample or ObjCSample schema. You’ll have to set up code signing to run on the device. Select either Swift/ObjCSample target and choose your team. Sample app demonstrates three ways you can use SnowGlobeView. My original use case was to ad SnowGlobeView as subview of application’s keyWindow. That way when user shakes the device, snow layer is over any ViewController’s view. For more detail check out about implementation section.

###How to add to your project
1. Copy SnowGlobe folder to YourAwesomeApp project folder.
2. Drag and drop SnowGlobe.xcodeproj file to your project. I usually create frameworks folder to keep things tidy, but its not necessary
3. Select your app’s target and click on plus icon to add embedded binary.
4. Select SnowGlobe.framework
![screenshot](http://www.stringcode.co.uk/stringcode_wordpress/wp-content/uploads/2014/12/tutorial@2x2.png)
5. Add following code to your AppDelegate.swift or Obj-C equivalent :
``` swift
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
```
Build, Run & Shake it!

###About implementation
The CAEmitterLayer class provides a particle emitter system for Core Animation. The particles are defined by instances of CAEmitterCell. SnowGlobeView overrides UIView’s layerClass method and returns CAEmitterLayer so that UIView becomes backed by CAEmitterLayer rather then CALayer. CAEmitterLayer needs array of CAEmitterCells. Single CAEmitterCell array with contents set to snowFlakeImage.CGImage will suffice. There plenty of properties with ranges to be set on them. For example there is size and sizeRange. Value of size will be random value size +- range. Using these properties with ranges allows us to create convincing dynamic snow storm effect.

You can simply add SnowGlobeView as subview of any view and it will start animating particles upon moving to window. However the use case SnowGlobeView was made for is to add it as subView of UIApplication’s keyWindow and set shakeToSnow property to true. This will create CMMotionManager witch monitors accelerometer and will animate snow fall briefly when threshold is met. Since SnowGlobeView is added as subview of key window you will get snow effect over entire UIViewController hierarchy.

There is lighterSnowMode property, if set to yes snow fall become not as dense.

There are two class methods lightSnowFlakeImage and darkSnowFlakeImage witch provide default snow flake images. You can also set your custom image. Recommended size is 74 X 74 pixels @2x.
