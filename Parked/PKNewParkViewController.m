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
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHue:0.61 saturation:1 brightness:0.4 alpha:1]];
    
    [self.tableView setBackgroundColor:[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.9 alpha:1.0]];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.parkingDetails) {
        self.parkingDetails = [[PKParkingDetails alloc] init];
    }
    self.durationLabel.text = [self.parkingDetails durationString];
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
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

- (IBAction)toggleDuration:(UISwitch *)sender {
    self.parkingDetails.hasDuration = sender.on;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return (self.parkingDetails.hasDuration ? 3 : 1);
            break;
        
        case 1:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if ([indexPath section] == 0) {
        NSInteger row = [indexPath row];
        if (row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"durationToggleCell"];
            [(UISwitch *)cell.accessoryView setOn:self.parkingDetails.hasDuration];
        } else if (row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"durationLengthCell"];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"durationAlarmCell"];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"notesCell"];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Notes";
    } else {
        return nil;
    }
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        if ([indexPath row] == 1) {
            return 70.0;
        } else {
            return 44.0;
        }
    } else {
        return 100.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
