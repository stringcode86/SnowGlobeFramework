//
//  ThreeViewController.m
//  ObjCSample
//
//  Created by stringCode on 11/27/14.
//

#import "ThreeViewController.h"
#import <SnowGlobe/SnowGlobe.h>

@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.navigationItem.title = self.navigationItem.title;
    SnowGlobeView *snowGlobeView = [[SnowGlobeView alloc] initWithFrame:self.view.bounds];
    snowGlobeView.lighterSnowMode = YES;
    [self.view insertSubview:snowGlobeView atIndex:0];
}

@end
