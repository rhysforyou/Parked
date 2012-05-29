//
//  PKDetailViewController.m
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "PKDetailViewController.h"
#import "PKParkingDetails.h"

@interface PKDetailViewController ()

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) PKAnnotation *annotation;
@property (strong, nonatomic) NSTimer *timer;

- (void)centerMapOnLocation:(CLLocation *)location animated:(BOOL)animated;
- (void)setTimerWithInterval:(NSTimeInterval)interval;
- (void)updateTimer;

@end

@implementation PKDetailViewController
@synthesize annotation = _annotation;
@synthesize mapView = _mapView;
@synthesize locationLabel = _locationLabel;
@synthesize parkingDetails = _parkingDetails;
@synthesize noteTextView = _noteTextView;
@synthesize timerView = _timerView;
@synthesize geocoder = _geocoder;
@synthesize timer;

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.geocoder = [[CLGeocoder alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Add annotation for the user's location
    self.annotation = [[PKAnnotation alloc] initWithParkingDetails:self.parkingDetails];
    [self.mapView addAnnotation:self.annotation];
    [self.annotation addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.noteTextView setText:self.parkingDetails.notes];
    [self setTimerWithInterval:self.parkingDetails.timeInterval];
    
    // Center map on current location
    [self.mapView setCenterCoordinate:[self.parkingDetails.location coordinate]];
    
    // Start the countdown timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTimer) userInfo:NULL repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    // Animated zoom
    [self centerMapOnLocation:self.parkingDetails.location animated:YES];
}

- (void)viewDidUnload
{
    [self setNoteTextView:nil];
    [self setTimerView:nil];
    [super viewDidUnload];
    [self setLocationLabel:nil];
    [self setMapView:nil];
    [self setGeocoder:nil];
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

- (void)setTimerWithInterval:(NSTimeInterval)interval
{
    int minutes = interval / 60;
    int seconds = (int)interval % 60;
    if (minutes <= 0 && seconds <= 0) {
        self.timerView.text = @"00:00";
    } else {
        self.timerView.text = [NSString stringWithFormat:@"%.2d:%.2d", 
                               minutes, seconds];
    }
}

- (void)updateTimer
{
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self.parkingDetails.startTime];
    NSTimeInterval remainingTime = self.parkingDetails.timeInterval - delta;
    [self setTimerWithInterval:remainingTime];
}

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"title"]) {
        self.locationLabel.text = [(PKAnnotation *)object title];
    }
}

@end
