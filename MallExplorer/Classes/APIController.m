//
//  APIController.m
//  MallExplorer
//
//  Created by Jason Dinh on 4/3/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "APIController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@implementation APIController
@synthesize delegate;

- (void) getAPI: (NSString *) path {
	NSURL *url = [NSURL URLWithString: path];
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL: url];
	[request setDelegate: self];
	[request setDidFailSelector: @selector(APIFailed:)];
	[request setDidFinishSelector: @selector(APIFinished:)];
	[request setDidStartSelector: @selector(APIStarted:)];
}

- (void) postAPI: (NSString *) path withData: (NSDictionary *) data {
	
}

- (void) APIStarted: (ASIHTTPRequest *) request {
	if ([delegate respondsToSelector: @selector(requestDidStart)]) {
		[delegate requestDidStart];
	}
}

- (void) APIFinished: (ASIHTTPRequest *) request {
	//TODO: decode json and return output
	if ([delegate respondsToSelector: @selector(requestDidLoad:)]) {
		[delegate requestDidLoad: [request responseString]];
	}
}

- (void) APIFailed: (ASIHTTPRequest *) request {
	if ([delegate respondsToSelector: @selector(requestFail)]) {
		[delegate requestFail];
	}
}


- (void) dealloc {
	[super dealloc];
}

@end