//
//  DZNMapViewController.m
//  DZNMapViewController
//
//  Created by Ignacio Romero Zurbuchen on 10/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import "DZNMapViewController.h"
#import "DZNAnnotation.h"
#import "MKMapView+Zoom.h"

static NSString *annotationIdentifier = @"DZNMapViewAnnotation";

@interface DZNMapViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) BOOL canHideBars;
@end

@implementation DZNMapViewController


- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    return [self initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

- (instancetype)initWithLatitude:(CLLocationDegrees)lat longitude:(CLLocationDegrees)lon
{
    DZNLocation *location = [[DZNLocation alloc] initWithLatitude:lat longitude:lon];
    return [self initWithLocation:location];
}

- (instancetype)initWithLocation:(DZNLocation *)location
{
    return [self initWithLocations:@[location]];
}

- (instancetype)initWithLocations:(NSArray *)locations
{
    self = [super init];
    if (self) {
        _locations = [NSArray arrayWithArray:locations];
    }
    return self;
}


#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    self.view = self.mapView;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addAllAnnotations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _canHideBars = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


#pragma mark - Getter methods

- (MKMapView *)mapView
{
    if (!_mapView)
    {
         MKMapType mapType = MKMapTypeFromString([self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex]);
        
        _mapView = [MKMapView new];
        _mapView.mapType = mapType;
        _mapView.rotateEnabled = YES;
        _mapView.pitchEnabled = YES;
        _mapView.showsPointsOfInterest = NO;
        _mapView.showsUserLocation = _showsUserLocation;
        _mapView.delegate = self;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMapTap:)];
        tapGesture.delegate = self;
        tapGesture.delaysTouchesBegan = YES;
        tapGesture.delaysTouchesEnded = YES;

        for (UIView *subview in _mapView.subviews) {
            for (UITapGestureRecognizer *gesture in subview.gestureRecognizers) {
                if ([gesture isKindOfClass:[UITapGestureRecognizer class]] && gesture.numberOfTapsRequired == 2) {
                    [tapGesture requireGestureRecognizerToFail:gesture];
                }
            }
        }
        [_mapView addGestureRecognizer:tapGesture];
    }
    return _mapView;
}

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl)
    {
        NSArray *titles = [self segmentedControlTitles];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:titles];
        [_segmentedControl addTarget:self action:@selector(selectedScopeButton:) forControlEvents:UIControlEventValueChanged];
        [_segmentedControl setSelectedSegmentIndex:0];
        
        CGFloat width = 180.0/titles.count;
        
        for (int i = 0; i < titles.count; i++) {
            [_segmentedControl setWidth:width forSegmentAtIndex:i];
        }
    }
    return _segmentedControl;
}

- (NSArray *)segmentedControlTitles
{
    NSMutableArray *titles = [NSMutableArray array];
    if ((_mapSegments & DZNMapViewControllerSupportStandard) > 0) {
        [titles addObject:NSStringFromMapType(MKMapTypeStandard)];
    }
    if ((_mapSegments & DZNMapViewControllerSupportSatellite) > 0) {
        [titles addObject:NSStringFromMapType(MKMapTypeSatellite)];
    }
    if ((_mapSegments & DZNMapViewControllerSupportHybrid) > 0) {
        [titles addObject:NSStringFromMapType(MKMapTypeHybrid)];
    }
    return titles;
}

- (NSArray *)actionSheetTitles
{
    NSMutableArray *titles = [NSMutableArray array];
    if ((_mapProviders & DZNMapViewControllerProviderApple) > 0) {
        [titles addObject:NSStringFromDZNMapViewControllerProvider(DZNMapViewControllerProviderApple)];
    }
    if ((_mapProviders & DZNMapViewControllerProviderGoogle) > 0 && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        [titles addObject:NSStringFromDZNMapViewControllerProvider(DZNMapViewControllerProviderGoogle)];
    }
    if ((_mapProviders & DZNMapViewControllerProviderWaze) > 0 && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]) {
        [titles addObject:NSStringFromDZNMapViewControllerProvider(DZNMapViewControllerProviderWaze)];
    }
    if ((_mapProviders & DZNMapViewControllerProviderMapBox) > 0 && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mapbox://"]]) {
        [titles addObject:NSStringFromDZNMapViewControllerProvider(DZNMapViewControllerProviderMapBox)];
    }
    return titles;
}

