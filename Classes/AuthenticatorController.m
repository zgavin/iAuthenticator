//
//  AuthenticatorController.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "AuthenticatorController.h"
#import "iAuthenticatorAppDelegate.h"
#import "Authenticator.h"
#import "FieldDescription.h"


@implementation AuthenticatorController

@synthesize authenticator;
@synthesize fieldLabels;
@synthesize tempValues, textFieldBeingEdited, detailMode, footerView;

-(NSManagedObjectContext*) managedObjectContext {
	iAuthenticatorAppDelegate *appDelegate = (iAuthenticatorAppDelegate*) [[UIApplication sharedApplication] delegate];
	return [appDelegate managedObjectContext];
}

-(NSManagedObjectModel*) managedObjectModel {
    iAuthenticatorAppDelegate *appDelegate =  (iAuthenticatorAppDelegate*) [[UIApplication sharedApplication] delegate];
    return [appDelegate managedObjectModel];
}

-(IBAction)cancel:(id)sender{
	[textFieldBeingEdited resignFirstResponder];
	
	[[authenticator managedObjectContext] rollback];
	
	([self.detailMode intValue] == kDetailModeAdd) ? [self dismissModalViewControllerAnimated:YES] : [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)save:(id)sender
{
	// close the keyboard
	[textFieldBeingEdited resignFirstResponder];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"AuthenticatorsChanged" object:self];
	
    if (textFieldBeingEdited != nil)
    {
        [tempValues setObject:textFieldBeingEdited.text forKey: [fields objectAtIndex:textFieldBeingEdited.tag]];
    }
	
	
	for (FieldDescription *field in [tempValues allKeys])
    {
		
		SEL selector = NSSelectorFromString([NSString stringWithFormat:@"setValueFor%@:",NSStringFromClass(field.klass)]);

		[self performSelector:selector withObject:field];
    }
	
	// save the object to CoreData
	NSManagedObjectContext *context = [authenticator managedObjectContext];
	
	NSError *error = nil;
	[context save:&error];
	if (error != nil) {
		NSLog(@"There was an error!");
		// handle error
	}
	
	[[self nextResponder] resignFirstResponder];
	
	
	([self.detailMode intValue] == kDetailModeAdd) ? [self dismissModalViewControllerAnimated:YES] : [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)textFieldDone:(id)sender {
	[sender resignFirstResponder];
}

- (IBAction)buttonPressed:(id)sender {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"This will remove all your history for \"%@\"", authenticator.name] message:@"Are you sure you want to continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    CGAffineTransform myTransform = CGAffineTransformMakeTranslation(0.0, 130.0);
    [myAlertView setTransform:myTransform];
    
    [myAlertView show];
    [myAlertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // if clicked OK
    if (buttonIndex == 1) {
        // copy attributes
        Authenticator *new_authenticator = (Authenticator*) [NSEntityDescription insertNewObjectForEntityForName:@"Authenticator" inManagedObjectContext:self.managedObjectContext];
        new_authenticator.name = authenticator.name;
        new_authenticator.key = authenticator.key;
        new_authenticator.serial = authenticator.serial;
        new_authenticator.region = authenticator.region;
		
        // delete
        [self.managedObjectContext deleteObject:authenticator];
        
        // save
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved Core Data Save error %@, %@", error, [error userInfo]);
            exit(-1);
        }
		
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -

- (void)viewDidLoad {
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:[self managedObjectContext]];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
	
	NSError *error;
	regions = [[self managedObjectContext] executeFetchRequest:request error:&error];
	[regions retain];
	NSMutableArray * region_names = [NSMutableArray arrayWithCapacity:0];
	
	for (Region* region in regions) {
		[region_names insertObject:[region name] atIndex:region_names.count];
	}
	
    fields = [[NSArray alloc] initWithObjects:
				[[FieldDescription alloc] initWithField:@"name" label:@"Name" klass:[UITextField class] data:[NSNumber numberWithInt:16] frame:CGRectMake(10, 12, 280, 25)],
				[[FieldDescription alloc] initWithField:@"serial" label:@"Serial" klass:[UITextField class] data:[NSNumber numberWithInt:16] frame:CGRectMake(10, 12, 280, 25)],
				[[FieldDescription alloc] initWithField:@"key" label:@"Key" klass:[UITextField class] data:[NSNumber numberWithInt:13] frame:CGRectMake(10, 13, 280, 25)],
				[[FieldDescription alloc] initWithField:@"region" label:@"Region" klass:[UISegmentedControl class] data:region_names frame:CGRectMake(0, 0, 300, 45)],
				nil
			 ];
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save" 
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	self.tempValues = dict;
	[dict release];
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
	
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UILabel *label = [[UILabel alloc] init];
	label.textAlignment = UITextAlignmentLeft;
	label.font = [UIFont boldSystemFontOfSize:18];
	label.text = [NSString stringWithFormat:@"  %@",((FieldDescription*) [fields objectAtIndex:section]).label];
	label.backgroundColor = [UIColor clearColor];
	label.frame = CGRectMake(20, 0, 200, 24);
	
	return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 24.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if(section != [self numberOfSectionsInTableView:tableView]-1) {
		return nil;
	}
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(60, 5, 200, 25)];
	
	UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(60, 20, 200, 25);
	
	NSString *title;
	SEL selector;
	if(!authenticator.key || authenticator.key.length == 0 || !authenticator.serial || authenticator.serial.length == 0 ) {
		title = @"Request from Blizzard";
		selector = @selector(enroll:);
	} else {
		title = @"Sync with Blizzard";
		selector = @selector(sync:);
	}
	[button setTitle:title forState:UIControlStateNormal];
	[button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:button];
				
	return view;
}

