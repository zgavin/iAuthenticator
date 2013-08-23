//
//  TokenController.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "AuthenticatorController.h"
#import "AppDelegate.h"
#import "Authenticator+Custom.h"
#import "TokenCollectionViewCell.h"
#import "NSArray+Enumerable.h"
#import "NSMutableArray+Utility.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

NSString* const AUTHENTICATOR_CONTROLLER_TICK = @"TOKEN_CONTROLLER_TICK";

@implementation AuthenticatorController

- (void) viewDidLoad {	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:AUTHENTICATOR_UPDATE_NOTIFICATION object:nil];
	
	CGColorRef ref;
	CGFloat components[] = {0,5,6,7};
	ref = CGColorCreate(CGColorSpaceCreateDeviceCMYK(), components);
}

- (void) viewWillAppear:(BOOL)animated {
	[self refresh];
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerUpdate:) userInfo:nil repeats:YES];
}

- (void) viewWillDisappear:(BOOL)animated {
	[timer invalidate],timer=nil;
}

- (void) timerUpdate:(NSTimer*) timer {
	[[NSNotificationCenter defaultCenter] postNotificationName:AUTHENTICATOR_CONTROLLER_TICK object:self];
}

- (NSInteger) collectionView:(UICollectionView *)_collectionView numberOfItemsInSection:(NSInteger)section {
	return authenticators.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	TokenCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TokenCell" forIndexPath:indexPath];
	
	cell.authenticator = authenticators[indexPath.row];
	
	return cell;
}

- (void) scrollViewDidScroll:(UIScrollView *)_scrollView {
	CGFloat pageWidth = _scrollView.frame.size.width;
	int tmp =  floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;;
	if(tmp != pageControl.currentPage) {
		pageControl.currentPage = tmp;
	}
}

- (void) refresh {
	authenticators = [Authenticator findAllSortedBy:@"name" ascending:YES];
	
	noAuthenticatorsView.hidden = (authenticators.count > 0);
	
	pageControl.numberOfPages = authenticators.count ?: 1;
	
	[collectionView reloadData];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:AUTHENTICATOR_UPDATE_NOTIFICATION object:nil];
}


@end
