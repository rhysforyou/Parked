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

@interface PKDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) PKParkingDetails *parkingDetails;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;

@end
