//
//  Graph.m
//  ApplicationLibrary
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

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
			[tracePath release];
			return nil;
		}
		check[minPosNode] = YES;
		GraphNode* node = [listNode objectAtIndex:minPosNode];
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
	if (dist[goal.index] == INFINITY) {
		[tracePath release];
		return nil;
	}
	NSMutableArray* path = [[NSMutableArray alloc] init];
	[self getPathFrom: (GraphNode*) start to: (GraphNode*) goal withPathTrace: tracePath formPath:path];
	[tracePath release];
	return path;
}

-(NSArray*) dijkstraHeapFrom: (GraphNode*) start to: (GraphNode*) goal{
	if ([start isEqual:goal]) {
		NSArray* path = [NSArray arrayWithObject:start.object];
		return path;
	}
	
	PriorityQueue* q = [[PriorityQueue alloc] init];
	double dist[nextNodeIndex];
	BOOL check[nextNodeIndex];
	NSMutableArray* tracePath = [[NSMutableArray alloc] initWithCapacity:nextNodeIndex];
	
	for (int i = 0; i<nextNodeIndex; i++) {
		dist[i] = INFINITY;
		check[i] = NO;
		[tracePath addObject:[NSNull null]];
	}
	dist[start.index] = 0;
	
	NSMutableArray* pqListNode = [[NSMutableArray alloc] initWithCapacity:nextNodeIndex];
	for (int i = 0; i<nextNodeIndex; i++) {
		PQObject* pqObject = [[PQObject alloc] initWithObject:[listNode objectAtIndex:i] andValue:dist[i]];
		[pqListNode addObject:pqObject];
		[pqObject release];
	}
	[q insertObject:[pqListNode objectAtIndex:start.index]];
	while ([q count]>0) {
		GraphNode* node = [[q getNextObject] object];
		check[node.index] = YES;
		if ([node isEqual:goal]) {			
			break;
		}		
		NSArray* adjacentList = [self getAdjacentNodes:node];
		for (int i = 0; i<[adjacentList count]; i++) {
			GraphEdge* tempEdge = [adjacentList objectAtIndex:i];
			GraphNode* tempNode = [tempEdge getDestinationNode];
			
			if (!check[tempNode.index] && (dist[node.index]+tempEdge.weight < dist[tempNode.index])) {
				dist[tempNode.index] = dist[node.index] + tempEdge.weight;
				PQObject* aPQObject = [pqListNode objectAtIndex:tempNode.index];
				aPQObject.val = dist[tempNode.index];
				if (aPQObject.posInHeap == -1) {
					[q insertObject:aPQObject];
				} else {
					[q updateObjectAtIndex:aPQObject.posInHeap withNewValue:dist[tempNode.index]];
				}
				[tracePath replaceObjectAtIndex:tempNode.index withObject:tempEdge];
			}
		}
	}
	[q release];
	[pqListNode release];
	if (dist[goal.index] == INFINITY) {
		[tracePath release];
		return nil;
	}
	
	NSMutableArray* path = [[NSMutableArray alloc] init];
	[self getPathFrom: (GraphNode*) start to: (GraphNode*) goal withPathTrace: tracePath formPath:path];
	[tracePath release];
	return [path autorelease];
}

-(NSArray*) AStarHeapFrom: (GraphNode*) start to: (GraphNode*) goal usingEstimatingFunction:(SEL) selector{
	if ([start isEqual:goal]) {
		NSArray* path = [NSArray arrayWithObject:start.object];
		return path;
	}
	
	PriorityQueue* q = [[PriorityQueue alloc] init];
	double dist[nextNodeIndex];
	double h[nextNodeIndex];
	double f[nextNodeIndex];
	BOOL check[nextNodeIndex];
	NSMutableArray* tracePath = [[NSMutableArray alloc] initWithCapacity:nextNodeIndex];
	
	for (int i = 0; i<nextNodeIndex; i++) {
		dist[i] = INFINITY;
		f[i] = INFINITY;
		NSNumber* aValue = [[[listNode objectAtIndex:i] object] performSelector:selector withObject:goal.object];
		h[i] = [aValue doubleValue];
		check[i] = NO;
		[tracePath addObject:[NSNull null]];
	}
	dist[start.index] = 0;
	f[start.index] = h[start.index];
	
	NSMutableArray* pqListNode = [[NSMutableArray alloc] initWithCapacity:nextNodeIndex];
	for (int i = 0; i<nextNodeIndex; i++) {
		PQObject* pqObject = [[PQObject alloc] initWithObject:[listNode objectAtIndex:i] andValue:f[i]];
		[pqListNode addObject:pqObject];
		[pqObject release];
	}
	[q insertObject:[pqListNode objectAtIndex:start.index]];
	while ([q count]>0) {
		GraphNode* node = [[q getNextObject] object];
		check[node.index] = YES;
		if ([node isEqual:goal]) {			
			break;
		}
		NSArray* adjacentList = [self getAdjacentNodes:node];
		for (int i = 0; i<[adjacentList count]; i++) {
			GraphEdge* tempEdge = [adjacentList objectAtIndex:i];
			GraphNode* tempNode = [tempEdge getDestinationNode];
			
			if (!check[tempNode.index] && (dist[node.index]+tempEdge.weight < dist[tempNode.index])) {
				dist[tempNode.index] = dist[node.index] + tempEdge.weight;
				f[tempNode.index] = dist[tempNode.index] + h[tempNode.index];
				PQObject* aPQObject = [pqListNode objectAtIndex:tempNode.index];
				aPQObject.val = f[tempNode.index];
				if (aPQObject.posInHeap == -1) {
					[q insertObject:aPQObject];
				} else {
					[q updateObjectAtIndex:aPQObject.posInHeap withNewValue:f[tempNode.index]];
				}
				[tracePath replaceObjectAtIndex:tempNode.index withObject:tempEdge];
			}
		}
	}
	[q release];
	[pqListNode release];
	if (dist[goal.index] == INFINITY) {
		[tracePath release];
		return nil;
	}
	
	NSMutableArray* path = [[NSMutableArray alloc] init];
	[self getPathFrom: (GraphNode*) start to: (GraphNode*) goal withPathTrace: tracePath formPath:path];
	[tracePath release];
	return [path autorelease];
}



-(NSArray*) getShortestPathFrom: (GraphNode*) start to:(GraphNode*) goal{
	return [self dijkstraHeapFrom:start to:goal];
}

-(NSArray*) getShortestPathFromNodeWithIndex:(int) n1 toNodeWithIndex:(int) n2{
	return [self dijkstraHeapFrom:[listNode objectAtIndex:n1] to:[listNode objectAtIndex:n2]];
}

-(NSArray*) getShortestPathUsingAStarFrom: (id) obj1 toObject: (id) obj2 usingEstimatingFunction:(SEL) selector{
	GraphNode* node1 = [self getGraphNodeFromObject:obj1];
	GraphNode* node2 = [self getGraphNodeFromObject:obj2];	
	return [self AStarHeapFrom:node1 to:node2 usingEstimatingFunction:selector];
}


-(NSArray*) getShortestPathUsingAStarFromNodeWithIndex:(int) n1 toNodeWithIndex:(int) n2 usingEstimatingFunction:(SEL) selector{
	return [self AStarHeapFrom:[listNode objectAtIndex:n1] to:[listNode objectAtIndex:n2] usingEstimatingFunction:selector];
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
