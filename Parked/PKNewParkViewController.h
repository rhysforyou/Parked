//
//  PKNewParkViewController.h
//  Parked
//
//  Created by Rhys Powell on 29/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class PKParkingDetails;

@interface PKNewParkViewController : UITableViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITextView *notesViw;
@property (strong, nonatomic) PKParkingDetails *parkingDetails;

@end
