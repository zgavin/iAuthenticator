//
//  FieldDescription.h
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FieldDescription : NSObject <NSCopying> {
	NSString * field;
	NSString * label;
	Class klass;
	NSObject * data;
	CGRect frame;
}

@property (nonatomic,readonly) NSString * field;
@property (nonatomic,readonly) NSString * label;
@property (readonly) Class klass;
@property (nonatomic,readonly) NSObject * data;
@property (readonly) CGRect frame;

- (FieldDescription*) initWithField:(NSString*) inField label:(NSString*) inLabel klass:(Class) inClass data:(NSObject*) inData frame:(CGRect) inFrame;
- (NSString*) setterField;

@end
