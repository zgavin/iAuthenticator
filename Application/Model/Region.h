//
//  Region.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Authenticator;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * offset;
@property (nonatomic, retain) NSSet *authenticators;
@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addAuthenticatorsObject:(Authenticator *)value;
- (void)removeAuthenticatorsObject:(Authenticator *)value;
- (void)addAuthenticators:(NSSet *)values;
- (void)removeAuthenticators:(NSSet *)values;

@end
