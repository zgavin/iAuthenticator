//
//  AuthenticatorController.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "AuthenticatorSettingsController.h"
#import "Authenticator+Custom.h"
#import <QuartzCore/QuartzCore.h>

NSString* const SYNC_TEXT = @"Sync Authenticator";
NSString* const REQUEST_TEXT = @"Request From Blizzard";

@implementation AuthenticatorSettingsController

@synthesize authenticator;

- (void) viewDidLoad {
	CALayer* layer = backgroundView.layer;
	layer.cornerRadius = 15;
	layer.borderWidth = 1;
	layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.4 alpha:1].CGColor;
	
	
	keyTextField.adjustsFontSizeToFitWidth = YES;
	keyTextField.minimumFontSize = 6;
}

- (void) viewWillAppear:(BOOL)animated {
	[self refresh];
}

- (void) viewWillDisappear:(BOOL)animated {
	if(self.authenticator && !self.authenticator.objectID.persistentStore) {
		[self.authenticator deleteEntity];
	}
}

- (void) setAuthenticator:(Authenticator *) _authenticator {
	authenticator = _authenticator;
	if (self.isViewLoaded) {
		[self refresh];
	}
}

- (void) refresh {
	if(authenticator) {
		[@{@"name":nameTextField,@"serial":serialTextField,@"key":keyTextField} enumerateKeysAndObjectsUsingBlock:^(NSString* key,UITextField* field, BOOL* stop) {
			field.text = [authenticator valueForKey:key];
		}];
			
		regionSegmentedControl.selectedSegmentIndex = (authenticator.region == [Region northAmerica]  ? 0 : 1);
		regionSegmentedControl.enabled = NO;
		
		[syncButton setTitle:SYNC_TEXT forState:UIControlStateNormal];
		
		self.title = authenticator.name;
	} else {
		[@[nameTextField,serialTextField,keyTextField] enumerateObjectsUsingBlock:^(UITextField* field,NSUInteger idx,BOOL * stop) {
			field.text = @"";
		}];
		
		regionSegmentedControl.enabled = YES;
		
		self.title = @"New Authenticator";
		
		[syncButton setTitle:REQUEST_TEXT forState:UIControlStateNormal];
	}
}


- (IBAction) save {
	Authenticator* _authenticator = self.authenticator ?: [Authenticator createEntity];
	
	_authenticator.name = nameTextField.text;
	_authenticator.serial = serialTextField.text;
	_authenticator.key = keyTextField.text;
	
	[[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:AUTHENTICATOR_UPDATE_NOTIFICATION object:self];
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction) cancel {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) syncPressed:(id)sender {
	[syncActivityIndicator startAnimating];
	syncButton.enabled = NO;
	if(self.authenticator) {
		[self.authenticator.region syncWithCompletionBlock:^{
			[syncActivityIndicator stopAnimating];
			syncButton.enabled = YES;
		}];
	} else {
		Authenticator* _authenticator = [Authenticator createEntity];
		_authenticator.region = regionSegmentedControl.selectedSegmentIndex == 0 ? [Region northAmerica] : [Region europe];
		_authenticator.name = nameTextField.text;
		self.authenticator = _authenticator;
		[_authenticator enrollWithCompletionBlock:^(){
			[self refresh];
			[syncActivityIndicator stopAnimating];
			syncButton.enabled = YES;
		}];
	}
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

@end
