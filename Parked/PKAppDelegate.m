//
//  PKAppDelegate.m
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 Rhys Powell. All rights reserved.
//

#import "PKAppDelegate.h"
#import "PKNewParkViewController.h"
#import "PKParkingDetails.h"

@implementation PKAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHue:0.61 saturation:1 brightness:0.4 alpha:1]];
    [[UIToolbar appearance] setTintColor:[UIColor colorWithHue:0.61 saturation:1 brightness:0.4 alpha:1]];
    
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.9 alpha:1.0]];
    
    return YES;
}

@end
