//
//  AppDelegate.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright Zachary Gavin 2011. All rights reserved.
//

#import "AppDelegate.h"
#import "Region+Custom.h"
#import "Authenticator.h"
#import "CoreData+MagicalRecord.h"
#import "MagicalRecord.h"

@implementation AppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[MagicalRecord setupAutoMigratingCoreDataStack];
	[Region initializeRegions];

	return YES;
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
	
}


@end

