//
//  FieldDescription.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FieldDescription.h"


@implementation FieldDescription

@synthesize field;
@synthesize label;
@synthesize klass;
@synthesize data;
@synthesize frame;

- (FieldDescription*) initWithField:(NSString*) inField label:(NSString*) inLabel klass:(Class) inClass data:(NSObject*) inData frame:(CGRect) inFrame {
 	field = [inField retain];
	label = [inLabel retain];
	klass = inClass;
	data = [inData retain];
	frame = inFrame;
	return self;
}

- (id) copyWithZone:(NSZone *)zone{
	return [self retain];//[[FieldDescription alloc] initWithField:[[field copyWithZone:zone] retain] label:[[label copyWithZone:zone] retain] klass:klass data:[[data copy] retain] frame:frame];
}

- (NSString*) setterField {
	return [NSString stringWithFormat:@"set%@%@:",[[field substringToIndex:1] uppercaseString],[field substringFromIndex:1]];
}

- (void) dealloc {
	[field release]; 
	[label release];
	[data release];
	
	[super dealloc];
}
@end
