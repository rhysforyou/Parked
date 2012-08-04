//
//  PKAnnotation.h
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 Rhys Powell. All rights reserved.
//

#import <MapKit/MapKit.h>

@class PKParkingDetails;

@interface PKAnnotation : NSObject <MKAnnotation>

- (id)initWithParkingDetails:(PKParkingDetails *)parkingDetails;

@end