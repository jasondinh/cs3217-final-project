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
-(void) addNode:(id) object;
-(void) addEdge:(id) obj1 andObject2:(id) obj2 withWeight:(double) w;
-(NSArray*) getAdjacentNodes:(GraphNode*) node;
-(double) getWeightOfEdgeBetweenNode:(GraphNode*) n1 andNode:(GraphNode*) n2;
-(NSArray*) getShortestPathFrom: (GraphNode*) start to:(GraphNode*) goal;
@end
