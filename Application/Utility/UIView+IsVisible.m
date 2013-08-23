//
//  UIView+IsVisible.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+IsVisible.h"

@implementation UIView (IsVisible)

- (BOOL) visible {
	if(self.hidden) return NO;
	if(!self.window) return NO;
	if(!self.superview) return NO;
	
	CGRect intersection = CGRectIntersection(self.frame, self.superview.bounds);
	if(CGRectIsNull(intersection) || intersection.size.width == 0 || intersection.size.height == 0) return NO;
	
	return self.superview == self.window ?: self.superview.visible;
}

@end
