//
//  SettingsController.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AuthenticatorController;

@interface SettingsController : UITableViewController <UITableViewDelegate, UITableViewDataSource > {
	NSMutableArray *authenticators;
	AuthenticatorController *authenticatorController;
}

@property (nonatomic, retain) NSMutableArray *authenticators;
@property (nonatomic, retain) AuthenticatorController *authenticatorController;

-(void) loadData;

@end
