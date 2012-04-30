//
//  iAuthenticatorAppDelegate.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright Zachary Gavin 2011. All rights reserved.
//

#import "iAuthenticatorAppDelegate.h"
#import "Region+Custom.h"
#import "Authenticator.h"

@implementation iAuthenticatorAppDelegate

@synthesize window;

- (void) awakeFromNib {
	[MagicalRecordHelpers setupAutoMigratingCoreDataStack];
}

- (void) applicationDidFinishLaunching:(UIApplication *)application {
	[Region initializeRegions];
	[window addSubview:tabController.view];
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
	
}


@end

