//
//  GraphEdge.m
//  ApplicationLibrary
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import "GraphEdge.h"


@implementation GraphEdge
@synthesize node1;
@synthesize node2;
@synthesize weight;
-(GraphEdge*) initEdgeWithNode:(GraphNode*) n1 andNode:(GraphNode*) n2 withWeight:(double) w{
	self = [super init];
	if (self) {
		self.node1 = n1;
		self.node2 = n2;
		self.weight = w;
	}
	return self;
}
+(GraphEdge*) EdgeWithNode:(GraphNode*) n1 andNode:(GraphNode*) n2 withWeight:(double) w{
	return [[[GraphEdge alloc] initEdgeWithNode:n1 andNode:n2 withWeight:w] autorelease];
}
-(GraphNode*) getSourceNode{
	return node1;
}
-(GraphNode*) getDestinationNode{
	return node2;
}
-(BOOL) isEqual:(id)o{
	if (![o isMemberOfClass:[GraphEdge class]]) {
		return NO;
	}
	GraphEdge* obj = (GraphEdge*) o;
	if ([node1 isEqual: obj.node1] && [node2 isEqual:obj.node2] )
	{
		return YES;
	} 
	else return NO;
}
-(void) dealloc{
	[node1 release];
	[node2 release];
	[super dealloc];
}
@end
