//
//  MapPoint.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapPoint.h"
static int nextNodeIndex = 0;

@implementation MapPoint
@synthesize position;
@synthesize annotation;
@synthesize index;
@synthesize level;

-(MapPoint*) initWithPosition:(CGPoint) pos inLevel:(Map*)map andIndex:(int) ind{
	self = [super init];
	if (self) {
		self.position = pos;
		self.index = nextNodeIndex++;
		self.level = map;
		//NSLog(@"id is %d", nextNodeIndex);
	}
	return self;
}

-(MapPoint*) initWithPosition:(CGPoint) pos andIndex:(int) ind{
	return [self initWithPosition:pos inLevel:nil andIndex:ind];
}

-(MapPoint*) initWithPosition:(CGPoint) pos{
//	nextNodeIndex++;
	return [self initWithPosition:pos andIndex:0];

}

+(double) getDistantBetweenPoint:(MapPoint*) p1 andPoint: (MapPoint*) p2{
	return sqrt((p1.position.x-p2.position.x)*(p1.position.x-p2.position.x) + (p1.position.y-p2.position.y)*(p1.position.y-p2.position.y));
}
+(double) getDistantBetweenPoint:(MapPoint*) p1 andCoordination: (CGPoint) p2{
	return sqrt((p1.position.x-p2.x)*(p1.position.x-p2.x) + (p1.position.y-p2.y)*(p1.position.y-p2.y));
}
+(double) getDistantBetweenCoordination:(CGPoint) p1 andCoordination: (CGPoint) p2{
	return sqrt((p1.x-p2.x)*(p1.x-p2.x) + (p1.y-p2.y)*(p1.y-p2.y));
}
-(BOOL) isEqual:(id)o{
	if (![o isMemberOfClass:[MapPoint class]]) {
		return NO;
	}
	MapPoint* obj = (MapPoint*) o;
	if (position.x == obj.position.x && position.y == obj.position.y && level == obj.level) {
		return YES;
	} else return NO;
}
// heuristic for A*
-(NSNumber*) estimateDistanceTo: (MapPoint*) p{
	return [NSNumber numberWithDouble:[MapPoint getDistantBetweenPoint:self andPoint:p]];
}

-(void) dealloc{
	[annotation release];
	[super dealloc];
}
@end
