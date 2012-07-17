//
//  PKAnnotation.m
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 Rhys Powell. All rights reserved.
//

#import "PKAnnotation.h"
#import "PKParkingDetails.h"

@interface PKAnnotation ()

@property (strong, nonatomic) PKParkingDetails *parkingDetails;

@end

@implementation PKAnnotation

@synthesize coordinate = _coordinate;
@synthesize subtitle = _subtitle;
@synthesize title = _title;
@synthesize parkingDetails = _parkingDetails;

- (id)initWithParkingDetails:(PKParkingDetails *)parkingDetails
{
    self = [super init];
    if (self) {
        _coordinate.latitude = parkingDetails.location.coordinate.latitude;
        _coordinate.longitude = parkingDetails.location.coordinate.longitude;
        _parkingDetails = parkingDetails;
    }    
    return self;
}

- (NSString *)title
{
    return self.parkingDetails.addressString;
}

@end
