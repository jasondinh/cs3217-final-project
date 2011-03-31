//
//  Graph.m
//  ApplicationLibrary
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Graph.h"

@implementation Graph

@synthesize listNode;
@synthesize listEdge;
@synthesize isBiDiGraph;
@synthesize isMultiGraph;
-(int) addNode:(Node*) node{
	[listNode insertObject:node atIndex:nextNodeIndex];
	NSMutableArray* adjacentList = [[NSMutableArray alloc] init];
	[listEdge insertObject:adjacentList atIndex:nextNodeIndex];
	nextNodeIndex++;
	return nextNodeIndex-1;
}
-(BOOL) addEdgeFromNode:(Node*)n1 toNode:(Node*) n2 withWeight:(double) w{
	NSMutableArray* adjacentList = [listEdge objectAtIndex:n1.index];
	Edge* edge = [Edge EdgeWithNode:n1 andNode:n2 withWeight:w];
	if (!isMultiGraph) {
		if ([adjacentList indexOfObject:edge]!=NSNotFound) {
			return NO;
		}
	}
	[adjacentList addObject:edge];
	return YES;
}
-(BOOL) addEdge:(Edge*) edge{
	if (![self addEdgeFromNode: [edge getSourceNode] toNode:[edge getDestinationNode] withWeight: edge.weight]) return NO;
	if (isBiDiGraph) 
		if (![self addEdgeFromNode: [edge getDestinationNode] toNode: [edge getSourceNode] withWeight: edge.weight]) return NO;
	return YES;
}
-(NSArray*) getAdjacentNodes:(Node*) node{
	if ([listNode indexOfObject:node]==NSNotFound) {
		return nil;
	}
	return [listEdge objectAtIndex:node.index];
}
-(double) getWeightOfEdgeBetweenNode:(Node*) n1 andNode:(Node*) n2{
	if ([listNode indexOfObject:n1]==NSNotFound) return -1;
	if (isMultiGraph) return -1;
	NSMutableArray* adjacentList = [listEdge objectAtIndex:n1.index];
	for (int i = 0; i<[adjacentList count]; i++)
	{
		Edge* edge = [adjacentList objectAtIndex:i];
		if ([edge getDestinationNode] == n2)
		{
			return edge.weight;
		}
	}
	return -1;
}
-(double) dijkstra: (Node*) n1 and: (Node*) n2{
	BOOL check[];
	for (int i = 0; i<nextNodeIndex; i++)
}
-(double) getShortestPathBetweenNode:(Node*) n1 andNode:(Node*) n2{
	return [self dijkstra:n1 and: n2];
}
	
@end
