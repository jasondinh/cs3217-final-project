//
//  GraphNode.h
//  ApplicationLibrary
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import <Foundation/Foundation.h>

@interface GraphNode : NSObject {
	int index;
	id object;
}
@property int index;
@property (nonatomic, retain) id object;
-(GraphNode*) initWithObject:(id)object andId:(int) ind;
-(BOOL) isEqual:(id)object;
@end
