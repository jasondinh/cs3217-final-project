//
//  Shop.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	a, b, c
} ShopCategory;

@interface Shop : NSObject {
	ShopCategory category;
	NSString* level;
	NSString* unitNumber;
	NSString* shopName;
	NSMutableArray* commentList;
}
@property ShopCategory category;
@property (retain) NSString* level;
@property (retain) NSString* unitNumber;
@property (retain) NSString* shopName;
@property (retain) NSArray* commentList;

-(void) loadComment:(NSArray*) commentList;

@end
