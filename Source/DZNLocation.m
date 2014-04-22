//
//  DZNLocation.m
//  Sample
//
//  Created by Ignacio on 4/22/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "DZNLocation.h"

@implementation DZNLocation

- (id)initWithTitle:(NSString *)title latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon
{
    return [self initWithTitle:title subtitle:nil latitude:lat longitude:lon];
}

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon
{
    return [self initWithTitle:title subtitle:subtitle image:nil latitude:lat longitude:lon];
}

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image latitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon
{
    self = [super initWithLatitude:lat longitude:lon];
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.image = image;
    }
    return self;
}

@end
