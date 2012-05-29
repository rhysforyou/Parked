//
//  PKAppDelegate.m
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PKAppDelegate.h"
#import "PKNewParkViewController.h"
#import "PKParkingDetails.h"

@implementation PKAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PKNewParkViewController *detailVC = (PKNewParkViewController *)[(UINavigationController *)self.window.rootViewController topViewController];
    detailVC.parkingDetails = [[PKParkingDetails alloc] init];
    return YES;
}

@end
