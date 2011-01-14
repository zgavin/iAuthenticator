//
//  Authenticator.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Region;

@interface Authenticator :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * serial;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Region * region;

- (NSString*) token;
- (NSString*) tokenAtTimeinterval: (NSTimeInterval) time;

@end



