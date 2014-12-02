//
//  AppDelegate.m
//  ObjCSample
//
//  Created by stringCode on 11/27/14.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (!self.snowGlobeView) {
        SnowGlobeView *snowGlobeView = [[SnowGlobeView alloc] initWithFrame:application.keyWindow.bounds];
        snowGlobeView.shakeToSnow = YES;
        [application.keyWindow addSubview:snowGlobeView];
    }
}

@end
