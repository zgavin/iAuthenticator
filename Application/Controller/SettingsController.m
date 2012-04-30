//
//  SettingsController.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "SettingsController.h"
#import "iAuthenticatorAppDelegate.h"
#import "Authenticator+Custom.h"
#import "AuthenticatorSettingsController.h"

@implementation SettingsController

- (void)viewWillAppear:(BOOL)animated {
	[self refresh];
	[table reloadData];
}

- (void) refresh {
	authenticators = [Authenticator findAllSortedBy:@"name" ascending:YES];
}

- (IBAction) createAuthenticator:(id)sender {
	[self.navigationController pushViewController:[[AuthenticatorSettingsController alloc] init] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [authenticators count];
}

static NSString *identifier = @"AuthenticatorCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = [self authenticatorForIndexPath:indexPath].name;
	cell.textLabel.backgroundColor = [UIColor clearColor];
		
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	AuthenticatorSettingsController *authenticator_controller = [[AuthenticatorSettingsController alloc] init];
	authenticator_controller.authenticator = [self authenticatorForIndexPath:indexPath];
	
	[self.navigationController pushViewController:authenticator_controller animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[self authenticatorForIndexPath:indexPath] deleteEntity];
		[[NSManagedObjectContext contextForCurrentThread] save];
		
		[self refresh];
		
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		[[NSNotificationCenter defaultCenter] postNotificationName:AUTHENTICATOR_UPDATE_NOTIFICATION object:self];
	}   
}

- (Authenticator*) authenticatorForIndexPath:(NSIndexPath*) indexPath {
	return [authenticators objectAtIndex:indexPath.row];
}

@end
