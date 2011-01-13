//
//  TokenView.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/13/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Authenticator.h"


@interface TokenView : UIView{
	Authenticator *authenticator;
	NSTimer *progressTimer;
	NSTimer *tokenTimer;
	NSArray *codes;
	IBOutlet UILabel *name;
	IBOutlet UILabel *code1;
	IBOutlet UILabel *code2;
	IBOutlet UILabel *code3;
	IBOutlet UILabel *code4;
	IBOutlet UILabel *code5;
	IBOutlet UIProgressView *progressView;
	IBOutlet UIView *contentView;
}


@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *code1;
@property (nonatomic, retain) IBOutlet UILabel *code2;
@property (nonatomic, retain) IBOutlet UILabel *code3;
@property (nonatomic, retain) IBOutlet UILabel *code4;
@property (nonatomic, retain) IBOutlet UILabel *code5;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) Authenticator *authenticator;

-(id) initWithoutAuthenticator;
-(id) initWithAuthenticator:(Authenticator*) inAuthenticator;
-(void) updateTokens;
-(void) updateProgress;
-(void) startTimers;
-(void) stopTimers;

@end
