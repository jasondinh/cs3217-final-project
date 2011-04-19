//
//  Shop.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import <Foundation/Foundation.h>
#import "Annotation.h"

typedef enum {
	a, b, c
} ShopCategory;

@interface Shop : NSObject {
	NSInteger sId;
	ShopCategory category;
	NSString* level;
	NSString* unitNumber;
	NSString* shopName;
	NSMutableArray* commentList;
	Annotation* annotation;
	NSString *description;
	NSInteger pId;
}
@property NSInteger sId;
@property NSInteger pId;
@property ShopCategory category;
@property (retain) NSString* level;
@property (retain) NSString* unitNumber;
@property (retain) NSString* shopName;
@property (retain) NSArray* commentList;
@property (retain) Annotation* annotation;
@property (retain) NSString *description;

-(void) loadComment:(NSArray*) commentList;

-(id) initWithId: (NSInteger) sId
		andLevel: (NSString *) l 
		 andUnit: (NSString *) u 
	 andShopName: (NSString *) s 
  andDescription: (NSString *) d;
@end
