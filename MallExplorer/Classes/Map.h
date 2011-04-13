//
//  Map.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import <Foundation/Foundation.h>
#import "Annotation.h"
#import "Graph.h"
#import "MapPoint.h"
#import "Edge.h"
#import "Constant.h"

@interface Map : NSObject {
	NSMutableArray* annotationList;
	NSMutableArray* pointList;
	NSArray* edgeList;
//	NSMutableArray* sortedPointList;
	UIImage* imageMap;	
	Graph* graph;
	unsigned char* imageData ; // data of the image in bitmap format
	UIColor* passAbleColor;
	NSString* mapName;
	NSMutableArray* pathOnMap;
	CGPoint defaultCenterPoint;
//	NSTime* timer;
}

@property (nonatomic, retain) NSArray* annotationList;
@property (nonatomic, retain, readonly) UIImage* imageMap;
@property (nonatomic, retain) NSArray* pointList;
@property (nonatomic, retain) NSArray* edgeList;
@property (nonatomic, retain, readonly) NSString* mapName;
@property (nonatomic, retain) NSArray* pathOnMap;
@property CGPoint defaultCenterPoint;

-(void) addAnnotation: (Annotation*) annotation;
-(void) removeAnnotation: (Annotation*) annotation;
-(void) addPoint: (MapPoint*) point;

-(MapPoint*) getClosestMapPointToPosition:(CGPoint) pos;
-(MapPoint*) getClosestMapPointToAnnotation:(Annotation*) anno;

//-(Map*) init//MapName:(NSString*) mName withMapImage:(UIImage*) img annotationList:(NSArray*) annList pointList:(NSArray*) pointList edgeList:(NSArray*) edgeList defaultCenterPoint:(CGPoint) dfCenterPoint;

-(void) loadDataWithMapName:(NSString*) mName withMapImage:(UIImage*) img annotationList:(NSArray*) annList pointList:(NSArray*) pointList edgeList:(NSArray*) edgeList defaultCenterPoint:(CGPoint) dfCenterPoint;

-(Map*) initWithAnObject:(id) object;

// find path from a point to a point in the same level
-(NSArray*) findPathFrom:(MapPoint*) point1 to: (MapPoint*) point2;
-(NSArray*) findPathFromStartPosition:(CGPoint)startPos ToGoalPosition:(CGPoint) goalPos;
// find path from point1 to an item in category type: 
//-(NSArray*) findPathFrom:() point1 to: () type;
-(void) addPathOnMap:aPath;
-(void) resetPathOnMap;

-(NSArray*) refineAPath:(NSArray*) aPath;

-(BOOL) checkFreeAtPoint:(CGPoint) point;
-(BOOL) checkPositionInsideMap:(CGPoint) aPosition;



@end
