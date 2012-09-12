//
//  PKDetailViewController.m
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 Rhys Powell. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "PKDetailViewController.h"
#import "PKParkingDetails.h"
#import "PKMapViewController.h"

@interface PKDetailViewController ()

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) PKAnnotation *annotation;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIImageView *noDataView;

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
@synthesize timer = _timer;
@synthesize noDataView = _noDataView;

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
    
    self.mapView.layer.borderWidth = 5.0;
    self.mapView.layer.borderColor = [[UIColor whiteColor] CGColor];

    CALayer *shadowLayer        = [[CALayer alloc] init];
    
    shadowLayer.shadowColor     = [[UIColor blackColor] CGColor];
    shadowLayer.backgroundColor = [[UIColor whiteColor] CGColor];
    shadowLayer.shadowOffset    = CGSizeMake(0.0, 5.0);
    shadowLayer.shadowRadius    = 5.0;
    shadowLayer.shadowOpacity   = 0.2;
    
    shadowLayer.masksToBounds   = NO;
    
    CGRect shadowLayerFrame     = self.mapView.layer.frame;
    shadowLayerFrame.origin.y  -= self.navigationController.navigationBar.frame.size.height;
    shadowLayer.frame           = shadowLayerFrame;

    [self.view.layer insertSublayer:shadowLayer below:self.mapView.layer];
    
    if ([[UIScreen mainScreen] bounds].size.height > 480) {
        self.noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no-parking-details-568"]];
    } else {
        self.noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no-parking-details"]];
    }
         
    CGRect viewFrame = [[UIScreen mainScreen] bounds];
    viewFrame.size.height -= 64;
    self.noDataView.frame = viewFrame;
    self.noDataView.hidden = YES;
    [self.view addSubview:self.noDataView];
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
    
    if ([self.parkingDetails.notes length] > 0) {
        [self.noteTextView setText:self.parkingDetails.notes];
        [self.noteTextView setTextColor:[UIColor blackColor]];
        [self.noteTextView setTextAlignment:NSTextAlignmentLeft];
    } else {
        [self.noteTextView setText:@"(no notes)"];
        [self.noteTextView setTextColor:[UIColor lightGrayColor]];
        [self.noteTextView setTextAlignment:NSTextAlignmentLeft];
    }
    
    [self setTimerWithInterval:self.parkingDetails.timeInterval];
    
    // Center map on current location
    [self.mapView setCenterCoordinate:[self.parkingDetails.location coordinate]];
    
    if (self.parkingDetails.hasDuration) {
        [self beginTimer];
        [self updateTimer];
    } else {
        self.timerView.text = @"(no duration)";
    }
    
    if (self.parkingDetails == nil) {
        self.noDataView.hidden = NO;
        self.navigationItem.leftBarButtonItem .enabled = NO;
    } else {
        self.noDataView.hidden = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{   
    [self centerMapOnLocation:self.parkingDetails.location animated:YES];
    
    if (self.parkingDetails.hasAlert) [self postLocalNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
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
    if (self.parkingDetails.hasDuration) {
        [self beginTimer];
    }
}

- (void)updateAddress
{
    self.locationLabel.text = self.parkingDetails.addressString;
}

#pragma mark - Interface Builder Actions

- (IBAction)clear:(id)sender
{
    UIActionSheet *confirmationSheet = [[UIActionSheet alloc] initWithTitle:@"Delete all parking details?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                     destructiveButtonTitle:@"Clear"
                                                          otherButtonTitles:nil];
    
    [confirmationSheet showInView:self.view];
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // Clear
        self.parkingDetails = nil;
        NSString *archivePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Current.park"];
        [[NSFileManager defaultManager] removeItemAtPath:archivePath error:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // Clear
        self.noDataView.hidden = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }
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
