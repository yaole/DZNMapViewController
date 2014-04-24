//
//  MKMapView+CoordinateRegion.h
//  DZNMapViewController
//  https://github.com/dzenbot/DZNMapViewController
//
//  Created by Ignacio Romero Zurbuchen on 4/22/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <MapKit/MapKit.h>

@interface MKMapView (CoordinateRegion)

- (MKCoordinateRegion)regionForAnnotations;
- (MKCoordinateRegion)regionForAnnotationsWithPadding:(CGFloat)padding;

@end

