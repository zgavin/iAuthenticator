//
//  SettingsController.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "SettingsController.h"
#import "AppDelegate.h"
#import "Authenticator+Custom.h"
#import "AuthenticatorSettingsController.h"

@implementation SettingsController

- (void) viewDidLoad {
	[super viewDidLoad];
	
	[self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:30]} forState:UIControlStateNormal];
	
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	}
	
	[self refresh];
	[table reloadData];
}

- (void) refresh {
	authenticators = [Authenticator findAllSortedBy:@"name" ascending:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [authenticators count];
}

- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"AuthenticatorCell"];
	
	cell.textLabel.text = [self authenticatorForIndexPath:indexPath].name;
			
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[self authenticatorForIndexPath:indexPath] deleteEntity];
		[[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
		
		[self refresh];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		[[NSNotificationCenter defaultCenter] postNotificationName:AUTHENTICATOR_UPDATE_NOTIFICATION object:self];
	}
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	((AuthenticatorSettingsController*) segue.destinationViewController).authenticator = [segue.identifier isEqualToString:@"new"] ? nil : [self authenticatorForIndexPath:[table indexPathForCell:sender]];
}

- (Authenticator*) authenticatorForIndexPath:(NSIndexPath*) indexPath {
	return [authenticators objectAtIndex:indexPath.row];
}

@end
