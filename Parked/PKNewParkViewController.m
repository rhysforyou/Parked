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
#import "PKAlarmPickerViewController.h"
#import "PKNoteEditorViewController.h"
#import "PKParkingDetails.h"
#import "PKDurationCell.h"
#import "PKNotesCell.h"
#import <QuartzCore/QuartzCore.h>

@interface PKNewParkViewController ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PKNewParkViewController

@synthesize parkingDetails;
@synthesize mapView;
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
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHue:0 saturation:0 brightness:0.9 alpha:0]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHue:0.61 saturation:0.3 brightness:0.8 alpha:0]];
    
    [self.tableView setBackgroundColor:[UIColor colorWithHue:0.0 saturation:0.0 brightness:0.9 alpha:1.0]];
    
    self.mapView.layer.borderWidth = 5.0;
    self.mapView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    CALayer *shadowLayer        = [[CALayer alloc] init];
    
    shadowLayer.shadowColor     = [[UIColor blackColor] CGColor];
    shadowLayer.backgroundColor = [[UIColor whiteColor] CGColor];
    shadowLayer.shadowOffset    = CGSizeMake(0.0, 0.0);
    shadowLayer.shadowRadius    = 5.0;
    shadowLayer.shadowOpacity   = 0.2;
    
    shadowLayer.masksToBounds   = NO;
    
    CGRect shadowLayerFrame     = self.mapView.layer.frame;
    shadowLayerFrame.origin.y  -= self.navigationController.navigationBar.frame.size.height;
    shadowLayer.frame           = shadowLayerFrame;
    
    [self.view.layer insertSublayer:shadowLayer below:self.mapView.layer];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.parkingDetails) {
        self.parkingDetails = [[PKParkingDetails alloc] init];
    }
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
    
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDurationPicker"]) {
        PKDurationPickerViewController *destinationVC = segue.destinationViewController;
        destinationVC.parkingDetails = self.parkingDetails;
    } else if ([segue.identifier isEqualToString:@"showAlarmPicker"]) {
        PKAlarmPickerViewController *destinationVC = segue.destinationViewController;
        destinationVC.parkingDetails = self.parkingDetails;
    } else if ([segue.identifier isEqualToString:@"showNoteEditor"]) {
        PKNoteEditorViewController *destinationVC = segue.destinationViewController;
        destinationVC.parkingDetails = self.parkingDetails;
    }
}

#pragma mark - Interface Builder Actions

- (IBAction)save:(id)sender {
    UITableViewCell *durationToggleCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.parkingDetails.hasDuration = [(UISwitch *)durationToggleCell.accessoryView isOn];
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
            [[(PKDurationCell *)cell durationLabel] setText:self.parkingDetails.durationString];
            [[(PKDurationCell *)cell expirationLabel] setText:self.parkingDetails.durationExpirationString];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"durationAlarmCell"];
            [(UILabel *)cell.detailTextLabel setText:self.parkingDetails.alertDurationString];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"notesCell"];
        
        UILabel *notesView = [(PKNotesCell *)cell notesView];
        notesView.text = self.parkingDetails.notes;
        [notesView sizeToFit];
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
        return 110.0;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
