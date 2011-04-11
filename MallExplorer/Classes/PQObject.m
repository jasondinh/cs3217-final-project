//
//  PQObject.m
//  MallExplorer
//
//  Created by Tran Cong Hoang on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PQObject.h"


@implementation PQObject
@synthesize object;
@synthesize val;
@synthesize posInHeap;
-(PQObject*) initWithObject:(id) object andValue:(double) value{
	self = [super init];
	if (self) {
		self.object = object;
		self.val = value;
		self.posInHeap = -1;
	}
	return self;
}

@end
