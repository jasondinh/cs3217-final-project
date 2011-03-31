//
//  GraphEdge.m
//  ApplicationLibrary
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GraphEdge.h"


@implementation GraphEdge
@synthesize node1;
@synthesize node2;
@synthesize weight;
-(void) dealloc{
	[node1 release];
	[node2 release];
	[super dealloc];
}
@end
