//
//  PKNewParkViewController.m
//  Parked
//
//  Created by Rhys Powell on 29/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PKNewParkViewController.h"
#import "PKDetailViewController.h"
#import "PKParkingDetails.h"

@interface PKNewParkViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PKNewParkViewController

@synthesize parkingDetails;
@synthesize mapView;
@synthesize notesViw;
@synthesize locationManager;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Get the user's location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setNotesViw:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.parkingDetails.location = newLocation;
    
    MKCoordinateRegion coordinateRegion;
    coordinateRegion.center = newLocation.coordinate;
    // Longitude varies based on latitude, so it's best to just use latitude for the span
    coordinateRegion.span = MKCoordinateSpanMake(0.002, 0.0);
    coordinateRegion = [self.mapView regionThatFits:coordinateRegion];
    [self.mapView setRegion:coordinateRegion animated:YES];
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushParkingDetails"]) {
        self.parkingDetails.notes = self.notesViw.text;
        PKDetailViewController *detailVC = (PKDetailViewController *)[segue destinationViewController];
        detailVC.parkingDetails = self.parkingDetails;
    }
}

@end
