//
//  PKParkingDetails.m
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PKParkingDetails.h"

@interface PKParkingDetails ()

- (NSString *)descriptionOfTimeInterval:(NSTimeInterval)timeInterval;

@end

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
        self.hasAlert = false;
        self.alertOffset = 1800;
    }
    
    return self;
}

- (NSString *)durationString
{
    return [self descriptionOfTimeInterval:self.timeInterval];
}

- (NSString *)alertDurationString
{
    return [self descriptionOfTimeInterval:self.alertOffset];
}

- (NSString *)descriptionOfTimeInterval:(NSTimeInterval)timeInterval
{
    int hours = timeInterval / 3600;
    int minutes = ((int)timeInterval % 3600) / 60;
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
