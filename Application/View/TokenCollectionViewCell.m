//
//  TokenView.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/13/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "TokenCollectionViewCell.h"
#import "AuthenticatorController.h"
#import "Region+Custom.h"
#import "UIView+isVisible.h"
#import <QuartzCore/QuartzCore.h>

@implementation TokenCollectionViewCell

@synthesize authenticator;

- (void) awakeFromNib {
	[super awakeFromNib];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:AUTHENTICATOR_CONTROLLER_TICK object:nil];

	CALayer* layer = [self.contentView.subviews.lastObject layer];
	layer.cornerRadius = 15;

	layer = codesView.layer;
	layer.cornerRadius = 10;
}

- (void) setAuthenticator:(Authenticator*) _authenticator {
	authenticator = _authenticator;

	[self refreshCodes];
}

- (void) updateProgress:(NSTimer*) _timer {
	NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	progressView.progress = (time - ((int) time / 30) *30) / 30.0;
	NSArray* codeLabels = codesView.subviews;
	if ( ![[codeLabels.lastObject text] isEqualToString:authenticator.token] ) {
		
		[self refreshCodes];
		
		CGFloat offset = codesView.bounds.size.height / (codesView.subviews.count - 1) ;
		
		for (int i=0; i<codeLabels.count; i++) {
			UILabel* label = codeLabels[i];
			CGRect frame = label.frame;
			frame.origin.y = offset*(i);
			label.frame = frame;
			label.alpha = .25*(i+1);
		}
		
		[UIView animateWithDuration:1 animations:^{
			for (int i=0; i<codeLabels.count; i++) {
				UILabel* label = codeLabels[i];
				CGRect frame = label.frame;
				frame.origin.y = offset*(i-1);
				label.frame = frame;
				label.alpha = .25*i;
			}
		}];
		
	}
}

- (void) refreshCodes {
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

