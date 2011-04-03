//
//  GraphNode.m
//  ApplicationLibrary
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphNode.h"


@implementation GraphNode
@synthesize index;
@synthesize object;
-(GraphNode*) initWithObject:(id)obj andId:(int) ind{
	self = [super init];
	if (self) {
		index = ind;
		self.object = obj;
	}
	return self;
}
-(BOOL) isEqual:(id)o{
	if (![o isMemberOfClass:[GraphNode class]]) {
		return NO;
	}
	GraphNode* obj = (GraphNode*) o;
	if (index == obj.index) {
		 return YES;
	} else return NO;
}
@end
