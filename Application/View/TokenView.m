//
//  TokenView.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/13/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "TokenView.h"
#import "TokenController.h"
#import "Region+Custom.h"
#import "UIView+LoadNibFromClass.h"
#import "UIView+isVisible.h"

@implementation TokenView

@synthesize authenticator;

- (id) initWithCoder:(NSCoder *)aDecoder {
	if(self = [super initWithCoder:aDecoder]) {
		[self load];
	}
	return self;
}

- (id) initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]) {
		[self load];
	}
	return self;
}

- (void) load {
	[self loadNibFromClass];
	[self addSubview:view];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:TOKEN_CONTROLLER_TICK object:nil];
	
}

- (void) setAuthenticator:(Authenticator*) _authenticator {
	authenticator = _authenticator;
	if(self.superview) { [self refresh]; }
}

- (void) willMoveToSuperview:(UIView *)newSuperview {
	if(newSuperview && self.authenticator) { [self refresh]; }
}

- (void) updateProgress:(NSTimer*) _timer {
	NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	progressView.progress = (time - ((int) time / 30) *30) / 30.0;
	NSArray* codeLabels = codesView.subviews;
	if (![((UILabel*) [codeLabels objectAtIndex:codeLabels.count-1]).text isEqualToString:authenticator.token]) {
		[self refresh];
		if (self.visible) {
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
	[[NSNotificationCenter defaultCenter] removeObserver:self name:TOKEN_CONTROLLER_TICK object:nil];
}

@end

