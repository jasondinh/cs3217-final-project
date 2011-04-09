//
//  Shop.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Annotation.h"

typedef enum {
	a, b, c
} ShopCategory;

@interface Shop : NSObject {
	ShopCategory category;
	NSString* level;
	NSString* unitNumber;
	NSString* shopName;
	NSMutableArray* commentList;
	Annotation* annotation;
}
@property ShopCategory category;
@property (retain) NSString* level;
@property (retain) NSString* unitNumber;
@property (retain) NSString* shopName;
@property (retain) NSArray* commentList;
@property (assign) Annotation* annotation;

-(void) loadComment:(NSArray*) commentList;

@end
