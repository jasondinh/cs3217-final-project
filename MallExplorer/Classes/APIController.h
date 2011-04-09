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

@interface APIController : NSObject {
	id<APIDelegate> delegate;	//delegate object does not get retained
	BOOL debugMode; //set to YES to enable NSLog of output
	
}
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
- (void)requestDidStart;

/**
 * Called when a request returns a response.
 */
- (void)requestDidLoad:(id)result;

/**
 * Called when a request fail
 */
- (void)requestFail;

/**
 * Called when a request hit the cache
 */
- (void)cacheRespond: (id) result;

/**
 * Called when a request hit the server
 */
- (void)serverRespond: (id) result;


@end