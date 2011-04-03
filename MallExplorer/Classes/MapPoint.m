//
//  MapPoint.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapPoint.h"


@implementation MapPoint
@synthesize position;
@synthesize annotation;
@synthesize index;

-(MapPoint*) initWithPosition:(CGPoint) pos andIndex:(int) ind{
	self = [super init];
	if (self) {
		self.position = pos;
		self.index = ind;
	}
	return self;
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


@end
