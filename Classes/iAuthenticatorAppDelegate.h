//
//  iAuthenticatorAppDelegate.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright Zachary Gavin 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokenController.h"

@interface iAuthenticatorAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
	UIWindow *window;
    UITabBarController *tabBarController;	
	TokenController *tokenController;

}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet TokenController * tokenController;

- (void) loadData;
- (NSString *)applicationDocumentsDirectory;

@end
