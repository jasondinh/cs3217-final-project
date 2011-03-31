//
//  GraphEdge.h
//  ApplicationLibrary
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphNode.h"

@interface GraphEdge : NSObject {
	GraphNode* node1;
	GraphNode* node2;
	double weight;
}
@property (nonatomic, retain) GraphNode* node1;
@property (nonatomic, retain) GraphNode* node2;
@property double weight;
-(GraphEdge*) initEdgeWithNode:(GraphNode*) n1 andNode:(GraphNode*) n2 withWeight:(double) w;
+(GraphEdge*) EdgeWithNode:(GraphNode*) n1 andNode:(GraphNode*) n2 withWeight:(double) w;
-(GraphNode*) getSourceNode;
-(GraphNode*) getDestinationNode;
@end
