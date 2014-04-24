//
//  MKMapView+Region.m
//  Sample
//
//  Created by Ignacio on 4/24/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "MKMapView+Region.h"

@implementation MKMapView (Region)

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
