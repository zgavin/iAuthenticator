//
//  Region.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Region :  NSManagedObject  {
	NSMutableData * receivedData;
	NSTimeInterval systemTime;
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * offset;

- (void) sync ;

@end