NSString *NSStringFromMapType(MKMapType mapType)
{
    switch (mapType) {
        case MKMapTypeStandard:
            return NSLocalizedString(@"Standard", nil);
        case MKMapTypeHybrid:
            return NSLocalizedString(@"Hybrid", nil);
        case MKMapTypeSatellite:
            return NSLocalizedString(@"Satellite", nil);
    }
}

MKMapType MKMapTypeFromString(NSString *string)
{
    if ([string isEqualToString:NSStringFromMapType(MKMapTypeStandard)]) {
        return MKMapTypeStandard;
    }
    else if ([string isEqualToString:NSStringFromMapType(MKMapTypeHybrid)]) {
        return MKMapTypeHybrid;
    }
    else {
        return MKMapTypeSatellite;
    }
}

DZNMapViewControllerProvider mapViewControllerProviderFromString(NSString *string)
{
    if ([string isEqualToString:NSStringFromDZNMapViewControllerProvider(DZNMapViewControllerProviderGoogle)]) {
        return DZNMapViewControllerProviderGoogle;
    }
    else if ([string isEqualToString:NSStringFromDZNMapViewControllerProvider(DZNMapViewControllerProviderWaze)]) {
        return DZNMapViewControllerProviderWaze;
    }
    else if ([string isEqualToString:NSStringFromDZNMapViewControllerProvider(DZNMapViewControllerProviderMapBox)]) {
        return DZNMapViewControllerProviderMapBox;
    }
    else {
        return DZNMapViewControllerProviderApple;
    }
}

NSString *NSStringFromDZNMapViewControllerProvider(DZNMapViewControllerProvider provider)
{
    if ((provider & DZNMapViewControllerProviderGoogle) > 0) {
        return NSLocalizedString(@"Google Maps", nil);
    }
    else if ((provider & DZNMapViewControllerProviderWaze) > 0) {
        return NSLocalizedString(@"Waze", nil);
    }
    else if ((provider & DZNMapViewControllerProviderMapBox) > 0) {
        return NSLocalizedString(@"MapBox", nil);
    }
    else {
        return NSLocalizedString(@"Apple Maps", nil);
    }
}

- (void)setMapSegments:(DZNMapViewControllerSupport)segments
{
    _mapSegments = segments;
    
    if (self.segmentedControl.numberOfSegments > 1) {
        self.navigationItem.titleView = self.segmentedControl;
    }
}

- (void)setMapProviders:(DZNMapViewControllerProvider)providers
{
    _mapProviders = providers;
    
    if (_mapProviders > 0) {
        UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showRoute:)];
        [self.navigationItem setRightBarButtonItem:exportButton];
    }
}


#pragma mark - DZNMapViewController methods

- (void)addAllAnnotations
{
    if (_locations.count == 0) {
        return;
    }
    
    for (int i = 0; i < _locations.count; i++) {
        
        DZNLocation *location = [_locations objectAtIndex:i];
        
        NSAssert([location isKindOfClass:[DZNLocation class]], @"Only DZNLocation class available.");
        
        DZNAnnotation *mapAnnotation = [[DZNAnnotation alloc] initWithTitle:location.title subtitle:location.subtitle andCoordinate:location.coordinate];
        mapAnnotation.location = location;
        
        [_mapView addAnnotation:mapAnnotation];
    }
    
    DZNAnnotation *firstAnnotation = [_mapView.annotations firstObject];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_mapView selectAnnotation:firstAnnotation animated:YES];
    });
    
    
    CLLocationDistance distance = 200000;
    MKCoordinateRegion region;
    
    if (_locations.count > 1) {
        region = [self regionForAnnotations:_mapView.annotations];
    }
    else {
        region = MKCoordinateRegionMakeWithDistance(firstAnnotation.coordinate, distance, distance);
    }
    
    [_mapView setRegion:region animated:NO];
}

