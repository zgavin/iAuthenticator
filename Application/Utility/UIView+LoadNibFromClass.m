//
//  UIView+LoadNibFromClass.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 4/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+LoadNibFromClass.h"
#import "NSString+Utility.h"

@implementation UIView (LoadNibFromClass)

- (void) loadNibFromClass {
	Class class = [self class];
	while(class != [NSObject class]) {
		NSString* className = NSStringFromClass(class);
		NSArray* replacements = [NSArray arrayWithObjects:@"",@"SubController",@"View", nil];
		for(NSString* replacement in replacements) {
			if([className endsWith:replacement]) {
				NSString* nibName = [className substringToIndex:className.length-replacement.length];
				if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"]) {
					[[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]] instantiateWithOwner:self options:nil];
					return;
				}
			}
		}
		class = [class superclass];
	}
}


@end
