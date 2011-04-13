//
//  PriorityQueue.m
//  MallExplorer
//
//  Created by Tran Cong Hoang on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PriorityQueue.h"


@implementation PriorityQueue
-(id)init
{
    self = [super init];
	if (self) {
		q = [[NSMutableArray alloc] init];
	}
    return self;
}

-(int) findSuitablePositionForObjectAtIndex:(int) index{
    // Maintain heap-ness - the root node is the min.
    while(YES) {
		if (index == 0) {
			return 0;
		}
        if([[q objectAtIndex:index] val] < [[q objectAtIndex:((index - 1)/ 2)] val]) {
            [q exchangeObjectAtIndex:index withObjectAtIndex:((index - 1)/ 2)];
			[[q objectAtIndex:(index-1)/2] setPosInHeap:index];
            index = (index - 1)/ 2;
        }
        else
		{
			[[q objectAtIndex:index] setPosInHeap:index];
            return index;
		}
    }
}

- (int)insertObject:(PQObject*)item
{
    [q addObject:item];
    return [self findSuitablePositionForObjectAtIndex:[q count]-1];    
}

- (void)heapify:(int) index;
{
	if ([q count] == 0) {
		return;
	}
	
    int max_index = [q count] - 1;
    int i = index;
	
	while (i<[q count]) {
		int left = 2 * i + 1 , right = 2 * i +2;
		if (left > max_index) break; 
		int min = left;
		if (right<=max_index) {
			// take the smaller of the two
			if ([[q objectAtIndex:left] val] > [[q objectAtIndex:right] val]) {
				min = right;
			}
		}
		if ([[q objectAtIndex:i] val] > [[q objectAtIndex:min] val]) {
			[q exchangeObjectAtIndex:i withObjectAtIndex:min];
			[[q objectAtIndex:min] setPosInHeap:i];
			i = min;
		} else {
			[[q objectAtIndex:i] setPosInHeap:i];
			break;
		}

	}
}


- (PQObject*)getNextObject
{
	if ([q count] == 0) {
		return nil;
	}
    // Exchange the first element with the last element to save
    // the cost of moving them all forward and then re-heaping it
    PQObject *obj = [[q objectAtIndex:0] retain];
    if ([q count] > 1) {
		[q exchangeObjectAtIndex:0 withObjectAtIndex:[q count]-1];		
	}
    [q removeLastObject];
	
    [self heapify:0];
    return [obj autorelease];
}

-(int) updateObjectAtIndex:(int)index withNewValue:(double)newVal{
	[[q objectAtIndex:index] setVal:newVal];
	return [self findSuitablePositionForObjectAtIndex:index];
}

- (int) count{
	return [q count];
}

-(void) dealloc{
	[q release];
	[super dealloc];
}
@end
