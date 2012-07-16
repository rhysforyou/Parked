//
//  PKAlarmPickerViewController.h
//  Parked
//
//  Created by Rhys Powell on 13/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PKParkingDetails;

@interface PKAlarmPickerViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) PKParkingDetails *parkingDetails;

@end
