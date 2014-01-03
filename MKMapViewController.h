//
//  MKMapViewController.h
//  MKMapViewController
//
//  Created by Ignacio on 10/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import <MapKit/MapKit.h>

/**  */
typedef NS_ENUM(NSInteger, MKMapViewControllerProvider) {
    MKMapViewControllerProviderApple = (1 << 0),                // http://bit.ly/15g58Eb
    MKMapViewControllerProviderGoogle = (1 << 1),               // https://developers.google.com/maps/
    MKMapViewControllerProviderWaze = (1 << 2),                 // https://www.waze.com/about/dev
    MKMapViewControllerProviderMapBox = (1 << 3)                // https://www.mapbox.com/developers/
};

typedef NS_OPTIONS(NSUInteger, MKMapViewControllerSupport) {
    MKMapViewControllerSupportStandard = (1 << 0),              // MKMapTypeStandard
    MKMapViewControllerSupportSatellite = (1 << 1),             // MKMapTypeSatellite
    MKMapViewControllerSupportHybrid = (1 << 2)                 // MKMapTypeHybrid
};

/**
 */
@interface MKMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>

/** */
@property (nonatomic, strong) MKMapView *mapView;
/** */
@property (nonatomic, readonly) CLLocation *location;
/** */
@property (nonatomic, readwrite) MKMapViewControllerSupport mapSegments;
/** */
@property (nonatomic, readwrite) MKMapViewControllerProvider mapProviders;
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
