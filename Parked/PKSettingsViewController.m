//
//  PKSettingsViewController.m
//  Parked
//
//  Created by Rhys Powell on 7/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PKSettingsViewController.h"
#import "TestFlight.h"

@interface PKSettingsViewController ()

@end

@implementation PKSettingsViewController

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

- (IBAction)leaveFeedback:(id)sender {
    [TestFlight openFeedbackView];
}
@end
