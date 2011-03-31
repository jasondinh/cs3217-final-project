//
//  Graph.h
//  ApplicationLibrary
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"
#import "Edge.h"

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
-(int) addNode:(Node*) node;
-(BOOL) addEdge:(Edge*) edge;
-(NSArray*) getAdjacentNodes:(Node*) node;
-(double) getWeightOfEdgeBetweenNode:(Node*) n1 andNode:(Node*) n2;

@end
