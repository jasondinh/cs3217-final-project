//
//  PriorityQueue.h
//  MallExplorer
//
//  Created by Tran Cong Hoang on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PQObject.h"

@interface PriorityQueue : NSObject {
	NSMutableArray* q;
}
// update position of the object at index, return new index;
- (int) updateObjectAtIndex:(int)index withNewValue:(double)newVal;
// add object to PQ, return index;
- (int) insertObject:(PQObject*)item;
- (PQObject*)getNextObject;
- (int) count;
@end
