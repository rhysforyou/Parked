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

@property (strong, nonatomic) NSString *selectedDuration;

@end

@implementation PKDurationPickerViewController

@synthesize pickerView;
@synthesize parkingDetails;
@synthesize durationLabel;
@synthesize alertSwitch;
@synthesize alertDurationLabel;
@synthesize alertDurationCell;
@synthesize selectedDuration;

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
    self.alertDurationLabel.text = [NSString stringWithFormat:@"%@ before", [self.parkingDetails alertDurationString]];
    self.selectedDuration = @"parking";
    self.alertSwitch.on = self.parkingDetails.hasAlert;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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
}

#pragma mark - Picker View

- (void)pickerViewChangedSelection
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    
    if ([self.selectedDuration isEqualToString:@"parking"]) {
        self.parkingDetails.timeInterval = [self.pickerView.date timeIntervalSinceDate:date];
        self.durationLabel.text = [self.parkingDetails durationString];
    } else if ([self.selectedDuration isEqualToString:@"alert"]) {
        [self.alertSwitch setOn:YES animated:YES];
        self.parkingDetails.hasAlert = YES;
        self.parkingDetails.alertOffset = [self.pickerView.date timeIntervalSinceDate:date];
        self.alertDurationLabel.text = [NSString stringWithFormat:@"%@ before", [self.parkingDetails alertDurationString]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.second = self.parkingDetails.timeInterval;
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = [gregorian dateFromComponents:dateComponents];
        [self.pickerView setDate:date animated:YES];
        
        self.selectedDuration = @"parking";
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.second = self.parkingDetails.alertOffset;
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = [gregorian dateFromComponents:dateComponents];
        [self.pickerView setDate:date animated:YES];
        
        self.selectedDuration = @"alert";
    }
}

@end
