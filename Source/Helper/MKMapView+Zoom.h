//
//  MKMapView+Zoom.h
//  DZNMapViewController
//  https://github.com/dzenbot/DZNMapViewController
//
//  Created by Ignacio Romero Zurbuchen on 4/22/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <MapKit/MapKit.h>

@interface MKMapView (Zoom)

/* The current zoom level of the map.
 Based on Troy's Blog article on http://troybrant.net/blog/2010/01/set-the-zoom-level-of-an-mkmapview/ */
@property (nonatomic, readonly) NSUInteger zoomLevel;

@end
