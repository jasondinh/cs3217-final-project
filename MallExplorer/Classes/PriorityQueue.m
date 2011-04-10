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
    // Maintain heap-ness
    while(YES) {
		if (index == 0) {
			break;
		}
        if([[q objectAtIndex:index] value] > [[q objectAtIndex:((index - 1)/ 2)] value]) {
            [q exchangeObjectAtIndex:index withObjectAtIndex:((index - 1)/ 2)];
            index = (index - 1)/ 2;
        }
        else
            return index;
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
			if ([[q objectAtIndex:left] value] > [[q objectAtIndex:right] value]) {
				min = right;
			}
		}
		if ([[q objectAtIndex:i] value] > [[q objectAtIndex:min] value]) {
			[q exchangeObjectAtIndex:i withObjectAtIndex:min];
			i = min;
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
	[[q objectAtIndex:index] setValue:newVal];
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
