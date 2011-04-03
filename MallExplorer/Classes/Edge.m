//
//  Edge.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Edge.h"


@implementation Edge
@synthesize pointA;
@synthesize pointB;
@synthesize isBidirectional;
@synthesize weight;
@synthesize travelType;
-(Edge*) initWithPoint1:(MapPoint*) pA point2:(MapPoint*) pB withLength:(double) w isBidirectional:(BOOL) isBidi withTravelType:(TravelType) traType{
	self = [super init];
	if (self) {
		self.pointA = pA;
		self.pointB = pB;
		weight = w;
		isBidirectional = isBidi;
		travelType = traType;
	}
	return self;
}



@end
