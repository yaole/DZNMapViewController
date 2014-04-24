//
//  MKMapView+Region.h
//  Sample
//
//  Created by Ignacio on 4/24/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (Region)

- (MKCoordinateRegion)regionForAnnotations;
- (MKCoordinateRegion)regionForAnnotationsWithPadding:(CGFloat)padding;

@end
