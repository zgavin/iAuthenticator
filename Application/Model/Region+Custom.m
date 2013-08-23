// 
//  Region.m
//  iAuthenticator
//
//  Created by Zachary Gavin on 1/12/11.
//  Copyright 2011 Zachary Gavin. All rights reserved.
//

#import "Region+Custom.h"

@implementation Region (Custom)

- (void) sync {
	[self syncWithCompletionBlock:nil];
}

- (void) syncWithCompletionBlock:(void(^)()) callback {
	NSTimeInterval systemTime = [[NSDate date] timeIntervalSince1970];
	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://m.%@.mobileservice.blizzard.com/enrollment/time.htm",self.code]];

	
	[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error){
		uint64_t milliseconds = 0;
		[data getBytes:&milliseconds length:8];
		milliseconds = CFSwapInt64BigToHost(milliseconds);
		
		NSTimeInterval seconds = milliseconds / 1000.0;
		
		NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
		
		self.offset = [NSNumber numberWithDouble:seconds-(systemTime+now)/2.0];
		
		if(callback) callback();
	}];
}

static Region* europe;
static Region* northAmerica;


+ (void) initializeRegions {
	if ([Region findAll].count == 0) {
		northAmerica = [Region createEntity];
		northAmerica.name = @"North America";
		northAmerica.code = @"US";
		
		europe = [Region createEntity];
		europe.name = @"Europe";
		europe.code = @"EU";
		
		[[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
	}
}

+ (Region*) europe {

	if(!europe) europe = [Region findFirstByAttribute:@"code" withValue:@"EU"];
	return europe;
}

+ (Region*) northAmerica {

	if(!northAmerica) northAmerica = [Region findFirstByAttribute:@"code" withValue:@"US"];
	return northAmerica;
}


@end



