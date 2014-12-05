<div class="postWrapper" id="post-504">

		  		   [<div class="postFeatured circleImage" style="background-image: url('http://www.stringcode.co.uk/stringcode_wordpress/wp-content/uploads/2014/12/AnimationFlake@2x.gif');"></div>](http://www.stringcode.co.uk/stringcode_wordpress/wp-content/uploads/2014/12/AnimationFlake@2x.gif)

# [SnowGlobe.framework iOS Xmas easter egg](http://www.stringcode.co.uk/snowglobe-framework-ios-xmas-easter-egg/)

	      <small>December 5, 2014</small>
	      <div class="post">	      

[SnowGlobe.framework](https://github.com/stringcode86/SnowGlobeFramework "Git hub repo")&nbsp;its easy to use, open source iOS framework written in [#swift](http://www.stringcode.co.uk/category/blog/swift). It allows you to ad&nbsp;delightful / cheesy Christmas easter egg to your awesome app for holiday season. When user shakes the device, your app “turns into a snow globe”. Leveraging&nbsp;[CAEmitterLayer](https://developer.apple.com/library/IOs/documentation/GraphicsImaging/Reference/CAEmitterLayer_class/index.html "CAEmitterLayer class reference") to create snow fall, snow globe like animation while device is shaken. I am a sucker for that kinda of thing. I don’t see anything wrong with falling for spirit of the holiday season&nbsp;and getting bit cheesy.<span id="more-504"></span>

*   [How to build and run sample project](#howToRunSample)
*   [How to add to your project](#howToAddToYourProject)
*   [About implementation](#aboutImplementation)

## How to build and run sample project

Download source form [repo](https://github.com/stringcode86/SnowGlobeFramework "Gitgub repo"). To build and run it on device open&nbsp;Sample.xcworkspace.&nbsp;This workspace contains three projects. SnowGlobe framework project, Swift and Objective-C sample projects. Select either SwiftSample or ObjCSample schema. You’ll have to set up code signing to run on the device. Select either Swift/ObjCSample target and choose your team. Sample app demonstrates three ways you can use SnowGlobeView. My original use case was to ad SnowGlobeView as subview of application’s keyWindow. That way&nbsp;when user shakes the device, snow layer is over any ViewController’s view. For more detail check out&nbsp;[about implementation](#aboutImplementation)&nbsp;section.

## How to add to your project

1.  Copy SnowGlobe folder to YourAwesomeApp project folder.
2.  Drag and drop&nbsp;SnowGlobe.xcodeproj file to your project. I usually create frameworks folder to keep things tidy, but its not necessary
3.  Select your app’s target and click on plus icon to add embedded binary.
4.  Select SnowGlobe.framework

[![tutorial@2x](http://www.stringcode.co.uk/stringcode_wordpress/wp-content/uploads/2014/12/tutorial@2x2.png)](http://www.stringcode.co.uk/stringcode_wordpress/wp-content/uploads/2014/12/tutorial@2x2.png)5.  Add following code to your AppDelegate.swift or Obj-C equivalent :

    <span class="hljs-keyword">import</span> <span class="hljs-type">UIKit</span>
    <span class="hljs-keyword">import</span> <span class="hljs-type">SnowGlobe</span>
    @<span class="hljs-type">UIApplicationMain</span>
    <span class="hljs-class"><span class="hljs-keyword">class</span> <span class="hljs-title">AppDelegate</span>: <span class="hljs-title">UIResponder</span>, <span class="hljs-title">UIApplicationDelegate</span> </span>{
        <span class="hljs-keyword">var</span> window: <span class="hljs-type">UIWindow</span>?
        <span class="hljs-keyword">var</span> snowGlobeView: <span class="hljs-type">SnowGlobeView</span>?
        <span class="hljs-func"><span class="hljs-keyword">func</span> <span class="hljs-title">applicationDidBecomeActive</span><span class="hljs-params">(application: UIApplication)</span> </span>{
            <span class="hljs-keyword">if</span> snowGlobeView == <span class="hljs-built_in">nil</span> {
                <span class="hljs-keyword">let</span> bounds = application.keyWindow?.bounds
                snowGlobeView = <span class="hljs-type">SnowGlobeView</span>(frame: bounds!)
                snowGlobeView?.shakeToSnow = <span class="hljs-built_in">true</span>
                application.keyWindow?.addSubview(snowGlobeView!)
            }
        }
    }

Build, Run &amp; Shake !

## About implementation

The [CAEmitterLayer](https://developer.apple.com/library/ios/documentation/GraphicsImaging/Reference/CAEmitterLayer_class/index.html "CAEmitterLayer Docs") class provides a particle emitter system for Core Animation. The particles are defined by instances of [CAEmitterCell](https://developer.apple.com/Library/mac/documentation/GraphicsImaging/Reference/CAEmitterCell_class/index.html "CAEmitterCell Docs"). SnowGlobeView overrides UIView’s [layerClass](https://developer.apple.com/library/ios/documentation/uikit/reference/UIView_Class/index.html#//apple_ref/occ/clm/UIView/layerClass "layerClass Docs") method and returns CAEmitterLayer so that UIView becomes backed by CAEmitterLayer rather then CALayer. CAEmitterLayer needs array of CAEmitterCells. Single&nbsp;CAEmitterCell array with [contents](https://developer.apple.com/Library/mac/documentation/GraphicsImaging/Reference/CAEmitterCell_class/index.html#//apple_ref/occ/instp/CAEmitterCell/contents "contes Docs") set to snowFlakeImage.CGImage will suffice. There plenty of properties with ranges to be set on them. For example there is size and sizeRange. Value of size will be random value size +- range. Using these properties with ranges allows us to create&nbsp;convincing&nbsp;dynamic snow storm effect.

You can simply add SnowGlobeView as subview of any view and it will start animating particles upon moving to window. However** the use case** SnowGlobeView was made for is to add it as subView of [UIApplication’s keyWindow](https://developer.apple.com/library/ios/Documentation/UIKit/Reference/UIApplication_Class/index.html#//apple_ref/occ/instp/UIApplication/keyWindow "keyWindow Docs")&nbsp;and set&nbsp;shakeToSnow property to true. This will create&nbsp;[CMMotionManager](https://developer.apple.com/library/iOS//documentation/CoreMotion/Reference/CMMotionManager_Class/index.html "CMMotionManager")&nbsp;witch monitors accelerometer and will animate snow fall briefly when threshold is met. Since SnowGlobeView is added as subview of key window you will get snow effect over entire UIViewController hierarchy.

There is&nbsp;lighterSnowMode property, if set to yes snow fall become not as dense.

There are two class methods&nbsp;lightSnowFlakeImage and&nbsp;darkSnowFlakeImage witch provide default snow flake images. You can also set your custom image. Recommended size is&nbsp;74 X 74 pixels @2x.

&nbsp;

	      </div>

<!-- 	      Categories & social -->	      
		  <div id="postDetails">
			  <iframe id="twitter-widget-0" scrolling="no" frameborder="0" allowtransparency="true" src="http://platform.twitter.com/widgets/tweet_button.ff7d9077a26377d36b6a53b1a95be617.en.html#_=1417774113478&amp;count=none&amp;id=twitter-widget-0&amp;lang=en&amp;original_referer=http%3A%2F%2Fwww.stringcode.co.uk%2Fsnowglobe-framework-ios-xmas-easter-egg%2F&amp;size=m&amp;text=SnowGlobe.framework%20iOS%20Xmas%20easter%20egg&amp;url=http%3A%2F%2Fwww.stringcode.co.uk%2Fsnowglobe-framework-ios-xmas-easter-egg%2F&amp;via=stringcode" class="twitter-share-button twitter-tweet-button twitter-share-button twitter-count-none" title="Twitter Tweet Button" data-twttr-rendered="true" style="width: 55px; height: 20px;"></iframe>	
		      <div class="fb-like fb_iframe_widget" data-href="http://www.stringcode.co.uk/snowglobe-framework-ios-xmas-easter-egg/" data-layout="button" data-action="like" data-show-faces="false" data-share="false" fb-xfbml-state="rendered" fb-iframe-plugin-query="action=like&amp;app_id=&amp;href=http%3A%2F%2Fwww.stringcode.co.uk%2Fsnowglobe-framework-ios-xmas-easter-egg%2F&amp;layout=button&amp;locale=en_GB&amp;sdk=joey&amp;share=false&amp;show_faces=false"><span style="vertical-align: bottom; width: 48px; height: 20px;"><iframe name="f3344ede38" width="1000px" height="1000px" frameborder="0" allowtransparency="true" scrolling="no" title="fb:like Facebook Social Plugin" src="http://www.facebook.com/v2.0/plugins/like.php?action=like&amp;app_id=&amp;channel=http%3A%2F%2Fstatic.ak.facebook.com%2Fconnect%2Fxd_arbiter%2F7r8gQb8MIqE.js%3Fversion%3D41%23cb%3Df31372ad48%26domain%3Dwww.stringcode.co.uk%26origin%3Dhttp%253A%252F%252Fwww.stringcode.co.uk%252Ff2758bf87c%26relation%3Dparent.parent&amp;href=http%3A%2F%2Fwww.stringcode.co.uk%2Fsnowglobe-framework-ios-xmas-easter-egg%2F&amp;layout=button&amp;locale=en_GB&amp;sdk=joey&amp;share=false&amp;show_faces=false" class="" style="border: none; visibility: visible; width: 48px; height: 20px;"></iframe></span></div> 
			  <small>[#Blog posts](http://www.stringcode.co.uk/category/blog/ "View all posts in Blog posts"), [#Coding](http://www.stringcode.co.uk/category/blog/coding/ "View all posts in Coding"), [#iOS Development](http://www.stringcode.co.uk/category/blog/iosdevelopment/ "View all posts in iOS Development"), [#Swift](http://www.stringcode.co.uk/category/blog/swift/ "View all posts in Swift")</small>
		  </div>

	    </div>
