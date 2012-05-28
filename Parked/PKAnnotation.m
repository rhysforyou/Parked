//
//  PKAnnotation.m
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PKAnnotation.h"
#import "PKParkingDetails.h"

@implementation PKAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (id)initWithParkingDetails:(PKParkingDetails *)parkingDetails
{
    self = [super init];
    if (self) {
        _coordinate.latitude = parkingDetails.location.coordinate.latitude;
        _coordinate.longitude = parkingDetails.location.coordinate.longitude;
        _title = @"Getting address";
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude] completionHandler:^(NSArray* placemarks, NSError* error) {
            if ([placemarks count] > 0) {
                [self setValue:[[placemarks objectAtIndex:0] name] forKey:@"title"];
            } else {
                [self setValue:@"Unable to determine address" forKey:@"title"];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }    
    return self;
}

@end
