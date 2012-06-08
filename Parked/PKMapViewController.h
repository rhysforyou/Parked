//
//  PKMapViewController.h
//  Parked
//
//  Created by Rhys Powell on 8/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class PKParkingDetails;
@class PKAnnotation;

@interface PKMapViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) PKParkingDetails *parkingDetails;
@property (nonatomic, strong) PKAnnotation *annotation;

- (IBAction)centerOnCar:(id)sender;
- (IBAction)centerOnUserLocation:(id)sender;
- (IBAction)showWalkingDirections:(id)sender;

@end
