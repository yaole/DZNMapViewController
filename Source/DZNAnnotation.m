//
//  DZNAnnotation.m
//  DZNMapViewController
//  https://github.com/dzenbot/DZNMapViewController
//
//  Created by Ignacio Romero Zurbuchen on 10/7/13.
//  Copyright (c) 2013 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "DZNAnnotation.h"

@implementation DZNAnnotation

- (id)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle andCoordinate:(CLLocationCoordinate2D)coordinate;
{
    self = [super init];
    if (self) {
        _title = title;
        _subtitle = subtitle;
        _coordinate = coordinate;
    }
	return self;
}

@end
