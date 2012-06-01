//
//  PKDurationPickerViewController.h
//  Parked
//
//  Created by Rhys Powell on 30/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKParkingDetails;

@interface PKDurationPickerViewController : UITableViewController <UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) PKParkingDetails *parkingDetails;

@end
