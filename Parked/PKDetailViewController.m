//
//  PKDetailViewController.m
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PKDetailViewController.h"
#import "PKParkingDetails.h"
#import <CoreLocation/CoreLocation.h>

@interface PKDetailViewController ()
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) PKAnnotation *annotation;

- (void)centerMapOnLocation:(CLLocation *)location;
@end

@implementation PKDetailViewController
@synthesize annotation = _annotation;
@synthesize mapView = _mapView;
@synthesize locationLabel = _locationLabel;
@synthesize parkingDetails = _parkingDetails;
@synthesize noteTextView = _noteTextView;
@synthesize geocoder = _geocoder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.geocoder = [[CLGeocoder alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.mapView setCenterCoordinate:[self.parkingDetails.location coordinate]];
    self.annotation = [[PKAnnotation alloc] initWithParkingDetails:self.parkingDetails];
    [self.mapView addAnnotation:self.annotation];
    [self.annotation addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.noteTextView setText:self.parkingDetails.notes];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self centerMapOnLocation:self.parkingDetails.location];
}

- (void)centerMapOnLocation:(CLLocation *)location
{
    MKCoordinateRegion coordinateRegion;
    coordinateRegion.center = location.coordinate;
    // Longitude varies based on latitude, so it's best to just use latitude for the span
    coordinateRegion.span = MKCoordinateSpanMake(0.002, 0.0);
    coordinateRegion = [self.mapView regionThatFits:coordinateRegion];
    [self.mapView setRegion:coordinateRegion animated:YES];
}

- (void)viewDidUnload
{
    [self setNoteTextView:nil];
    [super viewDidUnload];
    [self setLocationLabel:nil];
    [self setMapView:nil];
    [self setGeocoder:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"title"]) {
        self.locationLabel.text = [(PKAnnotation *)object title];
    }
}

@end
