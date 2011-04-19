//
//  FacebookController.m
//  MallExplorer
//
//  Created by Jason Dinh on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookController.h"
#import "Constant.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "TapkuLibrary.h"
@implementation FacebookController
@synthesize facebook;

- (id) init {

	self = [super init];
	
	if (self != nil) {
		self.facebook = [[Facebook alloc] initWithAppId: FB_APP_ID];
	}
	
	return self;
}

- (void) checkInatLongitude: (NSString *) lon andLat: (NSString *) lat andShopName: (NSString *) shopName andPlaceId: (NSString *) pId {
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
	[request setPostValue: [NSString stringWithFormat: @"I'm at %@", shopName] forKey: @"message"];
	[request setPostValue: pId forKey: @"place"];
	[request startAsynchronous];
	
}

- (void) finished: (ASIFormDataRequest *) request {
	[[TKAlertCenter defaultCenter] postAlertWithMessage:@"Checked in!"];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog([error description]);
}

- (void) retrieveFBToken {
	facebook.accessToken    = [[NSUserDefaults standardUserDefaults] stringForKey:@"FBAccessToken"];
	facebook.expirationDate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"FBExpirationDate"];
}
		 

- (void) authorize {
	[self retrieveFBToken];
	
	//check if already authorized
	
	if (![facebook isSessionValid]) {
		NSArray *permission = [NSArray arrayWithObjects: @"publish_checkins", @"offline_access", nil];
		[self.facebook authorize: permission delegate:self];
	}
	else {
		[[NSNotificationCenter defaultCenter] postNotificationName: @"FBLoggedIn" object:self];
	}
	
}

- (void)fbDidLogin {
	[[NSUserDefaults standardUserDefaults] setObject:self.facebook.accessToken forKey:@"FBAccessToken"];
	[[NSUserDefaults standardUserDefaults] setObject:self.facebook.expirationDate forKey:@"FBExpirationDate"];
	[[NSNotificationCenter defaultCenter] postNotificationName: @"FBLoggedIn" object:self];
}

- (void) clearFBInfo {
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"FBAccessToken"];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"FBExpirationDate"];
}

- (void) dealloc {
	[facebook release];
	[super dealloc];
}

@end
