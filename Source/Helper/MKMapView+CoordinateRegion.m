//
//  MKMapView+CoordinateRegion.m
//  DZNMapViewController
//  https://github.com/dzenbot/DZNMapViewController
//
//  Created by Ignacio Romero Zurbuchen on 4/22/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "MKMapView+CoordinateRegion.h"

@implementation MKMapView (CoordinateRegion)

- (MKCoordinateRegion)regionForAnnotations
{
    return [self regionForAnnotationsWithPadding:0];
}

- (MKCoordinateRegion)regionForAnnotationsWithPadding:(CGFloat)padding
{
    CLLocationDegrees minLat = 90.0;
    CLLocationDegrees maxLat = -90.0;
    CLLocationDegrees minLon = 180.0;
    CLLocationDegrees maxLon = -180.0;
    
    for (id <MKAnnotation> annotation in self.annotations) {
        if (annotation.coordinate.latitude < minLat) {
            minLat = annotation.coordinate.latitude;
        }
        if (annotation.coordinate.longitude < minLon) {
            minLon = annotation.coordinate.longitude;
        }
        if (annotation.coordinate.latitude > maxLat) {
            maxLat = annotation.coordinate.latitude;
        }
        if (annotation.coordinate.longitude > maxLon) {
            maxLon = annotation.coordinate.longitude;
        }
    }
    
    MKCoordinateSpan span = MKCoordinateSpanMake((maxLat - minLat)+padding*2, (maxLon - minLon)+padding*2);
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(((maxLat - span.latitudeDelta / 2))+padding, (maxLon - span.longitudeDelta / 2)+padding);
    
    return MKCoordinateRegionMake(center, span);
}

@end
