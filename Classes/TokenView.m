//
//  TokenView.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/13/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "TokenView.h"


@implementation TokenView

@synthesize name;
@synthesize code1;
@synthesize code2;
@synthesize code3;
@synthesize code4;
@synthesize code5;
@synthesize progressView;
@synthesize contentView;


- (id)initWithoutAuthenticator {
	if(self = [super init]) {
        [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) 
                                      owner: self
                                    options: nil];
        // do extra loading here
        [self addSubview: contentView];
		
    }
	
	name.text = @"No Authenticators";
	code1.text = @"Add some authenticators";
	code2.text = @"";
	code3.text = @"";
	code4.text = @"";
	code5.text = @"";
	
	return self;
}

- (id)initWithAuthenticator:(Authenticator*) inAuthenticator {
    if(self = [super init]) {
        [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) 
                                      owner: self
                                    options: nil];
        // do extra loading here
        [self addSubview: contentView];
		
    }
	
	self.authenticator = inAuthenticator;
	self.name.text = authenticator.name;
	
	codes = [NSMutableArray arrayWithObjects:code1,code2,code3,code4,code5,nil];
	
	return self;
}

- (void) didMoveToSuperview {
	if(authenticator) {
		[self updateProgress];
		[self updateTokens];
	}
	[self resignFirstResponder];
}


- (void) startTimers {
	if (progressTimer == nil) {
		progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
	}
	if (tokenTimer == nil) {
		tokenTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
	}
	[self updateTokens];
	[self updateProgress];
}

- (void) stopTimers {
	[progressTimer invalidate];
	progressTimer = nil;
	[tokenTimer invalidate];
	tokenTimer = nil;
}

- (void) updateTokens {
	
}

- (void) updateProgress {
	if ([authenticator isFault]) { return;}
	NSDate *date = [NSDate date];
	NSTimeInterval seconds =  [date timeIntervalSince1970];
	
	[progressView setProgress: (((int) seconds % 30) +(seconds - (int) seconds))/30.0];
}

- (void) setFrame:(CGRect)inFrame {
	[super setFrame:inFrame];
	if(contentView != nil) {
		CGRect cvFrame = contentView.frame;
		cvFrame.size.width = inFrame.size.width;
		cvFrame.size.height = inFrame.size.height;
		
		contentView.frame = cvFrame	;	
	}
}

- (Authenticator*) authenticator{
	return authenticator;
}
 
- (void) setAuthenticator:(Authenticator *) inAuthenticator {
	[inAuthenticator retain];
	if (authenticator != nil) {
		[authenticator release];
	}
	authenticator = inAuthenticator;
	name.text = authenticator.name;
}

- (void)viewDidUnload {
	self.name = nil;
	self.code1 = nil;
	self.code2 = nil;
	self.code3 = nil;
	self.code4 = nil;
	self.code5 = nil;
	self.progressView = nil;

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[progressTimer invalidate];
	progressTimer = nil;
	[tokenTimer invalidate];
	tokenTimer = nil;
	[self.contentView release];
	[self.name release];
    [super dealloc];
}

@end

