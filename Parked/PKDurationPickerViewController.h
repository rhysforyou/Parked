//
//  PKDurationPickerViewController.h
//  Parked
//
//  Created by Rhys Powell on 11/07/12.
//
//

#import <UIKit/UIKit.h>

@class PKParkingDetails;

@interface PKDurationPickerViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UILabel *expirationLabel;
@property (strong, nonatomic) PKParkingDetails *parkingDetails;

@end
