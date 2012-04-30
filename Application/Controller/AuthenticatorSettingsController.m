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

@implementation AuthenticatorSettingsController

@synthesize authenticator;

- (void) viewDidLoad {
	CALayer* layer = backgroundView.layer;
	layer.cornerRadius = 15;
	layer.borderWidth = 1;
	layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.4 alpha:1].CGColor;
	
	if (self.authenticator) { [self refresh]; }
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];	
}

- (void) viewWillDisappear:(BOOL)animated {
	if(self.authenticator && !self.authenticator.objectID.persistentStore) { [self.authenticator deleteEntity]; }
}

- (void) setAuthenticator:(Authenticator *) _authenticator {
	authenticator = _authenticator;
	if (self.isViewLoaded) {
		[self refresh];
	}
}

- (void) refresh {
	nameTextField.text = authenticator.name;
	serialTextField.text = authenticator.serial;
	keyTextField.text = authenticator.key;
	regionSegmentedControl.selectedSegmentIndex = (authenticator.region == [Region northAmerica]  ? 0 : 1);
	regionSegmentedControl.enabled = NO;
	[syncButton setTitle:SYNC_TEXT forState:UIControlStateNormal];
	
	self.title = authenticator.name;
}


- (void) save {
	Authenticator* _authenticator = self.authenticator ?: [Authenticator createEntity];
	
	_authenticator.name = nameTextField.text;
	_authenticator.serial = serialTextField.text;
	_authenticator.key = keyTextField.text;
	
	[[NSManagedObjectContext contextForCurrentThread] save];
	[[NSNotificationCenter defaultCenter] postNotificationName:AUTHENTICATOR_UPDATE_NOTIFICATION object:self];
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (void) cancel {
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
