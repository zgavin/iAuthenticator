//
//  TokenController.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "TokenController.h"
#import "iAuthenticatorAppDelegate.h"
#import "Authenticator+Custom.h"
#import "TokenView.h"
#import "NSArray+Enumerable.h"
#import "NSMutableArray+Utility.h"
#import <QuartzCore/QuartzCore.h>

NSString* const TOKEN_CONTROLLER_TICK = @"TOKEN_CONTROLLER_TICK";

@implementation TokenController

- (void) viewDidLoad {
	[self reloadData];
	
	CALayer* layer = noAuthenticatorsView.layer;
	layer.cornerRadius = 15;
	layer.borderWidth = 1;
	layer.borderColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.4 alpha:1].CGColor;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:AUTHENTICATOR_UPDATE_NOTIFICATION object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
	[timer invalidate];
}

- (void) timerUpdate:(NSTimer*) timer {
	[[NSNotificationCenter defaultCenter] postNotificationName:TOKEN_CONTROLLER_TICK object:self];
}

- (void) reloadData {
	NSArray* authenticators = [Authenticator findAllSortedBy:@"name" ascending:YES];
	
	noAuthenticatorsView.hidden = (authenticators.count > 0);
	
	NSMutableArray* existingViews = [NSMutableArray arrayWithArray:[scrollView.subviews select:^(id view){ return [view isKindOfClass:[TokenView class]];}]];
	[authenticators enumerateObjectsUsingBlock:^(Authenticator* authenticator,NSUInteger idx,BOOL* stop) {
		TokenView* tokenView = [existingViews shift] ?: [[TokenView alloc] init];
		tokenView.frame = CGRectMake(scrollView.frame.size.width*idx, 0, scrollView.frame.size.width, scrollView.frame.size.height);
		tokenView.authenticator = authenticator;
		
		if(!tokenView.superview) [scrollView addSubview:tokenView];
	}];
	
	for(UIView* view in existingViews) { [view removeFromSuperview]; }

	pageControl.numberOfPages = authenticators.count ?: 1;
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*authenticators.count, scrollView.frame.size.height);
	pageControl.currentPage = self.page;
}

- (int) page {
	CGFloat pageWidth = scrollView.frame.size.width;
	return floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void) scrollViewDidScroll:(UIScrollView *)_scrollView {	
	int tmp = self.page;
	if(tmp != pageControl.currentPage) {
		pageControl.currentPage = tmp;
	}
}



@end
