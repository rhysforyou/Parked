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

@end

@implementation PKDurationPickerViewController

@synthesize pickerView;
@synthesize parkingDetails;
@synthesize durationLabel;

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Picker View

- (void)pickerViewChangedSelection
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    self.parkingDetails.timeInterval = [self.pickerView.date timeIntervalSinceDate:date];
}

@end
