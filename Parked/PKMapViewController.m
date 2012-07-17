//
//  PKMapViewController.m
//  Parked
//
//  Created by Rhys Powell on 8/06/12.
//  Copyright (c) 2012 Rhys Powell. All rights reserved.
//

#import "PKMapViewController.h"
#import "PKAnnotation.h"
#import "PKParkingDetails.h"

@interface PKMapViewController ()

@end

@implementation PKMapViewController
@synthesize mapView;
@synthesize parkingDetails;
@synthesize annotation;

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:animated];
    [self.mapView addAnnotation:self.annotation];
    [self centerMapOnLocation:self.parkingDetails.location animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Utility Methods

- (void)centerMapOnLocation:(CLLocation *)location animated:(BOOL)animated
{
    MKCoordinateRegion coordinateRegion;
    coordinateRegion.center = location.coordinate;
    // Longitude varies based on latitude, so it's best to just use latitude for the span
    coordinateRegion.span = MKCoordinateSpanMake(0.002, 0.0);
    coordinateRegion = [self.mapView regionThatFits:coordinateRegion];
    [self.mapView setRegion:coordinateRegion animated:animated];
}

#pragma mark - Toolbar Actions

- (IBAction)centerOnCar:(id)sender {
    [self centerMapOnLocation:self.parkingDetails.location animated:YES];
}

- (IBAction)centerOnUserLocation:(id)sender {
    [self centerMapOnLocation:mapView.userLocation.location animated:YES];
}

#ifdef __IPHONE_6_0
- (IBAction)showWalkingDirections:(id)sender {
    if ([self.parkingDetails.mapItem respondsToSelector:@selector(openInMapsWithLaunchOptions:)]) {
        
        NSDictionary *launchOptions = @{
        MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking,
        MKLaunchOptionsMapTypeKey : [NSNumber numberWithInt:MKMapTypeStandard]
        };
        [self.parkingDetails.mapItem openInMapsWithLaunchOptions:launchOptions];
    }
    NSString *mapURL = @"http://maps.google.com/maps?";
    mapURL = [mapURL stringByAppendingFormat:@"saddr=%f,%f&", 
              self.mapView.userLocation.location.coordinate.latitude, 
              self.mapView.userLocation.location.coordinate.longitude];
    mapURL = [mapURL stringByAppendingFormat:@"daddr=%f,%f&",
              self.parkingDetails.location.coordinate.latitude,
              self.parkingDetails.location.coordinate.longitude];
    mapURL = [mapURL stringByAppendingFormat:@"dirflg=w"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapURL]];
}
#else
- (IBAction)showWalkingDirections:(id)sender {
    NSString *mapURL = @"http://maps.google.com/maps?";
    mapURL = [mapURL stringByAppendingFormat:@"saddr=%f,%f&", 
              self.mapView.userLocation.location.coordinate.latitude, 
              self.mapView.userLocation.location.coordinate.longitude];
    mapURL = [mapURL stringByAppendingFormat:@"daddr=%f,%f&",
              self.parkingDetails.location.coordinate.latitude,
              self.parkingDetails.location.coordinate.longitude];
    mapURL = [mapURL stringByAppendingFormat:@"dirflg=w"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapURL]];
}
#endif

@end
