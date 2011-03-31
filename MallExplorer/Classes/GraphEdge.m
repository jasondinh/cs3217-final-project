//
//  Edge.m
//  ApplicationLibrary
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Edge.h"


@implementation Edge
@synthesize node1;
@synthesize node2;
-(void) dealloc{
	[node1 release];
	[node2 release];
	[super dealloc];
}
@end
