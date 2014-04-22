//
//  DZNLocation.h
//  Sample
//
//  Created by Ignacio on 4/22/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface DZNLocation : CLLocation

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, readonly) CLLocationDegrees latitude;
@property (nonatomic, readonly) CLLocationDegrees longitude;

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

@end
