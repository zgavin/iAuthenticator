//
//  TokenView.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/13/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "TokenController.h"
#import "AuthenticatorController.h"
#import "Region+Custom.h"
#import "UIView+isVisible.h"

@implementation TokenController

@synthesize authenticator;

- (void) viewDidLoad {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:AUTHENTICATOR_CONTROLLER_TICK object:nil];
	if(self.authenticator) { [self refresh]; }
}

- (void) viewWillUnload {
	
}

- (void) setAuthenticator:(Authenticator*) _authenticator {
	authenticator = _authenticator;
	if(self.isViewLoaded) { [self refresh]; }
}

- (void) updateProgress:(NSTimer*) _timer {
	NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	progressView.progress = (time - ((int) time / 30) *30) / 30.0;
	NSArray* codeLabels = codesView.subviews;
	if (![((UILabel*) [codeLabels objectAtIndex:codeLabels.count-1]).text isEqualToString:authenticator.token]) {
		[self refresh];
		if (self.view.visible) {
			for (int i=0; i<codeLabels.count; i++) {
				UILabel* label = [codeLabels objectAtIndex:i];
				CGRect frame = label.frame;
				frame.origin.y = 60*(i);
				label.frame = frame;
				label.alpha = .25*(i+1);
			}
			
			[UIView animateWithDuration:1 animations:^{
				for (int i=0; i<codeLabels.count; i++) {
					UILabel* label = [codeLabels objectAtIndex:i];
					CGRect frame = label.frame;
					frame.origin.y = 60*(i-1);
					label.frame = frame;
					label.alpha = .25*i;
				}
			}];
		}
	}
}

- (void) refresh {
	nameLabel.text = authenticator.name;
	
	NSArray* codeLabels = codesView.subviews;
	
	NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	for (int i=0; i<codeLabels.count; i++) {
		UILabel* label = [codesView.subviews objectAtIndex:i];
		label.text = [authenticator tokenAtTimeinterval:time-((((int) codeLabels.count)-i-1)*30)];
		label.alpha = .25*i;
	}
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:AUTHENTICATOR_CONTROLLER_TICK object:nil];
}

@end

