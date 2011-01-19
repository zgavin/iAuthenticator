//
//  SettingsNavController.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "SettingsNavController.h"
#import "iAuthenticatorAppDelegate.h"
#import "Authenticator.h"
#import "AuthenticatorController.h"



@implementation SettingsNavController

-(IBAction) addButtonPressed: (id) event	{
	// set up authenticator detail controller
	AuthenticatorController *controller = [[AuthenticatorController alloc] initWithNibName:@"AuthenticatorController" bundle:nil];
	
	// create a new authenticator in the context
	Authenticator *authenticator = (Authenticator*) [NSEntityDescription insertNewObjectForEntityForName:@"Authenticator" inManagedObjectContext:managedObjectContext];
	authenticator.name = @"";
	authenticator.serial = @"";
	authenticator.key = @"";
	iAuthenticatorAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
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
	Region *region = [fetchResults objectAtIndex:0];
	authenticator.region = region;
	
	// set up the controller from the authenticator
	controller.title = [authenticator valueForKey:@"name"];
	controller.authenticator = authenticator;
	controller.detailMode = [[NSNumber alloc] initWithInt:kDetailModeAdd];
	
	// create an empty nav controller so that the bounds of the "add" are correct
	UINavigationController *cntrol = [[UINavigationController alloc] initWithRootViewController:controller];
	
	// and show it modally
	[self presentModalViewController:cntrol animated:YES];
	[cntrol release];
}


/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	iAuthenticatorAppDelegate *appDelegate = (iAuthenticatorAppDelegate *)[[UIApplication sharedApplication] delegate];
	managedObjectContext = appDelegate.managedObjectContext;
	
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end