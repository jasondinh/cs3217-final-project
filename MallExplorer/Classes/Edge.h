//
//  Edge.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	kWalk,
	kTakeLift,
	kWalkStairCase
} TravelType;
@class MapPoint;
@interface Edge : NSObject {
	MapPoint* pointA;
	MapPoint* pointB;
	BOOL isBidirectional;
	double weight;
	TravelType travelType;
}
@property (nonatomic, retain) MapPoint* pointA;
@property (nonatomic, retain) MapPoint* pointB;
@property BOOL isBidirectional;
@property double weight;
@property TravelType travelType;
-(Edge*) initWithPoint1:(MapPoint*) pA point2:(MapPoint*) pB withLength:(double) weight isBidirectional:(BOOL) isBidi withTravelType:(TravelType) travelType;

-(Edge*) initWithPoint1:(MapPoint*) pA point2:(MapPoint*) pB;

-(Edge*) initWithPoint1:(MapPoint*) pA point2:(MapPoint*) pB withLength:(double) w;

@end
