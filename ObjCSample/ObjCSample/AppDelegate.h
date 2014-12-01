//
//  AppDelegate.h
//  ObjCSample
//
//  Created by stringCode on 11/27/14.
//  Copyright (c) 2014 stringCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SnowGlobe/SnowGlobe.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) SnowGlobeView *snowGlobeView;

@end

