//
//  TokenController.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TokenView;

@interface TokenController : UIViewController <UIScrollViewDelegate>{
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIPageControl* pageControl;
	
	NSMutableArray* tokenViews;
    BOOL pageControlIsChangingPage;
	BOOL needsReload;
	
	NSTimer* timer;
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

- (IBAction) btnClicked:(id) sender;
- (IBAction) dateClicked:(id) sender;
- (void) saveAction;
- (TokenView*) tokenView ;
- (void) updateTokens;
- (void) updateTimer;

@end
