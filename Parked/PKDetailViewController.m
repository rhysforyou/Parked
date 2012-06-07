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
- (void)didEnterBackground;
- (void)didBecomeActive;
- (void)beginTimer;
- (void)postLocalNotification;

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
    self.annotation = [[PKAnnotation alloc] initWithParkingDetails:self.parkingDetails];
    [self.mapView addAnnotation:self.annotation];
    [self.annotation addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setLocationLabel:nil];
    [self setMapView:nil];
    [self setGeocoder:nil];
    [self setNoteTextView:nil];
    [self setTimerView:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.annotation removeObserver:self forKeyPath:@"title"];
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
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self.parkingDetails.startTime];
    NSTimeInterval remainingTime = self.parkingDetails.timeInterval - delta;
    [self setTimerWithInterval:remainingTime];
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
    notification.fireDate = [NSDate dateWithTimeInterval:self.parkingDetails.timeInterval sinceDate:self.parkingDetails.startTime];
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual:@"title"]) {
        self.locationLabel.text = [(PKAnnotation *)object title];
    }
}

@end
