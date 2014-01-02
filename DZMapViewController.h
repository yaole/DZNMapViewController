//
//  DZMapViewController.h
//  DZMapViewController
//
//  Created by Ignacio on 10/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import <MapKit/MapKit.h>

/**  */
typedef NS_ENUM(NSInteger, DZMapViewControllerProvider) {
    DZMapViewControllerProviderApple = (1 << 0),                // http://bit.ly/15g58Eb
    DZMapViewControllerProviderGoogle = (1 << 1),               // https://developers.google.com/maps/
    DZMapViewControllerProviderWaze = (1 << 2),                 // https://www.waze.com/about/dev
    DZMapViewControllerProviderMapBox = (1 << 3)                // https://www.mapbox.com/developers/
};

typedef NS_OPTIONS(NSUInteger, DZMapViewControllerSegment) {
    DZMapViewControllerSegmentStandard = (1 << 0),              // MKMapTypeStandard
    DZMapViewControllerSegmentSatellite = (1 << 1),             // MKMapTypeSatellite
    DZMapViewControllerSegmentHybrid = (1 << 2)                 // MKMapTypeHybrid
};

/**
 */
@interface DZMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>

/** */
@property (nonatomic, strong) MKMapView *mapView;
/** */
@property (nonatomic, readonly) CLLocation *location;
/** */
@property (nonatomic, readwrite) DZMapViewControllerSegment mapSegments;
/** */
@property (nonatomic, readwrite) DZMapViewControllerProvider mapProviders;
/** */
@property (nonatomic, readonly) MKMapType currentMapType;
/** */
@property (nonatomic) BOOL showCallout;
/** */
@property (nonatomic) BOOL allowExport;
/** */
@property (nonatomic) BOOL showsUserLocation;

/**
 *
 */
- (instancetype)initWithLocation:(CLLocation *)location;


@end
