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
@synthesize timeInterval = _timeInterval;
@synthesize startTime = _startTime;
@synthesize hasAlert = _hasAlert;
@synthesize alertOffset = _alertOffset;

- (id)init
{
    self = [super init];
    
    // TODO: Make this happen in a controller
    if (self) {
        self.notes = @"On level 5 of parking garage";
        self.timeInterval = 3600;
        self.startTime = [NSDate date];
    }
    
    return self;
}

- (NSString *)durationString
{
    int minutes = self.timeInterval / 60;
    return [NSString stringWithFormat:@"%d minutes", minutes];
}

@end
