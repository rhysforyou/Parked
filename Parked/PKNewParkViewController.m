//
//  PKNewParkViewController.m
//  Parked
//
//  Created by Rhys Powell on 29/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PKNewParkViewController.h"
#import "PKDetailViewController.h"
#import "PKDurationPickerViewController.h"
#import "PKParkingDetails.h"

@interface PKNewParkViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PKNewParkViewController

@synthesize parkingDetails;
@synthesize mapView;
@synthesize notesView;
@synthesize durationLabel;
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
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.parkingDetails) {
        self.parkingDetails = [[PKParkingDetails alloc] init];
    }
    self.durationLabel.text = [self.parkingDetails durationString];
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
    if ([segue.identifier isEqualToString:@"showDurationPicker"]) {
        PKDurationPickerViewController *durationVC = (PKDurationPickerViewController *)[segue destinationViewController];
        durationVC.parkingDetails = self.parkingDetails;
    }
}

- (IBAction)save:(id)sender {
    self.parkingDetails.startTime = [NSDate date];
    self.parkingDetails.notes = self.notesView.text;
    NSString *archivePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Current.park"];
    [NSKeyedArchiver archiveRootObject:self.parkingDetails toFile:archivePath];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
