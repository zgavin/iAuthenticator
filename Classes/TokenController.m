//
//  TokenController.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "TokenController.h"
#import "iAuthenticatorAppDelegate.h"
#import "Authenticator.h"
#import "TokenView.h"
#import <tgmath.h>



@implementation TokenController
@synthesize scrollView;
@synthesize pageControl, needsReload;

- (void)viewDidLoad 
{
	needsReload = NO;
	tokenViews = [[[NSMutableArray alloc] init] retain];
	[self setup];
    [self restoreSavedView];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticatorsChanged:) name:@"AuthenticatorsChanged" object:nil];
	
    [super viewDidLoad];

	timers = [[NSMutableDictionary dictionary] retain];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Region" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entityDescription];
    
	NSError *error;
	regions = [self.managedObjectContext executeFetchRequest:request error:&error];
	for(Region* region in regions) {
		[self updateTimer:region];
	}
	
	
}
	
	

- (void)authenticatorsChanged:(NSNotification *)notification {
	needsReload = YES;
}
	
	
- (void) updateTokens:(NSTimer*) timer {
	Region * region = (Region*) [timer userInfo];
	NSDate* now = [NSDate date];
	NSTimeInterval seconds = [now timeIntervalSince1970]+[region.offset doubleValue];
	if(30.0-fmod(seconds,30.0) > .05) {
		for (TokenView* view in tokenViews) { 
			if ([view.authenticator.region isEqual:region]) {
				BOOL animated = (view == [self tokenView]);
				[view updateTokens:animated];
			}
			
		}
	}
	[self updateTimer:region];
}
	
- (void) updateTimer:(Region*) region {
	NSDate* now = [NSDate date];
	NSTimeInterval seconds = [now timeIntervalSince1970]+[region.offset doubleValue];
	NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:(30.0-fmod(seconds,30.0)) target:self selector:@selector(updateTokens:) userInfo:region repeats:NO]; 
	[timers setObject:timer forKey:region.code];
}



- (void)restoreSavedView {
    // Restore state
    int viewIdentifier = [[NSUserDefaults standardUserDefaults] integerForKey:@"last_view"];
    
    if (viewIdentifier != 0)
    {
        // load last page
        pageControl.currentPage = viewIdentifier;
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * pageControl.currentPage;
        frame.origin.y = 0;
        [scrollView scrollRectToVisible:frame animated:NO];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	for(NSTimer* timer in [timers allValues]) {
		Region* region = (Region*) [timer userInfo];
		[timer invalidate];
		[self updateTimer:region];
	}
	for(TokenView* view in tokenViews) {
		[view applicationWillEnterForeground:application];
	}
}

-(NSManagedObjectContext*) managedObjectContext {
	iAuthenticatorAppDelegate *appDelegate = (iAuthenticatorAppDelegate*)  [[UIApplication sharedApplication] delegate];
	return [appDelegate managedObjectContext];
}

#pragma mark -
#pragma mark The Guts
- (void)setup
{
	scrollView.delegate = self;
	
	[self.scrollView setBackgroundColor:[UIColor blackColor]];
	[scrollView setCanCancelContentTouches:NO];
	
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	
	[self reloadData];
	
}

- (void) reloadData {
	needsReload = NO;
	
	[tokenViews removeAllObjects];
	for(NSInteger i=0;i<scrollView.subviews.count;i++) {
		UIView *view = [scrollView.subviews objectAtIndex:i];
		[view removeFromSuperview];
	}
	
	NSLog(@"%@",scrollView.backgroundColor);
	scrollView.backgroundColor = [UIColor clearColor];
	NSLog(@"%@",scrollView.backgroundColor);

	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Authenticator" inManagedObjectContext:self.managedObjectContext];
	[request setEntity:entityDescription];
	
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    [sortDescriptor release];
    
	NSError *error;
	NSArray *fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
	if (fetchResults == nil) {
		NSLog(@"There was an error getting the list of Authenticators!");
		// handle error
	}	
	
	
	
	NSInteger authenticators = 0;
	CGFloat cx = 0;
	
	if(fetchResults.count == 0) {
		TokenView *tokenView = [[TokenView alloc] initWithoutAuthenticator];
		CGRect rect = tokenView.frame;
		rect.size.height = scrollView.frame.size.width;
		rect.size.width = scrollView.frame.size.height;
		rect.origin.x = cx;
		rect.origin.y = ((scrollView.frame.size.height - rect.size.height) / 2);
		tokenView.frame = rect;
		
		cx = scrollView.frame.size.width;
		
		[scrollView addSubview:tokenView];
		authenticators++;
	} else {
		
		for (authenticators; authenticators < fetchResults.count; authenticators++) {
			Authenticator *authenticator = [fetchResults objectAtIndex:authenticators];
			TokenView *tokenView = [[TokenView alloc] initWithAuthenticator:authenticator];
			CGRect rect = tokenView.frame;
			rect.size.height = scrollView.frame.size.width;
			rect.size.width = scrollView.frame.size.height;
			rect.origin.x = cx;
			rect.origin.y = ((scrollView.frame.size.height - rect.size.height) / 2);
			
			tokenView.frame = rect;
			
			[scrollView addSubview:tokenView];
			[tokenViews addObject:tokenView];
			cx += scrollView.frame.size.width;
		}
		
	}

	self.pageControl.numberOfPages = authenticators;
	[[self tokenView] startTimer];
	[scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
}

- (TokenView*) tokenView {
	if (tokenViews.count > 0 ) {
		return [tokenViews objectAtIndex:self.pageControl.currentPage];
	}
	return nil;
}

- (void) viewWillAppear:(BOOL)animated	{	
	if (needsReload)
		[self reloadData];
	else
		[[self tokenView] startTimer];
	
}

- (void) viewDidDisappear:(BOOL)animated {
	[[self tokenView] stopTimer];
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }
	
	/*
	 *	We switch page at 50% across
	 */
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if (page != pageControl.currentPage) {
		[[self tokenView] stopTimer];
	}
    pageControl.currentPage = page;
    
    // Save state
    [[NSUserDefaults standardUserDefaults] setInteger: pageControl.currentPage
											   forKey:@"last_view"];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
	[[self tokenView] startTimer];
    pageControlIsChangingPage = NO;
}

#pragma mark -
#pragma mark PageControl stuff
- (IBAction)changePage:(id)sender 
{
	/*
	 *	Change the scroll view
	 */
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
	
	/*
	 *	When the animated scrolling finishings, scrollViewDidEndDecelerating will turn this off
	 */
    pageControlIsChangingPage = YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[regions	release];
	[tokenViews release];
	[scrollView release];
	[pageControl release];
	for(NSTimer * timer in [timers allValues]) {
		[timer invalidate];
	}
	[timers release];
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"AuthenticatorsChanged" object:nil];
    [super dealloc];
}


@end
