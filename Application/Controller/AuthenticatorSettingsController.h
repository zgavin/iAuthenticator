//
//  AuthenticatorController.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Region+Custom.h"



@class Authenticator;

@interface AuthenticatorSettingsController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField* nameTextField;
	IBOutlet UITextField* serialTextField;
	IBOutlet UITextField* keyTextField;
	IBOutlet UISegmentedControl* regionSegmentedControl;
	IBOutlet UIButton* syncButton;
	IBOutlet UIActivityIndicatorView* syncActivityIndicator;
	IBOutlet UIView* backgroundView;
	
	Authenticator* authenticator;
}

@property (nonatomic, retain) Authenticator *authenticator;

@end


