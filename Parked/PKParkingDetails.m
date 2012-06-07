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
        self.timeInterval = 3600;
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

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.location forKey:@"PKParkingDetailsLocation"];
    [aCoder encodeObject:self.notes forKey:@"PKParkingDetailsNote"];
    [aCoder encodeObject:self.startTime forKey:@"PKParkingDetailsStartTime"];
    [aCoder encodeDouble:self.timeInterval forKey:@"PKParkingDetailsTimeInterval"];
    [aCoder encodeBool:self.hasAlert forKey:@"PKParkingDetailsHasAlert"];
    [aCoder encodeDouble:self.alertOffset forKey:@"PKParkingDetailsAlertOffset"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.location = [aDecoder decodeObjectForKey:@"PKParkingDetailsLocation"];
    self.notes = [aDecoder decodeObjectForKey:@"PKParkingDetailsNote"];
    self.startTime = [aDecoder decodeObjectForKey:@"PKParkingDetailsStartTime"];
    self.timeInterval = [aDecoder decodeDoubleForKey:@"PKParkingDetailsTimeInterval"];
    self.hasAlert = [aDecoder decodeBoolForKey:@"PKParkingDetailsHasAlert"];
    self.alertOffset = [aDecoder decodeDoubleForKey:@"PKParkingDetailsAlertOffset"];
    
    return self;
}

@end
