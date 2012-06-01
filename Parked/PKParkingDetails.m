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
    int hours = self.timeInterval / 3600;
    int minutes = ((int)self.timeInterval % 3600) / 60;
    if (minutes && hours) {
        if (hours > 1) {
            return [NSString stringWithFormat:@"%d hours and %d minutes", hours, minutes];
        } else {
            return [NSString stringWithFormat:@"1 hour and %d minutes", minutes];
        }
    } else if (hours) {
        if (hours > 1) {
            return [NSString stringWithFormat:@"%d hours", hours];
        } else {
            return @"1 hour";
        }
    } else if (minutes) {
        return [NSString stringWithFormat:@"%d minutes", minutes];
    } else {
        return @"Not set";
    }
}

@end
