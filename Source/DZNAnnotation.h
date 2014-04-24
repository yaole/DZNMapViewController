//
//  DZNAnnotation.h
//  DZNMapViewController
//  https://github.com/dzenbot/DZNMapViewController
//
//  Created by Ignacio Romero Zurbuchen on 10/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "DZNLocation.h"

@interface DZNAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) DZNLocation *location;

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle andCoordinate:(CLLocationCoordinate2D)coordinate;

@end
