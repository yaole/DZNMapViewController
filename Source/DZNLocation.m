//
//  DZNLocation.m
//  Sample
//
//  Created by Ignacio on 4/22/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "DZNLocation.h"

@implementation DZNLocation

- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate
{
    return [self initWithTitle:title subtitle:nil coordinate:coordinate];
}

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle coordinate:(CLLocationCoordinate2D)coordinate
{
    return [self initWithTitle:title subtitle:subtitle latitude:coordinate.latitude longitude:coordinate.longitude];
}

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
{
    self = [super initWithLatitude:latitude longitude:longitude];
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}

- (CLLocationDegrees)latitude
{
    return self.coordinate.latitude;
}

- (CLLocationDegrees)longitude
{
    return self.coordinate.longitude;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"title : %@ | subtitle : %@ | Latitude : %f | longitude : %f | image : %@ | url : %@", self.title, self.subtitle, self.coordinate.latitude, self.coordinate.longitude, self.image, self.url];
}

@end
