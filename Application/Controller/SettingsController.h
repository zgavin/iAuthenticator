//
//  SettingsController.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuthenticatorSettingsController;

@interface SettingsController : UIViewController <UITableViewDelegate, UITableViewDataSource > {
	IBOutlet UITableView * table;
	
	NSArray *authenticators;
}

@end
