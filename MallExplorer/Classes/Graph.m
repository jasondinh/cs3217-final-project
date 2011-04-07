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

-(Graph*) init{
	self = [super init];
	if (self) {
		listNode = [[NSMutableArray alloc ] init];
		listEdge = [[NSMutableArray alloc ] init];
		isBiDiGraph = YES;
		isMultiGraph = NO;
	}
	return self;
}
#pragma mark add node
-(int) addANode:(GraphNode*) node{
	[self addNode:node.object withIndex:nextNodeIndex];
	return nextNodeIndex-1;
}

-(int) addNode:(id) object{
	[self addNode:object withIndex: nextNodeIndex];
	return nextNodeIndex-1;
}


-(void) addNode:(id) object withIndex:(int) index{
	GraphNode* aNode = [[GraphNode alloc] initWithObject:object andId:index];
	NSMutableArray* adjacentList = [[NSMutableArray alloc] init];
	if (index == nextNodeIndex) {
		[listNode insertObject:aNode atIndex:nextNodeIndex];
		[listEdge addObject:adjacentList];
	} else if (index < nextNodeIndex){
			[listNode replaceObjectAtIndex:index withObject:aNode];
			[listEdge replaceObjectAtIndex:index withObject:adjacentList];
	} else if (index > nextNodeIndex) {
		for (int i = nextNodeIndex; i<index; i++) {
			[listNode addObject:[NSNull null]];
			NSMutableArray* anAdjacentList = [[NSMutableArray alloc] init];
			[listEdge addObject:anAdjacentList];
			[anAdjacentList release];
		}
		[listNode addObject: aNode];
		[listEdge addObject:adjacentList];
		nextNodeIndex = index;
	}
	[adjacentList release];
	[aNode release];
	nextNodeIndex++;
}

#pragma mark -
#pragma mark add edge

-(BOOL) addAnEdgeFromNode:(GraphNode*)n1 toNode:(GraphNode*) n2 withWeight:(double) w{
	NSMutableArray* adjacentList = [listEdge objectAtIndex:n1.index];
	GraphEdge* edge = [GraphEdge EdgeWithNode:n1 andNode:n2 withWeight:w];
	if (!isMultiGraph) {
		if ([adjacentList count]!=0 && [adjacentList indexOfObject:edge]!=NSNotFound) {
			return NO;
		}
	}
	[adjacentList addObject:edge];
	NSLog(@"point list with %d, adding %d to %d, making total adjacentedge list of %d", [listNode count], n1.index, n2.index, [adjacentList count]);

	return YES;
}

-(void) addEdgeBetweenNodeWithIndex:(int) n1 andNodeWithIndex:(int) n2 withWeight:(double) w{
	[self addAnEdgeFromNode:[listNode objectAtIndex:n1] toNode:[listNode objectAtIndex:n2] withWeight:w];
}

-(void) addEdge:(id) obj1 andObject2:(id) obj2 withWeight:(double) w{
	GraphNode* n1;
	GraphNode* n2;
	 for (int i = 0; i<nextNodeIndex; i++) {
		 if ([obj1 isEqual: [[listNode objectAtIndex:i] object]]) {
			 n1 = [listNode objectAtIndex:i];
			 break;
		 }
	 }
	for (int i = 0; i<nextNodeIndex; i++) {
		if ([obj2 isEqual: [[listNode objectAtIndex:i] object]]) {
			n2 = [listNode objectAtIndex:i];
			break;
		}
	}
	[self addAnEdgeFromNode:n1 toNode:n2 withWeight:w];
}


-(BOOL) addEdge:(GraphEdge*) edge{
	if (![self addAnEdgeFromNode: [edge getSourceNode] toNode:[edge getDestinationNode] withWeight: edge.weight]) return NO;
	if (isBiDiGraph) 
		if (![self addAnEdgeFromNode: [edge getDestinationNode] toNode: [edge getSourceNode] withWeight: edge.weight]) return NO;
	return YES;
}

#pragma mark -
#pragma mark getters

-(NSArray*) getAdjacentNodes:(GraphNode*) node{
	if ([listNode count]==0 || [listNode indexOfObject:node]==NSNotFound) {
		NSLog(@"not found");
		return nil;
	}
	return [listEdge objectAtIndex:node.index];
}

-(NSArray*) getAdjacentNodesToNodeWithIndex:(int) index{
	return [listEdge objectAtIndex:index];
}

