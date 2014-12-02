//
//  AppDelegate.h
//  ObjCSample
//
//  Created by stringCode on 11/27/14.
//

#import <UIKit/UIKit.h>
#import <SnowGlobe/SnowGlobe.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) SnowGlobeView *snowGlobeView;

@end

