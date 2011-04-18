//
//  Shop.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Shop.h"


@implementation Shop
@synthesize category;
@synthesize level;
@synthesize unitNumber;
@synthesize shopName;
@synthesize annotation;
@synthesize commentList, description, sId, pId;

-(void) setAnnotation:(Annotation *) anAnno{
	if (annotation!= anAnno) {
		[annotation release];
		annotation = [anAnno retain];
		annotation.shop = self;
	}
}

-(void) loadComment:(NSArray*) commentList{
	// do something
}

-(id) initWithId: (NSInteger) sId
		andLevel: (NSString *) l 
		 andUnit: (NSString *) u 
	 andShopName: (NSString *) s 
  andDescription: (NSString *) d {
	
	self = [super init];
	
	if (self != nil) {
		self.sId = sId;
		self.level = l;
		self.unitNumber = u;
		self.shopName = s;
		self.description = d;
	}
	
	return self;
	
}

- (void) dealloc {
	[level release];
	[unitNumber release];
	[shopName release];
	[annotation release];
	[commentList release];
	[description release];
	[super dealloc];
}

@end
