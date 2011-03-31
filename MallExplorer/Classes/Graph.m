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
-(int) addNode:(GraphNode*) node{
	[listNode insertObject:node atIndex:nextNodeIndex];
	NSMutableArray* adjacentList = [[NSMutableArray alloc] init];
	[listEdge insertObject:adjacentList atIndex:nextNodeIndex];
	nextNodeIndex++;
	return nextNodeIndex-1;
}
-(BOOL) addEdgeFromNode:(GraphNode*)n1 toNode:(GraphNode*) n2 withWeight:(double) w{
	NSMutableArray* adjacentList = [listEdge objectAtIndex:n1.index];
	GraphEdge* edge = [GraphEdge EdgeWithNode:n1 andNode:n2 withWeight:w];
	if (!isMultiGraph) {
		if ([adjacentList indexOfObject:edge]!=NSNotFound) {
			return NO;
		}
	}
	[adjacentList addObject:edge];
	return YES;
}
-(BOOL) addEdge:(GraphEdge*) edge{
	if (![self addEdgeFromNode: [edge getSourceNode] toNode:[edge getDestinationNode] withWeight: edge.weight]) return NO;
	if (isBiDiGraph) 
		if (![self addEdgeFromNode: [edge getDestinationNode] toNode: [edge getSourceNode] withWeight: edge.weight]) return NO;
	return YES;
}
-(NSArray*) getAdjacentNodes:(GraphNode*) node{
	if ([listNode indexOfObject:node]==NSNotFound) {
		return nil;
	}
	return [listEdge objectAtIndex:node.index];
}
-(double) getWeightOfEdgeBetweenNode:(GraphNode*) n1 andNode:(GraphNode*) n2{
	if ([listNode indexOfObject:n1]==NSNotFound) return -1;
	if (isMultiGraph) return -1;
	NSMutableArray* adjacentList = [listEdge objectAtIndex:n1.index];
	for (int i = 0; i<[adjacentList count]; i++)
	{
		GraphEdge* edge = [adjacentList objectAtIndex:i];
		if ([edge getDestinationNode] == n2)
		{
			return edge.weight;
		}
	}
	return -1;
}

-(GraphNode*) popNodeWithSmallestDistanceFromQueue: (NSMutableArray*) queue withDistanceArray: (double*) dist{
	if ([queue count] == 0) return nil;
	double minDist = INFINITY;
	GraphNode* node;
	for (int i = 0; i<[queue count]; i++) {
		GraphNode* tempNode = [queue objectAtIndex:i];
		if (dist[tempNode.index] < minDist) {
			minDist = dist[tempNode.index];
			node = tempNode;
		}
	}
	[node retain];
	[queue removeObject:node];
	return node;
}
-(void) getPathFrom: (GraphNode*) start to: (GraphNode*) goal withPathTrace:(NSArray*) tracePath formPath:(NSMutableArray*) path{
	GraphEdge* edge = [tracePath objectAtIndex: goal.index];
	if ([[edge getSourceNode] isEqual:start]) {
		[path addObject:edge];		
		return;
	}
	else {
		[self getPathFrom:start to:[edge getSourceNode] withPathTrace:tracePath formPath:path];
		[path addObject:edge];		
	}

}
-(NSArray*) dijkstraFrom: (GraphNode*) start to: (GraphNode*) goal{
	if ([start isEqual:goal]) {
		GraphEdge* edge = [GraphEdge EdgeWithNode:start andNode:start withWeight:0];
		NSArray* path = [NSArray arrayWithObject:edge];
		return path;
	}
	double dist[nextNodeIndex];
	NSMutableArray* tracePath = [[NSMutableArray alloc] initWithCapacity:nextNodeIndex];
	for (int i = 0; i<nextNodeIndex; i++) {
		dist[i] = INFINITY;
	}
	dist[start.index] = 0;
	NSMutableArray* queue = [[NSMutableArray alloc] init];
	[queue addObject:start];
	while ([queue count]!=0) {
		GraphNode* node = [self getNodeWithSmallestDistanceFromQueue: queue withDistanceArray: dist];
		if ([node isEqual:goal]) {
			break;
		}
		NSArray* adjacentList = [self getAdjacentNodes:node];
		for (int i = 0; i<[adjacentList count]; i++) {
			GraphEdge* tempEdge = [adjacentList objectAtIndex:i];
			GraphNode* tempNode = [tempEdge getDestinationNode];
			if (dist[node.index]+tempEdge.weight < dist[tempNode.index]) {
				dist[tempNode.index] = dist[node.index] + tempEdge.weight;
				[tracePath replaceObjectAtIndex:tempNode.index withObject:tempEdge];
			}
		}
	}
	[queue release];
	if (dist[goal.index] == INFINITY) {
		return nil;
	}
	NSMutableArray* path = [[NSMutableArray alloc] init];
	[self getPathFrom: (GraphNode*) start to: (GraphNode*) goal withPathTrace: tracePath formPath:path];
	return path;
}

-(NSArray*) getShortestPathFrom: (GraphNode*) start to:(GraphNode*) goal{
	return [self dijkstraFrom:start to:goal];
}


@end
