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
@property (nonatomic, strong) UIImage *image;

- (id)initWithTitle:(NSString *)title latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon;
- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon;
- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon;

@end
