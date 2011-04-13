//
//  APIController.h
//  MallExplorer
//
//  Created by Jason Dinh on 4/3/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import <CoreData/CoreData.h>

@protocol APIDelegate;

@interface APIController : NSObject <NSCopying> {
	id<APIDelegate> delegate;	//delegate object does not get retained
	BOOL debugMode; //set to YES to enable NSLog of output
	NSURL *url;
	id result;
	NSString *path;
}
@property (retain) NSString *path;
@property (retain) NSURL *url;
@property (retain) id result;
@property (nonatomic,assign) id<APIDelegate> delegate;
@property BOOL debugMode;

- (void) getAPI: (NSString *) path;
- (void) postAPI: (NSString *) path withData: (NSDictionary *) data;

@end

@protocol APIDelegate <NSObject>

@optional

/**
 * Called when a request start
 */
- (void)requestDidStart: (APIController *) apiController;

/**
 * Called when a request returns a response.
 */
- (void)requestDidLoad: (APIController *) apiController;

/**
 * Called when a request fail
 */
- (void)requestFail: (APIController *) apiController;

/**
 * Called when a request hit the cache
 */
- (void)cacheRespond: (APIController *) apiController;

/**
 * Called when a request hit the server
 */
- (void)serverRespond: (APIController *) apiController;


@end