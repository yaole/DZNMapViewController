//
//  DZNMapViewController.h
//  DZNMapViewController
//
//  Created by Ignacio on 10/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import <MapKit/MapKit.h>

/**  */
typedef NS_ENUM(NSInteger, DZNMapViewControllerProvider) {
    DZNMapViewControllerProviderApple = (1 << 0),                // http://bit.ly/15g58Eb
    DZNMapViewControllerProviderGoogle = (1 << 1),               // https://developers.google.com/maps/
    DZNMapViewControllerProviderWaze = (1 << 2),                 // https://www.waze.com/about/dev
    DZNMapViewControllerProviderMapBox = (1 << 3)                // https://www.mapbox.com/developers/
};

typedef NS_OPTIONS(NSUInteger, DZNMapViewControllerSupport) {
    DZNMapViewControllerSupportStandard = (1 << 0),              // MKMapTypeStandard
    DZNMapViewControllerSupportSatellite = (1 << 1),             // MKMapTypeSatellite
    DZNMapViewControllerSupportHybrid = (1 << 2)                 // MKMapTypeHybrid
};

/**
 */
@interface DZNMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>

/** */
@property (nonatomic, strong) MKMapView *mapView;
/** */
@property (nonatomic, readonly) CLLocation *location;
/** */
@property (nonatomic, readwrite) DZNMapViewControllerSupport mapSegments;
/** */
@property (nonatomic, readwrite) DZNMapViewControllerProvider mapProviders;
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
