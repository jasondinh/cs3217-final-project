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
	
}

@end
