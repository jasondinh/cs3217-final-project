//
//  Graph.h
//  ApplicationLibrary
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphNode.h"
#import "GraphEdge.h"
#import "PriorityQueue.h"
#import "PQObject.h"

@interface Graph : NSObject {
	NSMutableArray* listNode;
	NSMutableArray* listEdge;
	int nextNodeIndex;
	BOOL isBiDiGraph;
	BOOL isMultiGraph;
}
@property (nonatomic, retain) NSMutableArray* listNode;
@property (nonatomic, retain) NSMutableArray* listEdge;
@property BOOL isBiDiGraph;
@property BOOL isMultiGraph;
// add node method
-(int) addNode:(id) object;
-(void) addNode:(id) object withIndex:(int) index;

// add edge method
-(void) addEdgeBetweenNodeWithIndex:(int) n1 andNodeWithIndex:(int) n2 withWeight:(double) w;
-(void) addEdge:(id) obj1 andObject2:(id) obj2 withWeight:(double) w;

// getter methods
-(NSArray*) getAdjacentNodes:(GraphNode*) node;
-(NSArray*) getAdjacentNodesToNodeWithIndex:(int) index;
-(double) getWeightOfEdgeBetweenNode:(GraphNode*) n1 andNode:(GraphNode*) n2;
-(double) getWeightOfEdgeBetweenNodeWithIndex:(int) n1 andNodeWithIndex:(int) n2;
-(id) getGraphNodeFromObject:(id) object;

// path finding 
-(NSArray*) getShortestPathFrom: (GraphNode*) start to:(GraphNode*) goal;
-(NSArray*) getShortestPathFromNodeWithIndex:(int) n1 toNodeWithIndex:(int) n2;
-(NSArray*) getShortestPathFromObject: (id) obj1 toObject:(id) obj2;
-(NSArray*) getShortestPathUsingAStarFromNodeWithIndex:(int) n1 toNodeWithIndex:(int) n2 usingEstimatingFunction:(SEL) selector;
-(NSArray*) getShortestPathUsingAStarFrom: (id) obj1 toObject: (id) obj2 usingEstimatingFunction:(SEL) selector;
@end
