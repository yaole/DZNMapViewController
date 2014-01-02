//
//  DZMapViewController.m
//  DZMapViewController
//
//  Created by Ignacio on 10/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//

#import "DZMapViewController.h"
#import "DZMapAnnotation.h"

static NSString *annotationIdentifier = @"DZMapAnnotation";

@interface DZMapViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) BOOL canHideBars;
@end

@implementation DZMapViewController

- (instancetype)initWithLocation:(CLLocation *)location
{
    self = [super init];
    if (self) {
        _location = location;
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_location) {
        DZMapAnnotation *mapAnnotation = [[DZMapAnnotation alloc] initWithTitle:self.title subtitle:nil andCoordinate:_location.coordinate];
        [_mapView addAnnotation:mapAnnotation];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_mapView selectAnnotation:mapAnnotation animated:YES];
        });
        
        CLLocationDistance distance = 200000;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(mapAnnotation.coordinate, distance, distance);
        [_mapView setRegion:region animated:NO];
    }
    
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
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.rotateEnabled = YES;
        _mapView.pitchEnabled = YES;
        _mapView.showsPointsOfInterest = NO;
        _mapView.showsBuildings = NO;
        _mapView.showsUserLocation = NO;
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
    if ((_mapSegments & DZMapViewControllerSegmentStandard) > 0) {
        [titles addObject:NSStringFromMapType(MKMapTypeStandard)];
    }
    if ((_mapSegments & DZMapViewControllerSegmentSatellite) > 0) {
        [titles addObject:NSStringFromMapType(MKMapTypeSatellite)];
    }
    if ((_mapSegments & DZMapViewControllerSegmentHybrid) > 0) {
        [titles addObject:NSStringFromMapType(MKMapTypeHybrid)];
    }
    return titles;
}

- (NSArray *)actionSheetTitles
{
    NSMutableArray *titles = [NSMutableArray array];
    if ((_mapProviders & DZMapViewControllerProviderApple) > 0) {
        [titles addObject:NSStringFromDZMapViewControllerProvider(DZMapViewControllerProviderApple)];
    }
    if ((_mapProviders & DZMapViewControllerProviderGoogle) > 0 && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        [titles addObject:NSStringFromDZMapViewControllerProvider(DZMapViewControllerProviderGoogle)];
    }
    if ((_mapProviders & DZMapViewControllerProviderWaze) > 0 && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"waze://"]]) {
        [titles addObject:NSStringFromDZMapViewControllerProvider(DZMapViewControllerProviderWaze)];
    }
    if ((_mapProviders & DZMapViewControllerProviderMapBox) > 0 && [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mapbox://"]]) {
        [titles addObject:NSStringFromDZMapViewControllerProvider(DZMapViewControllerProviderMapBox)];
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

DZMapViewControllerProvider mapViewControllerProviderFromString(NSString *string)
{
    if ([string isEqualToString:NSStringFromDZMapViewControllerProvider(DZMapViewControllerProviderGoogle)]) {
        return DZMapViewControllerProviderGoogle;
    }
    else if ([string isEqualToString:NSStringFromDZMapViewControllerProvider(DZMapViewControllerProviderWaze)]) {
        return DZMapViewControllerProviderWaze;
    }
    else if ([string isEqualToString:NSStringFromDZMapViewControllerProvider(DZMapViewControllerProviderMapBox)]) {
        return DZMapViewControllerProviderMapBox;
    }
    else {
        return DZMapViewControllerProviderApple;
    }
}

NSString *NSStringFromDZMapViewControllerProvider(DZMapViewControllerProvider provider)
{
    if ((provider & DZMapViewControllerProviderGoogle) > 0) {
        return NSLocalizedString(@"Google Maps", nil);
    }
    else if ((provider & DZMapViewControllerProviderWaze) > 0) {
        return NSLocalizedString(@"Waze", nil);
    }
    else if ((provider & DZMapViewControllerProviderMapBox) > 0) {
        return NSLocalizedString(@"MapBox", nil);
    }
    else {
        return NSLocalizedString(@"Apple Maps", nil);
    }
}

- (void)setMapSegments:(DZMapViewControllerSegment)segments
{
    _mapSegments = segments;
    
    if (_mapSegments > 0) {
        self.navigationItem.titleView = [self segmentedControl];
    }
}

- (void)setMapProviders:(DZMapViewControllerProvider)providers
{
    _mapProviders = providers;
    
    if (_mapProviders > 0) {
        UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showRoute:)];
        [self.navigationItem setRightBarButtonItem:exportButton];
    }
}


#pragma mark - EPCMapViewController methods

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
    
    if (_currentMapType == mapType) {
        return;
    }
    else _currentMapType = mapType;
    
    [_mapView setMapType:_currentMapType];
}

- (void)shouldShowRouteFromProvider:(DZMapViewControllerProvider)provider
{
    CLLocationCoordinate2D coordinate = _location.coordinate;
    CGFloat zoomLevel = _mapView.zoomLevel;
    NSString *_url;
    
    switch (provider) {
        case DZMapViewControllerProviderApple:
            _url = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@&ll=%f,%f&z=%f",self.title, coordinate.latitude,coordinate.longitude,zoomLevel];
            break;
        case DZMapViewControllerProviderGoogle:
            _url = [NSString stringWithFormat:@"comgooglemaps://?daddr=%@&center=%f,%f&zoom=%f",self.title,coordinate.latitude,coordinate.longitude,zoomLevel];
            break;
        case DZMapViewControllerProviderWaze:
            _url = [NSString stringWithFormat:@"waze://?ll=%f,%f&z=%f&navigate=yes",coordinate.latitude,coordinate.longitude,zoomLevel];
            break;
        case DZMapViewControllerProviderMapBox:
            _url = nil;
            break;
    }
    
    NSURL *URL = [NSURL URLWithString:[_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:URL];
}

- (void)showRoute:(id)sender
{
    NSArray *titles = [self actionSheetTitles];
    
    UIActionSheet *sheet = [UIActionSheet actionSheetWithTitle:NSLocalizedString(@"Show route in...", nil)
                                                  buttonTitles:titles
                                                     showInView:self.view
                                                     onDismiss:^(int buttonIndex, NSString *buttonTitle){
                                                         [self shouldShowRouteFromProvider:mapViewControllerProviderFromString(buttonTitle)];
                                                     }];
    
    [EPCAppearance customizeActionSheet:sheet];
}


#pragma mark - MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView *locationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
    locationView.canShowCallout = _showCallout;
    locationView.pinColor = MKPinAnnotationColorRed;
    locationView.animatesDrop = YES;
    
    return locationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views lastObject];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [mapView selectAnnotation:annotationView.annotation animated:YES];
    });
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{

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
    [[EPCClientManager sharedManager] startNetworkActivity];
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    [[EPCClientManager sharedManager] stopNetworkActivity];
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    [[EPCClientManager sharedManager] stopNetworkActivity];
}


#pragma mark - UIGestureRecognizerDelegate Methods

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer respondsToSelector:@selector(handleMapTap:)] && !_canHideBars) {
        return NO;
    }
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//        NSLog(@"\n%s\n gestureRecognizer : %@\notherGestureRecognizer : %@",__FUNCTION__, gestureRecognizer, otherGestureRecognizer);
//        UITapGestureRecognizer *otherTapGestureRecognizer = (UITapGestureRecognizer *)otherGestureRecognizer;
//        if ([gestureRecognizer respondsToSelector:@selector(handleMapTap:)] && otherTapGestureRecognizer.numberOfTapsRequired == 1) {
//            return YES;
//        }
//        else return NO;
//    }
//    
//    return NO;
//}


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
