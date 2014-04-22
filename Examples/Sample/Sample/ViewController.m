//
//  ViewController.m
//  Sample
//
//  Created by Ignacio on 4/22/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "ViewController.h"

typedef NS_ENUM(NSInteger, ViewControllerMapMode) {
    ViewControllerMapModeSingle,
    ViewControllerMapModeSingleDetailed,
    ViewControllerMapModeMultipleDetailed
};

static NSString *cellIdentifier = @"Cell";

@interface ViewController ()
@end

@implementation ViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Choose an option";
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (DZNMapViewController *)mapViewControllerforMode:(ViewControllerMapMode)mode
{
    DZNMapViewController *controller = nil;
    
    switch (mode) {
        case ViewControllerMapModeSingle:
        {
            controller = [[DZNMapViewController alloc] initWithLatitude:49.2802 longitude:-123.1182];
        }
            break;
        case ViewControllerMapModeSingleDetailed:
        {
            DZNLocation *location = [[DZNLocation alloc] initWithTitle:@"Vancouver" subtitle:@"The city of glass" latitude:49.2802 longitude:-123.1182];
            controller = [[DZNMapViewController alloc] initWithLocation:location];
        }
            break;
            
        case ViewControllerMapModeMultipleDetailed:
        {
            DZNLocation *denver = [[DZNLocation alloc] initWithTitle:@"Denver" subtitle:@"The city of performing arts" latitude:39.75 longitude:-105];
            denver.image = [UIImage imageNamed:@"thumb_denver"];
            denver.url = @"epc://show/120";
            
            DZNLocation *sanFrancisco = [[DZNLocation alloc] initWithTitle:@"San Francisco" subtitle:@"The city of lights" latitude:37.75 longitude:-122.5];
            sanFrancisco.image = [UIImage imageNamed:@"thumb_sanfrancisco"];
            sanFrancisco.url = @"epc://show/120";
            
            DZNLocation *newYork = [[DZNLocation alloc] initWithTitle:@"New York" subtitle:@"The city of dreams" latitude:40.71 longitude:-74.00];
            newYork.image = [UIImage imageNamed:@"thumb_newyork"];
            newYork.url = @"epc://show/120";
            
            controller = [[DZNMapViewController alloc] initWithLocations:@[denver, sanFrancisco, newYork]];
        }
            break;
            
        default:
            break;
    }
    
    controller.delegate = self;
    controller.title = @"DZNMapViewController";
    controller.mapSegments = DZNMapViewControllerSupportStandard|DZNMapViewControllerSupportHybrid;
    controller.mapProviders = DZNMapViewControllerProviderApple|DZNMapViewControllerProviderGoogle|DZNMapViewControllerProviderWaze;
    controller.showCallout = YES;
    controller.allowExport = YES;
    controller.showsUserLocation = YES;
    
    return controller;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0: cell.textLabel.text = @"Map w/ single location";
            break;
            
        case 1: cell.textLabel.text = @"Map w/ 1 detailed location";
            break;
            
        case 2: cell.textLabel.text = @"Map w/ many detailed locations";
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DZNMapViewController *controller = [self mapViewControllerforMode:indexPath.row];
    
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - DZNMapViewControllerDelegate Methods

- (void)mapViewController:(DZNMapViewController *)controller didTapLink:(NSString *)url
{
    NSLog(@"%s : %@",__FUNCTION__, url);
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
