//
//  FacebookController.m
//  MallExplorer
//
//  Created by bathanh-m on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookController.h"
#import "Constant.h"
@implementation FacebookController
@synthesize facebook;

- (void) init {
	self = [super init];
	
	if (self != nil) {
		facebook = [[Facebook alloc] initWithAppId: FB_APP_ID];
	}
	
	return self;
}

- (void) checkInatLongitude: (NSString *) lon andLat: (NSString *) lat andShopName: (NSString *) shopName {
	//[facebook requestWithGraphPath:@"me/checkins" andParams:<#(NSMutableDictionary *)params#> andHttpMethod:<#(NSString *)httpMethod#> andDelegate:<#(id <FBRequestDelegate>)delegate#>]
}
		 

- (void) authorize {
	
	//check if already authorized
	NSString *permission = [NSArray arrayWithObjects: @"publish_checkins", nil];
	[facebook authorize: permission delegate: self];
}

- (void)fbDidLogin {
	NSLog(@"fb logged in");
	//write to 
}

- (void) dealloc {
	[facebook release];
	[super dealloc];
}

@end
