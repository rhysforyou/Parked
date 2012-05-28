//
//  PKParkingDetails.m
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PKParkingDetails.h"

@implementation PKParkingDetails

@synthesize location = _location;
@synthesize notes = _notes;

- (id)init
{
    self = [super init];
    
    // TODO: Make this happen in a controller
    if (self) {
        self.location = [[CLLocation alloc] initWithLatitude:-33.86867 longitude:151.207044];
        self.notes = @"On level 5 of parking garage";
    }
    
    return self;
}

@end
