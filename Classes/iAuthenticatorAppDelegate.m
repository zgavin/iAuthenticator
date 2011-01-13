//
//  iAuthenticatorAppDelegate.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright Zachary Gavin 2011. All rights reserved.
//

#import "iAuthenticatorAppDelegate.h"
#import "Region.h"
#import "Authenticator.h"

@implementation iAuthenticatorAppDelegate

@synthesize window;
@synthesize tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
	
	[self loadData];
}

- (void) loadData {
	// create initial data if none exists
	NSManagedObjectContext *context = [self managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
	// run the query
	NSError *error;
	NSArray *fetchResults = [context executeFetchRequest:request error:&error];
	if (fetchResults == nil) {
		NSLog(@"There was an error!");
		// handle error
	}
	
	[request release];
	
	if ([fetchResults count] == 0)
	{
		Region *north_america = (Region*) [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:context];
		north_america.name = @"North America";
		
		Region *europe = (Region*) [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:context];
		europe.name = @"Europe";
		
		Authenticator *na_auth = (Authenticator*) [NSEntityDescription insertNewObjectForEntityForName:@"Authenticator" inManagedObjectContext:context];
		na_auth.name = @"North America Test";
		na_auth.serial = @"US-1000-1000-1000-1000";
		na_auth.key = @"WTFBBQ";
		na_auth.region = north_america;
		
		Authenticator *euro_auth = (Authenticator*) [NSEntityDescription insertNewObjectForEntityForName:@"Authenticator" inManagedObjectContext:context];
		euro_auth.name = @"Europe Test";
		euro_auth.serial = @"US-1000-1000-1000-1000";
		euro_auth.key = @"WTFBBQ";
		euro_auth.region = europe;
		
		NSError *error = nil;
		[context save:&error];
		if (error != nil) {
			NSLog(@"There was an error!");
			// handle error
		}
		
	}
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"iAuthenticator.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

