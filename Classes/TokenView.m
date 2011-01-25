//
//  TokenView.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/13/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "TokenView.h"
#import "Region.h"


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
	code1.text = @"";
	code2.text = @"";
	code3.text = @"";
	code4.text = @"";
	code5.text = @"Add some authenticators";
	code5.font = [UIFont systemFontOfSize:14.0];
	
	
	
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
	
	codes = [[NSMutableArray arrayWithObjects:code1,code2,code3,code4,code5,nil] retain];
	
	NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
	int token_time = seconds -120;
	double a = 0;
	double y = -60;
	for (UILabel* label in codes) {
		CGRect f = label.frame;
		f.origin.y = y;
		y += 60;
		label.frame = f;
		label.text = [authenticator tokenAtTimeinterval:token_time];
		label.alpha = a;
		a += .25;
		token_time += 30;
	}
	[self resetTopLabel];
	return self;
}

- (void) didMoveToSuperview {
	if(authenticator) {
		[self updateProgress];
	}
	[self resignFirstResponder];
}


- (void) startTimer {
	if (timer == nil) {
		timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
	}
	[self updateProgress];
}

- (void) stopTimer {
	[timer invalidate];
	timer = nil;
}

- (void) updateTokens:(BOOL) animated {
	if (codes.count == 0) { return; }
	UILabel* current_label = [codes objectAtIndex:0];
	current_label.text = [authenticator token];
	[codes removeObjectAtIndex:0];
	[codes addObject:current_label];
	if (animated) {
		[UIView beginAnimations:@"moveLabels" context:nil];
		[UIView setAnimationDuration:1.5];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	}
	for(UILabel* label in codes) {
		CGRect f = label.frame;
		f.origin.y -= 60;
		label.frame = f;
		label.alpha = (current_label == label) ? 1.0:label.alpha- 0.25;
	}
	if(animated) { 
		[UIView commitAnimations]; 
	} else {
		[self resetTopLabel];
	}
}


- (void) resetTopLabel {
	UILabel* moved = [codes objectAtIndex:0];
	CGRect f = moved.frame;
	f.origin.y = 240;
	moved.frame = f;
	moved.alpha = 1.0;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[self resetTopLabel];
}

- (void) updateProgress {
	if ([authenticator isFault]) { return;}
	NSDate *date = [NSDate date];
	NSTimeInterval seconds =  [date timeIntervalSince1970]+[authenticator.region.offset doubleValue];
	
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

- (void)applicationWillEnterForeground:(UIApplication *)application {
	NSTimeInterval seconds = [[NSDate date] timeIntervalSince1970];
	int token_time = seconds -120;
	for (UILabel* label in codes) {
		label.text = [authenticator tokenAtTimeinterval:token_time];
		token_time += 30;
	}
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
	[codes release];
	[timer invalidate];
	timer = nil;
	[self.contentView release];
	[self.name release];
    [super dealloc];
}

@end

