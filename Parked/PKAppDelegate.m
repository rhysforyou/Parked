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
#import "TestFlight.h"

#define TESTING 1

@implementation PKAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"863c91be8a6a72368797f64da4aaa6e8_OTc3MzgyMDEyLTA2LTA3IDA2OjU1OjQzLjUxODkwMg"];
    
    #ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    #endif
    
    return YES;
}

@end
