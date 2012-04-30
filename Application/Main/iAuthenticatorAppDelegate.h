//
//  iAuthenticatorAppDelegate.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright Zachary Gavin 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iAuthenticatorAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
	UIWindow *window;
	IBOutlet UITabBarController* tabController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;



@end
