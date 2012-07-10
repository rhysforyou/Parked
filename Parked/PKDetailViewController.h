//
//  PKDetailViewController.h
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PKAnnotation.h"

@class PKParkingDetails;

@interface PKDetailViewController : UIViewController <UIActionSheetDelegate>

- (IBAction)clear:(id)sender;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) IBOutlet UILabel *timerView;
@property (strong, nonatomic) PKParkingDetails *parkingDetails;

@end
