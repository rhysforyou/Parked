//
//  PKParkingDetails.h
//  Parked
//
//  Created by Rhys Powell on 28/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PKParkingDetails : NSObject

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *notes;
@property (nonatomic) NSTimeInterval timeInterval;

@end
