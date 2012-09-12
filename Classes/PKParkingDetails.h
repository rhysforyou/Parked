//
//  PKParkingDetails.h
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 Rhys Powell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#include <MapKit/MapKit.h>

@interface PKParkingDetails : NSObject <NSCoding>

@property (strong, nonatomic) MKMapItem *mapItem;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSDate *startTime;
@property (readonly) NSString *addressString;
@property (strong, nonatomic) MKPlacemark *placemark;
@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic) BOOL hasAlert;
@property (nonatomic) BOOL hasDuration;
@property (nonatomic) NSTimeInterval alertOffset;

- (NSString *)durationString;
- (NSString *)durationExpirationString;
- (NSString *)alertDurationString;
- (NSTimeInterval)remainingTime;

// Notifications

extern NSString *parkingDetailsAddressStringDidUpdateNotification;

@end
