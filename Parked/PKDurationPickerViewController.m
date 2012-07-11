//
//  PKDurationPickerViewController.m
//  Parked
//
//  Created by Rhys Powell on 11/07/12.
//
//

#import "PKDurationPickerViewController.h"

@interface PKDurationPickerViewController ()

- (void)datePicker:(UIDatePicker *)datePicker didChangeSelectionWithEvent:(UIEvent *)event;

@end

@implementation PKDurationPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    
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
    NSLog(@"%@", [datePicker date]);
}

@end