-(double) getWeightOfEdgeBetweenNode:(GraphNode*) n1 andNode:(GraphNode*) n2{
	if ([listNode count]==0 || [listNode indexOfObject:n1]==NSNotFound) return -1;
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

-(double) getWeightOfEdgeBetweenNodeWithIndex:(int) n1 andNodeWithIndex:(int) n2{
	if (n1>=nextNodeIndex || n2>=nextNodeIndex) {
		return -1;
	}
	if (isMultiGraph) {
		return -1;
	}
	NSMutableArray* adjacentList = [listEdge objectAtIndex:n1];
	for (int i = 0; i<[adjacentList count]; i++)
	{
		GraphEdge* edge = [adjacentList objectAtIndex:i];
		if ([edge getDestinationNode].index == n2)
		{
			return edge.weight;
		}
	}
	return -1;
}


#pragma mark -
#pragma mark path finding

-(void) getPathFrom: (GraphNode*) start to: (GraphNode*) goal withPathTrace:(NSArray*) tracePath formPath:(NSMutableArray*) path{
	GraphEdge* edge = [tracePath objectAtIndex: goal.index];
	if ([[edge getSourceNode] isEqual:start]) {
		[path addObject:[edge getSourceNode].object];		
		[path addObject:[edge getDestinationNode].object];		
		return;
	}
	else {
		[self getPathFrom:start to:[edge getSourceNode] withPathTrace:tracePath formPath:path];
		[path addObject:[edge getDestinationNode].object];		
	}
	
}

-(int) getNodeWithSmallestDistanceWithDistanceArray: (double*) dist andCheckArray:(BOOL*) check{
	double minDist = INFINITY;
	int minPos = -1;
	for (int i = 0; i<nextNodeIndex; i++) if (!check[i])
	{
		if (dist[i] < minDist) {
			minDist = dist[i];
			minPos = i;
		}
	}
	return minPos;
}

-(GraphNode*) getGraphNodeFromObject:(id) object{
	for (int i = 0; i<[listNode count]; i++) {
		GraphNode* aNode = [listNode objectAtIndex:i];
		if (aNode.object == object) {
			return aNode;
		}
	}
	return nil;
}

-(NSArray*) dijkstraFrom: (GraphNode*) start to: (GraphNode*) goal{
	if ([start isEqual:goal]) {
		NSArray* path = [NSArray arrayWithObject:start.object];
		return path;
	}
	
	double dist[nextNodeIndex];
	BOOL check[nextNodeIndex];
	NSMutableArray* tracePath = [[NSMutableArray alloc] initWithCapacity:nextNodeIndex];
	
	for (int i = 0; i<nextNodeIndex; i++) {
		dist[i] = INFINITY;
		check[i] = NO;
		[tracePath addObject:[NSNull null]];
	}
	dist[start.index] = 0;
	while (YES) {
		int minPosNode = [self getNodeWithSmallestDistanceWithDistanceArray: dist andCheckArray:check];
		if (minPosNode == -1) {
			return nil;
		}
		check[minPosNode] = YES;
		GraphNode* node = [listNode objectAtIndex:minPosNode];
		if ([node isEqual:goal]) {
			break;
		}
		NSLog(@"Node %d has distance from start: %d", node.index, dist[node.index]);
		NSArray* adjacentList = [self getAdjacentNodes:node];
		NSLog(@"number of adjacent node: %d", [adjacentList count]);
		for (int i = 0; i<[adjacentList count]; i++) {
			GraphEdge* tempEdge = [adjacentList objectAtIndex:i];
			GraphNode* tempNode = [tempEdge getDestinationNode];
			NSLog(@"node %d with distance %lf, edge with Weight: %lf", tempNode.index, dist[tempNode.index], tempEdge.weight);
			if (dist[node.index]+tempEdge.weight < dist[tempNode.index]) {
				dist[tempNode.index] = dist[node.index] + tempEdge.weight;
				[tracePath replaceObjectAtIndex:tempNode.index withObject:tempEdge];
			}
		}
	}
	for (int i = 0; i<nextNodeIndex; i++) {
		NSLog(@"dist %d is %d",i, dist[i] );
	}
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

-(NSArray*) getShortestPathFromNodeWithIndex:(int) n1 toNodeWithIndex:(int) n2{
//	NSLog(@"get Shortest path from %d to %d", n1, n2);
//	for (int i = 0; i<[listNode count]; i++) {
////		NSLog(@" object %d, with index: %d, coordination %lf %lf", i, [[listNode objectAtIndex:i] index], [[[[listNode objectAtIndex:i] object ] position ]x],[[[[listNode objectAtIndex:i] object ] position ]y]);
//		NSArray* adjacentList = [listEdge objectAtIndex:i];
//		NSLog(@" adjacent to %d is: %d", i, [adjacentList count]);
//		for (int i = 0; i<[adjacentList count]; i++) {
//			GraphEdge* anEdge = [adjacentList objectAtIndex:i];
//			NSLog(@"connect to %d with weight %lf", [anEdge getDestinationNode].index, [anEdge weight]);
//		}
//		
//	}
	NSArray* result = [self dijkstraFrom:[listNode objectAtIndex:n1] to:[listNode objectAtIndex:n2]];
//	NSLog(@"the found path: ");
//	for (int i = 0; i<[result count]; i++) {
//		NSLog(@"%d", [[result objectAtIndex:i] index]);
//	}
	return result;
}

-(NSArray*) getShortestPathFromObject: (id) obj1 toObject:(id) obj2{
	GraphNode* node1 = [self getGraphNodeFromObject:obj1];
	GraphNode* node2 = [self getGraphNodeFromObject:obj2];	
	return [self getShortestPathFrom:node1 to:node2];
	
}

-(void) dealloc{
	[listNode release];
	[listEdge release];
	[super dealloc];
}

@end
