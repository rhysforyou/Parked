//
//  PKDurationPickerViewController.m
//  Parked
//
//  Created by Rhys Powell on 30/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PKDurationPickerViewController.h"
#import "PKParkingDetails.h"

@interface PKDurationPickerViewController ()

- (void)setPickerViewToTimeInterval:(NSTimeInterval)timeInterval;
- (void)pickerViewChangedSelection;
- (void)alertToggled;

@end

@implementation PKDurationPickerViewController

@synthesize pickerView;
@synthesize parkingDetails;
@synthesize durationLabel;
@synthesize alertSwitch;
@synthesize alertDurationCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.pickerView addTarget:self 
                        action:@selector(pickerViewChangedSelection)
              forControlEvents:UIControlEventValueChanged];
    
    [self.alertSwitch addTarget:self action:@selector(alertToggled) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setPickerViewToTimeInterval:self.parkingDetails.timeInterval];
    self.durationLabel.text = [self.parkingDetails durationString];
}

- (void)viewDidUnload
{
    [self setPickerView:nil];
    [self setDurationLabel:nil];
    [self setAlertSwitch:nil];
    [self setAlertDurationCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Utility Methods

- (void)setPickerViewToTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.second = timeInterval;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    [self.pickerView setDate:date];
}

#pragma mark - Alert Switch

- (void)alertToggled
{
    self.parkingDetails.hasAlert = self.alertSwitch.on;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [[self.tableView cellForRowAtIndexPath:indexPath] setHidden:!self.alertSwitch.on];
}

#pragma mark - Picker View

- (void)pickerViewChangedSelection
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    self.parkingDetails.timeInterval = [self.pickerView.date timeIntervalSinceDate:date];
    self.durationLabel.text = [self.parkingDetails durationString];
}

@end
