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
@synthesize value;
-(PQObject*) initWithObject:(id) object andValue:(double) value{
	self = [super init];
	if (self) {
		self.object = object;
		self.value = value;
	}
	return self;
}

@end
