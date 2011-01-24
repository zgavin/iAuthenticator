//
//  AuthenticatorController.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Region.h"
#define kLabelTag                    4096
#define kSwitchTag					 4097

#define kDetailModeEdit			0
#define kDetailModeAdd			1


@class Authenticator;




@interface AuthenticatorController : UITableViewController <UITextFieldDelegate> {
	Authenticator *authenticator;
	NSMutableDictionary *tempValues;
	UITextField *textFieldBeingEdited;
	NSNumber *detailMode;
    UIView *footerView;
	NSArray * fields;
	NSArray * regions;
	
}



@property (nonatomic, retain) Authenticator *authenticator;
@property (nonatomic, retain) NSArray *fieldLabels;
@property (nonatomic, retain) NSMutableDictionary *tempValues;
@property (nonatomic, retain) UITextField *textFieldBeingEdited;
@property (nonatomic, retain) NSNumber *detailMode;
@property (nonatomic, retain) UIView *footerView;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)textFieldDone:(id)sender;
- (IBAction)buttonPressed:(id)sender;

-(NSManagedObjectContext*) managedObjectContext;
-(NSManagedObjectModel*) managedObjectModel;

@end


