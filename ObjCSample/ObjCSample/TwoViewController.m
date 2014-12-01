//
//  TwoViewController.m
//  ObjCSample
//
//  Created by stringCode on 11/27/14.
//  Copyright (c) 2014 stringCode. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.navigationItem.title = self.navigationItem.title;
    SnowGlobeView *snowGlobeView = [[SnowGlobeView alloc] initWithFrame:self.view.bounds];
    snowGlobeView.snowFlakeImage = [SnowGlobeView darkSnowFlakeImage];
    [self.view insertSubview:snowGlobeView atIndex:0];
}

@end
