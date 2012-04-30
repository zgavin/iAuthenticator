//
//  TokenController.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Region.h"

@class TokenController;

extern NSString* const AUTHENTICATOR_CONTROLLER_TICK;

@interface AuthenticatorController : UIViewController <UIScrollViewDelegate>{
	IBOutlet UIScrollView* scrollView;
	IBOutlet UIPageControl* pageControl;
	IBOutlet UIView* noAuthenticatorsView;
	
	NSTimer* timer;
}

@end