- (MKCoordinateRegion)regionForAnnotations:(NSArray *)annotations {
    
    CLLocationDegrees minLat = 90.0;
    CLLocationDegrees maxLat = -90.0;
    CLLocationDegrees minLon = 180.0;
    CLLocationDegrees maxLon = -180.0;
    
    for (id <MKAnnotation> annotation in annotations) {
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
    
    MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake((maxLat - span.latitudeDelta / 2), maxLon - span.longitudeDelta / 2);
    
    return MKCoordinateRegionMake(center, span);
}

- (void)handleMapTap:(UITapGestureRecognizer *)gesture
{
    if (_canHideBars && gesture.state == UIGestureRecognizerStateEnded) {
        
        BOOL hidden = self.navigationController.navigationBarHidden;
        [[UIApplication sharedApplication] setStatusBarHidden:!hidden withAnimation:UIStatusBarAnimationSlide];
        [self.navigationController setNavigationBarHidden:!hidden animated:YES];
    }
}

- (void)selectedScopeButton:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    MKMapType mapType = MKMapTypeFromString([segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]);
    
    if (mapType == _currentMapType) {
        return;
    }
    else _currentMapType = mapType;
    
    [_mapView setMapType:_currentMapType];
}

- (void)shouldShowRouteFromProvider:(DZNMapViewControllerProvider)provider
{
    DZNAnnotation *annotation = [self.mapView.selectedAnnotations firstObject];
    CLLocationCoordinate2D coordinate = annotation.coordinate;
    CGFloat zoomLevel = _mapView.zoomLevel;
    NSString *_url;
    
    switch (provider) {
        case DZNMapViewControllerProviderApple:
            _url = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@&ll=%f,%f&z=%f", annotation.title, coordinate.latitude, coordinate.longitude, zoomLevel];
            break;
        case DZNMapViewControllerProviderGoogle:
            _url = [NSString stringWithFormat:@"comgooglemaps://?daddr=%@&center=%f,%f&zoom=%f", annotation.title, coordinate.latitude, coordinate.longitude, zoomLevel];
            break;
        case DZNMapViewControllerProviderWaze:
            _url = [NSString stringWithFormat:@"waze://?ll=%f,%f&z=%f&navigate=yes",coordinate.latitude,coordinate.longitude,zoomLevel];
            break;
        case DZNMapViewControllerProviderMapBox:
            _url = nil;
            break;
    }
    
    NSURL *URL = [NSURL URLWithString:[_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:URL];
}

- (void)showRoute:(id)sender
{
    NSArray *titles = [self actionSheetTitles];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.title = NSLocalizedString(@"Show route in...", nil);
    actionSheet.delegate = self;
    
    for (NSString *title in titles) {
        [actionSheet addButtonWithTitle:title];
    }
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    actionSheet.cancelButtonIndex = [titles count];
    
    [actionSheet showInView:self.mapView];
}


#pragma mark - MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    DZNAnnotation *_annotation = (DZNAnnotation *)annotation;
    
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:_annotation reuseIdentifier:annotationIdentifier];
    view.canShowCallout = _showCallout;
    view.pinColor = MKPinAnnotationColorRed;
    view.animatesDrop = YES;
    
    if (_annotation.location.image) {
        
        CGFloat width = 36.0;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        imageView.image = _annotation.location.image;
        imageView.layer.cornerRadius = width / 2.0;
        imageView.layer.masksToBounds = YES;
        
        view.leftCalloutAccessoryView = imageView;
    }
    
    if (_annotation.location.url.length > 0) {
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }
    
    return view;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(mapViewController:didTapLink:)]) {
        DZNAnnotation *annotation = (DZNAnnotation *)view.annotation;
        [self.delegate mapViewController:self didTapLink:annotation.location.url];
    }
    
    [view setSelected:NO animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    _canHideBars = NO;
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    _canHideBars = YES;
}

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    [self shouldShowRouteFromProvider:mapViewControllerProviderFromString(buttonTitle)];
}


#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer respondsToSelector:@selector(handleMapTap:)] && !_canHideBars) {
        return NO;
    }
    return YES;
}


#pragma mark - View lifeterm

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - View Auto-Rotation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


@end
