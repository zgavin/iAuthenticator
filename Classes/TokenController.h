//
//  TokenController.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Region.h"

@class TokenView;

@interface TokenController : UIViewController <UIScrollViewDelegate>{
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIPageControl* pageControl;
	
	NSMutableArray* tokenViews;
	NSArray* regions;
	NSMutableDictionary* timers;
    BOOL pageControlIsChangingPage;
	BOOL needsReload;
}

@property (nonatomic, retain) UIView *scrollView;
@property (nonatomic, retain) UIPageControl* pageControl;
@property () BOOL needsReload;

/* for pageControl */
- (IBAction)changePage:(id)sender;


/* internal */
- (void)authenticatorsChanged:(NSNotification *)notification ;
- (void)setup;
- (void)reloadData;
- (void)restoreSavedView;

- (NSManagedObjectContext*) managedObjectContext;

- (TokenView*) tokenView;
- (void) updateTokens:(NSTimer*) timer;
- (void) updateTimer:(Region*) region;

@end
