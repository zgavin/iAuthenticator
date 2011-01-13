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

@implementation AuthenticatorController

@synthesize authenticator;
@synthesize fieldLabels;
@synthesize tempValues, textFieldBeingEdited, detailMode, footerView;

-(NSManagedObjectContext*) managedObjectContext {
	iAuthenticatorAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	return [appDelegate managedObjectContext];
}

-(NSManagedObjectModel*) managedObjectModel {
    iAuthenticatorAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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
        NSNumber *tagAsNum= [[NSNumber alloc]  initWithInt:textFieldBeingEdited.tag];
        [tempValues setObject:textFieldBeingEdited.text forKey: tagAsNum];
        [tagAsNum release];
        
    }
	
	
	for (NSNumber *key in [tempValues allKeys])
    {
        switch ([key intValue]) {
            case kNameRowIndex:
                authenticator.name = [tempValues objectForKey:key];
                break;
            case kSerialRowIndex:
                authenticator.serial = [tempValues objectForKey:key];
                break;
            case kKeyRowIndex:
				authenticator.key = [tempValues objectForKey:key];
                break;
            default:
                break;
        }
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
	
    //NSArray *allControllers = self.navigationController.viewControllers;
    //SettingsTableViewController *parent = (SettingsTableViewController*) [allControllers lastObject];
    //[parent loadDataFromDB];
    //[parent.tableView reloadData];
	
	([self.detailMode intValue] == kDetailModeAdd) ? [self dismissModalViewControllerAnimated:YES] : [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)textFieldDone:(id)sender {
    UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    UITableView *table = (UITableView *)[cell superview];
    NSIndexPath *textFieldIndexPath = [table indexPathForCell:cell];
    NSUInteger row = [textFieldIndexPath row];
    row++;
    if (row >= kNumberOfEditableRows)
        row = 0;

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
    NSArray *array = [[NSArray alloc] initWithObjects:@"Name", @"Serial", @"Key", nil];
    self.fieldLabels = array;
    [array release];
    
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
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfEditableRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier;
    
    NSUInteger row = [indexPath row];
	
	switch (row) {
		case kNameRowIndex:
			identifier = @"TextCellIdentifier";
			break;
		case kSerialRowIndex:
			identifier = @"EnableCellIdentifier";
			break;
		case kKeyRowIndex:
			identifier = @"GoodBadCellIdentifier";
			break;
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
    if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		// set up the label
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 25)];
		label.textAlignment = UITextAlignmentLeft;
		label.tag = kLabelTag;
		label.font = [UIFont boldSystemFontOfSize:14];
		[cell.contentView addSubview:label];
		[label release];
		
		// set up the text field
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(90, 12, 200, 25)];
		textField.clearsOnBeginEditing = NO;
		[textField setDelegate:self];
		[textField addTarget:self action:@selector(textFieldDone:) 
			forControlEvents:UIControlEventEditingDidEndOnExit];
		[cell.contentView addSubview:textField];
		
    }
	// populate controls
    UILabel *label = (UILabel *)[cell viewWithTag:kLabelTag];
    UITextField *textField = nil;
    for (UIView *oneView in cell.contentView.subviews)
    {
        if ([oneView isMemberOfClass:[UITextField class]])
            textField = (UITextField *)oneView;
    }
    label.text = [fieldLabels objectAtIndex:row];
    NSNumber *rowAsNum = [[NSNumber alloc] initWithInt:row];
	
    switch (row) {
        case kNameRowIndex:
            if ([[tempValues allKeys] containsObject:rowAsNum])
                textField.text = [tempValues objectForKey:rowAsNum];
            else
                textField.text = authenticator.name;
            break;
			
		case kSerialRowIndex:
			if ([[tempValues allKeys] containsObject:rowAsNum])
                textField.text = [tempValues objectForKey:rowAsNum];
            else
                textField.text = authenticator.serial;
			break;
		case kKeyRowIndex:
			if ([[tempValues allKeys] containsObject:rowAsNum])
                textField.text = [tempValues objectForKey:rowAsNum];
            else
				
                textField.text = authenticator.key;
			break;
        default:
            break;
    }
    if (textFieldBeingEdited == textField)
        textFieldBeingEdited = nil;
	
    textField.tag = row;
    [rowAsNum release];
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (void)dealloc {
	[authenticator release];
	[fieldLabels release];
	[tempValues release];
	[textFieldBeingEdited release];
	[detailMode release];
	
    [super dealloc];
}

#pragma mark Text Field Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textFieldBeingEdited = textField;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSNumber *tagAsNum = [[NSNumber alloc] initWithInt:textField.tag];
    [tempValues setObject:textField.text forKey:tagAsNum];
    [tagAsNum release];
}





@end
