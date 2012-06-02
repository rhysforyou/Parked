//
//  PKSplashScreenViewController.m
//  Parked
//
//  Created by Rhys Powell on 1/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PKSplashScreenViewController.h"
#import "PKParkingDetails.h"
#import "PKNewParkViewController.h"

@interface PKSplashScreenViewController ()

@end

@implementation PKSplashScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
