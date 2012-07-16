//
//  PKAlarmPickerViewController.m
//  Parked
//
//  Created by Rhys Powell on 13/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PKAlarmPickerViewController.h"
#import "PKParkingDetails.h"

@interface PKAlarmPickerViewController ()

@property (strong, nonatomic) UIDatePicker *datePicker;

@end

@implementation PKAlarmPickerViewController

@synthesize timeLabel;
@synthesize parkingDetails;
@synthesize datePicker = _datePicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    CGFloat viewHeight   = self.view.bounds.size.height;
    CGFloat pickerHeight = datePicker.frame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect datePickerFrame = datePicker.frame;
    datePickerFrame.origin.y = viewHeight - pickerHeight - navBarHeight;
    datePicker.frame = datePickerFrame;
    
    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    
    [self.view addSubview:datePicker];
    
    [datePicker addTarget:self
                   action:@selector(datePickerChangedSelection:)
         forControlEvents:UIControlEventValueChanged];
    
    self.datePicker = datePicker;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.parkingDetails.hasAlert) {
        self.parkingDetails.hasAlert = YES;
        self.parkingDetails.alertOffset = 1800;
    }
    
    self.timeLabel.text = [[self.parkingDetails alertDurationString] stringByAppendingString:@" before"];
    
    [self.datePicker setCountDownDuration:self.parkingDetails.alertOffset];
}

- (void)datePickerChangedSelection:(UIDatePicker *)sender
{
    self.parkingDetails.alertOffset = sender.countDownDuration;
    self.timeLabel.text = [self.parkingDetails alertDurationString];
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.parkingDetails.hasAlert = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
