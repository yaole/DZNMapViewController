//
//  ViewController.m
//  Sample
//
//  Created by Ignacio on 4/22/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "ViewController.h"
#import "DZNMapViewController.h"


typedef NS_ENUM(NSInteger, ViewControllerMapMode) {
    ViewControllerMapModeSingle,
    ViewControllerMapModeSingleDetailed,
    ViewControllerMapModeMultipleDetailed
};

static NSString *cellIdentifier = @"Cell";

@interface ViewController ()
@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"DZNMapViewController";
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
            DZNLocation *location = [[DZNLocation alloc] initWithTitle:@"Somewhere" latitude:37.49 longitude:122.25];
            
            controller = [[DZNMapViewController alloc] initWithLocation:location];
            controller.title = @"Location";
        }
            break;
            
        default:
            return nil;
            break;
    }
    
    
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
    return 1;
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
