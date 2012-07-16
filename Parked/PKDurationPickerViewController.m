//
//  PKDurationPickerViewController.m
//  Parked
//
//  Created by Rhys Powell on 11/07/12.
//
//

#import "PKDurationPickerViewController.h"
#import "PKParkingDetails.h"

typedef enum {
    PKDurationPickerModeDuration,
    PKDurationPickerModeExpirationTime
} PKDurationPickerMode;

@interface PKDurationPickerViewController ()

- (void)datePicker:(UIDatePicker *)datePicker didChangeSelectionWithEvent:(UIEvent *)event;

@property UIDatePicker *datePicker;
@property PKDurationPickerMode pickerMode;

@end

@implementation PKDurationPickerViewController

@synthesize expirationLabel = _expirationLabel;
@synthesize durationLabel = _durationLabel;
@synthesize parkingDetails = _parkingDetails;
@synthesize datePicker = _datePicker;
@synthesize pickerMode = _pickerMode;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    CGFloat viewHeight   = self.view.bounds.size.height;
    CGFloat pickerHeight = datePicker.frame.size.height;
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect newFrame = datePicker.frame;
    newFrame.origin.y = viewHeight - pickerHeight - navBarHeight;
    [datePicker setFrame:newFrame];
    
    [self.view addSubview:datePicker];
    
    [datePicker addTarget:self
                   action:@selector(datePicker:didChangeSelectionWithEvent:)
         forControlEvents:UIControlEventValueChanged];
    
    self.datePicker = datePicker;
    
    [self.tableView setBackgroundColor:[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.9 alpha:1.0]];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.durationLabel.text = [self.parkingDetails durationString];
    self.expirationLabel.text = [self.parkingDetails durationExpirationString];
    
    [self refreshDatePicker];
}

- (void)viewDidAppear:(BOOL)animated
{
    // TODO: figure out why this won't work in viewDidLoad
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)datePicker:(UIDatePicker *)datePicker didChangeSelectionWithEvent:(UIEvent *)event;
{
    if (self.pickerMode == PKDurationPickerModeDuration) {
        self.parkingDetails.timeInterval = datePicker.countDownDuration;
    } else if (self.pickerMode == PKDurationPickerModeExpirationTime) {
        self.parkingDetails.timeInterval = [datePicker.date timeIntervalSinceDate:self.parkingDetails.startTime];
    }
    
    self.durationLabel.text = [self.parkingDetails durationString];
    self.expirationLabel.text = [self.parkingDetails durationExpirationString];
}

#pragma mark - Utility methdos

- (void)refreshDatePicker
{
    if (self.pickerMode == PKDurationPickerModeDuration) {
        [self.datePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
        [self.datePicker setCountDownDuration:self.parkingDetails.timeInterval];
        [self.datePicker setMinuteInterval:5];
    } else if (self.pickerMode == PKDurationPickerModeExpirationTime) {
        [self.datePicker setDatePickerMode:UIDatePickerModeTime];
        NSDate *finishDate = [self.parkingDetails.startTime dateByAddingTimeInterval:self.parkingDetails.timeInterval];
        [self.datePicker setDate:finishDate];
        [self.datePicker setMinuteInterval:1];
    }
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0) {
        self.pickerMode = PKDurationPickerModeDuration;
    } else {
        self.pickerMode = PKDurationPickerModeExpirationTime;
    }
    
    [self refreshDatePicker];
}

@end
