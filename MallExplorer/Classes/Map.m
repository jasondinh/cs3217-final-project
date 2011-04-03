//
//  Map.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Map.h"


@implementation Map

@synthesize annotationList;
@synthesize pointList;

@synthesize imageMap;
-(void) addAnnotation: (Annotation*) annotation{
	[annotationList addObject:annotation];
}
-(void) addPoint: (MapPoint*) aPoint{
	[pointList addObject:aPoint];
}
-(Map*) initWithMapImage:(UIImage*) img annotationList:(NSArray*) annList pointList:(NSArray*) pList edgeList:(NSArray*) edgeList{
	self = [super init];
	if (!self) return nil;
	self.imageMap = img;
	self.annotationList = [[NSMutableArray arrayWithArray:annList] retain];
	self.pointList = [[NSMutableArray arrayWithArray:pList] retain];

	// building graph
	graph = [[Graph alloc] init];
	NSLog(@"point list with: %d", [pointList count]);
	NSLog(@"edge list with: %d", [edgeList count]);
	for (int i = 0; i<[pointList count]; i++) {
		MapPoint* aNode = [pointList objectAtIndex:i];
		[graph addNode:aNode withIndex:aNode.index];
	}
	for (int i = 0; i<[edgeList count]; i++) {
		Edge* anEdge = [edgeList objectAtIndex: i];
		MapPoint* node1 = anEdge.pointA;
		MapPoint* node2 = anEdge.pointB;
		[graph addEdgeBetweenNodeWithIndex:node1.index andNodeWithIndex:node2.index withWeight:anEdge.weight];
		if (anEdge.isBidirectional) {
			[graph addEdgeBetweenNodeWithIndex:node2.index andNodeWithIndex:node1.index withWeight:anEdge.weight];
		}
	}
	
	return self;
}

-(NSArray*) findPathFrom:(MapPoint*) point1 to: (MapPoint*) point2{
	return [graph getShortestPathFromNodeWithIndex:point1.index toNodeWithIndex:point2.index];
}

-(MapPoint*) getClosestMapPointToPosition:(CGPoint) pos{
	double minDist = INFINITY;
	int minPos = 0;
	for (int i = 0; i<[pointList count]; i++) {
		double dis = [MapPoint getDistantBetweenPoint:[pointList objectAtIndex:i]  andCoordination:pos];
		if (dis<minDist) {
			minDist = dis;
			minPos = i;
		}
	}
	return [pointList objectAtIndex:minPos];
}
-(MapPoint*) getClosestMapPointToAnnotation:(Annotation*) anno{
	return [self getClosestMapPointToPosition:anno.position];
}

-(void) dealloc{
	[imageMap release];
	[pointList release];
	[annotationList release];
	[graph release];
	[super dealloc];
}
@end
