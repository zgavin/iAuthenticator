//
//  Authenticator.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Region;

@interface Authenticator : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * serial;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Region *region;

@end
