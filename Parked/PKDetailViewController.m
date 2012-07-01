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
#import "PKMapViewController.h"

@interface PKDetailViewController ()

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) PKAnnotation *annotation;
@property (strong, nonatomic) NSTimer *timer;

- (void)centerMapOnLocation:(CLLocation *)location animated:(BOOL)animated;
- (void)setTimerWithInterval:(NSTimeInterval)interval;
- (void)updateTimer;
- (void)didEnterBackground;
- (void)didBecomeActive;
- (void)beginTimer;
- (void)postLocalNotification;
- (void)updateAddress;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didEnterBackground) 
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didBecomeActive) 
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *archivePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Current.park"];
    self.parkingDetails = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    
    // Add annotation for the user's location
    [self.mapView removeAnnotations:[self.mapView annotations]];
    self.annotation = [[PKAnnotation alloc] initWithParkingDetails:self.parkingDetails];
    [self.mapView addAnnotation:self.annotation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(updateAddress) 
                                                 name:parkingDetailsAddressStringDidUpdateNotification 
                                               object:nil];
    
    [self.noteTextView setText:self.parkingDetails.notes];
    [self setTimerWithInterval:self.parkingDetails.timeInterval];
    
    // Center map on current location
    [self.mapView setCenterCoordinate:[self.parkingDetails.location coordinate]];
    
    [self beginTimer];
    [self updateTimer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self centerMapOnLocation:self.parkingDetails.location animated:YES];
    
    if (self.parkingDetails.hasAlert) [self postLocalNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didEnterBackground
{
    [self.timer invalidate];
}

- (void)didBecomeActive
{
    [self beginTimer];
    
    NSTimeInterval expirationTime = [self.parkingDetails.startTime timeIntervalSince1970] + self.parkingDetails.timeInterval;
    NSTimeInterval timeSinceExpiration = [[NSDate date] timeIntervalSince1970] - expirationTime;
    
    NSLog(@"%f", timeSinceExpiration);
    
    if (timeSinceExpiration > 15 * 60 || self.parkingDetails == Nil) { // 15 minutes
        [self performSegueWithIdentifier:@"newPark" sender:self];
    }
}

- (void)updateAddress
{
    self.locationLabel.text = self.parkingDetails.addressString;
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
    int hours = interval / 3600;
    int minutes = ((int)interval % 3600) / 60;
    int seconds = (int)interval % 60;
    if (minutes <= 0 && seconds <= 0) {
        self.timerView.text = @"00:00";
    } else {
        self.timerView.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", 
                               hours, minutes, seconds];
    }
}

- (void)updateTimer
{
    [self setTimerWithInterval:[self.parkingDetails remainingTime]];
}

- (void)beginTimer
{
    if (![self.timer isValid]) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(updateTimer)
                                                    userInfo:NULL
                                                     repeats:YES];
    }
}

- (void)postLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"Your parking will run out in %@", [self.parkingDetails alertDurationString]];
    NSTimeInterval offset = self.parkingDetails.timeInterval - self.parkingDetails.alertOffset;
    notification.fireDate = [NSDate dateWithTimeInterval:offset sinceDate:self.parkingDetails.startTime];
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showLargeMap"]) {
        PKMapViewController *destinationVC = (PKMapViewController *)[segue destinationViewController];
        destinationVC.parkingDetails = self.parkingDetails;
        destinationVC.annotation = self.annotation;
    }
}

@end