- (IBAction) enroll:(id) sender {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticatorEnrolled:) name:@"AuthenticatorEnrolled" object:authenticator];
	NSLog(@"%@", tempValues);
	[self setValueForUISegmentedControl:[fields objectAtIndex:fields.count-1]];
	[authenticator enroll];
	
	UIButton * button = (UIButton*) sender;
	
	[button setTitle:@"Sync with Blizzard" forState:UIControlStateNormal];
	[button removeTarget:self action:@selector(enroll:) forControlEvents:UIControlEventTouchUpInside];
	[button addTarget:self action:@selector(sync:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)authenticatorEnrolled:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver: self name:@"AuthenticatorEnrolled" object:authenticator];
	[self.tableView reloadData];
}

- (IBAction) sync:(id) sender {
	[authenticator.region sync];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return section == [self numberOfSectionsInTableView:tableView]-1 ? 45.0:0.0;
}


- (UITextField*) setupUITextField:(FieldDescription*) field {
	UITextField* textField = [[UITextField alloc] initWithFrame:field.frame];
	textField.clearsOnBeginEditing = NO;
	textField.textAlignment = UITextAlignmentCenter;
	[textField setDelegate:self];
	[textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	return textField;
}
						


- (void) updateUITextField:(FieldDescription*) field with:(UITextField*) textField {
	if ([[tempValues allKeys] containsObject:field]) {
		textField.text = [tempValues objectForKey:field];
	} else {
		SEL selector = NSSelectorFromString(field.field);
		textField.text = [authenticator performSelector:selector] ;
	}
	textField.font	= [UIFont systemFontOfSize:[(NSNumber*) field.data intValue]];
	
}
											 
- (void) setValueForUITextField:(FieldDescription*) field {
	
	SEL selector = NSSelectorFromString([field setterField]);
	[authenticator performSelector:selector withObject:[tempValues objectForKey:field]];

}

- (UISegmentedControl*) setupUISegmentedControl:(FieldDescription*) field {
	UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:(NSArray*)field.data];
	segmentedControl.frame = field.frame;
	[segmentedControl addTarget:self action:@selector(segmentedControllValueChanged:) forControlEvents:UIControlEventValueChanged];
	return segmentedControl;
}

- (void) updateUISegmentedControl:(FieldDescription*) field with:(UISegmentedControl*) segmentedControl {
	for (int i=0; i < segmentedControl.numberOfSegments;i++) {
		if ([[authenticator.region name] isEqualToString:[segmentedControl titleForSegmentAtIndex:i]]) {
			[segmentedControl setSelectedSegmentIndex:i];
		}
	}
}
	 
- (void) setValueForUISegmentedControl:(FieldDescription*) field {
	NSString * region_name = [tempValues objectForKey:field];
	NSLog(@"%@",tempValues);
	NSLog(@"%@",field);
	for (Region* region in regions) {
		if ([[region name] isEqualToString:region_name]) {
			authenticator.region = region;
		}
	}
	
}	 


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger section = [indexPath section];
	
	NSString *identifier = [NSString stringWithFormat:@"%d",section];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		FieldDescription * field = (FieldDescription*) [fields objectAtIndex:section];
		SEL selector = NSSelectorFromString([NSString stringWithFormat:@"setup%@:",NSStringFromClass(field.klass)]);
		UIControl *control = (UIControl*)[self performSelector:selector withObject:field];
		[cell.contentView addSubview:control];
    }
	
	UIControl * control = (UIControl*) [cell.contentView.subviews objectAtIndex:0];
	control.tag = section;
	FieldDescription * field = (FieldDescription*) [fields objectAtIndex:section];
	SEL selector = NSSelectorFromString([NSString stringWithFormat:@"update%@:with:",NSStringFromClass(field.klass)]);
	[self performSelector:selector withObject:field withObject:control];
	
	
	if (textFieldBeingEdited == control) textFieldBeingEdited = nil;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (void)dealloc {
	[authenticator release];
	[tempValues release];
	[textFieldBeingEdited release];
	[detailMode release];
	[fields release];
	
    [super dealloc];
}

#pragma mark Text Field Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textFieldBeingEdited = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [tempValues setObject:textField.text forKey:(FieldDescription*) [fields objectAtIndex:textField.tag]];
}

- (IBAction) segmentedControllValueChanged:(id)sender {
	UISegmentedControl* control = (UISegmentedControl*) sender;
	FieldDescription * field = [fields objectAtIndex:control.tag];
	NSString * region_name = [control titleForSegmentAtIndex:control.selectedSegmentIndex];
	if (![[authenticator.region name] isEqualToString:region_name]) {
		[tempValues setObject:region_name forKey:field];
	}
	
}





@end
