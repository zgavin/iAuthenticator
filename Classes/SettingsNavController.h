//
//  SettingsNavController.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface SettingsNavController : UINavigationController {
	NSManagedObjectContext *managedObjectContext;
}

-(IBAction) addButtonPressed: (id) event;

@end

