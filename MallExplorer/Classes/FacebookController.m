//
//  FacebookController.m
//  MallExplorer
//
//  Created by bathanh-m on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookController.h"
#import "Constant.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
@implementation FacebookController
@synthesize facebook;

- (id) init {

	self = [super init];
	
	if (self != nil) {
		self.facebook = [[Facebook alloc] initWithAppId: FB_APP_ID];
	}
	
	return self;
}

- (void) checkInatLongitude: (NSString *) lon andLat: (NSString *) lat andShopName: (NSString *) shopName {
	//NSMutableDictionary *params = [NSMutableDictionary dictionary];
	NSDictionary *coordinates = [NSDictionary dictionaryWithObjectsAndKeys: lat, @"latitude", lon, @"longitude", nil];
//	[params setValue:[coordinates JSONRepresentation] forKey: @"coordinates"];
//	[params setValue: @"ye`" forKey: @"message"];
//	[params setValue: facebook.accessToken forKey: @"access_token"];
//				
//	[facebook requestWithGraphPath:@"me/checkins" andParams:params andHttpMethod:@"POST" andDelegate:self];
	
	NSURL *url = [NSURL URLWithString: @"https://graph.facebook.com/me/checkins"];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: url];
	[request setDelegate: self];
	[request setDidFinishSelector: @selector(finished:)];
	[request setPostValue: [coordinates JSONRepresentation] forKey: @"coordinates"];
	[request setPostValue: facebook.accessToken forKey: @"access_token"];
	[request setPostValue: @"aaaaaaa" forKey: @"message"];
	[request setPostValue: @"162222677131935" forKey: @"place"];
	
	[request startAsynchronous];
	
}

- (void) finished: (ASIFormDataRequest *) request {
	NSLog([request responseString]);
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog([error description]);
}
		 

- (void) authorize {
	NSLog(@"%@", @"fb authorized");
	//check if already authorized
	NSArray *permission = [NSArray arrayWithObjects: @"publish_checkins", @"offline_access", nil];
	[self.facebook authorize: permission delegate:self];
}

- (void)fbDidLogin {
	NSLog(@"fb logged in");
	//write to 
	NSLog(facebook.accessToken);
	[self checkInatLongitude: @"1.0" andLat:@"1.0" andShopName: @"aa"];
}

- (void) dealloc {
	[facebook release];
	[super dealloc];
}

@end
