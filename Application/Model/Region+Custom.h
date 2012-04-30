//
//  Region.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Region.h"


@interface Region (Custom)

- (void) sync;
- (void) syncWithCompletionBlock:(void(^)()) callback;

+ (void) initializeRegions;

+ (Region*) europe;
+ (Region*) northAmerica;

@end



