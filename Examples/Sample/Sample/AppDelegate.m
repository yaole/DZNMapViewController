//
//  AppDelegate.m
//  Sample
//
//  Created by Ignacio on 4/22/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
