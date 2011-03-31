//
//  Edge.h
//  ApplicationLibrary
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface Edge : NSObject {
	Node* node1;
	Node* node2;
	double weight;
}
@property (nonatomic, retain) Node* node1;
@property (nonatomic, retain) Node* node2;
@property double weight;
-(Edge*) initEdgeWithNode:(Node*) n1 andNode:(Node*) n2 withWeight:(double) w;
+(Edge*) EdgeWithNode:(Node*) n1 andNode:(Node*) n2 withWeight:(double) w;
-(Node*) getSourceNode;
-(Node*) getDestinationNode;
@end
