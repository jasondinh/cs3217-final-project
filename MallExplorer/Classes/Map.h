//
//  Map.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Annotation.h"
#import "Graph.h"
#import "MapPoint.h"
#import "Edge.h"
@interface Map : NSObject {
	NSMutableArray* annotationList;
	NSMutableArray* pointList;
//	NSMutableArray* sortedPointList;
	UIImage* imageMap;	
	Graph* graph;
}

@property (nonatomic, retain) NSArray* annotationList;
@property (nonatomic, retain) UIImage* imageMap;
@property (nonatomic, retain) NSArray* pointList;
-(void) addAnnotation: (Annotation*) annotation;
-(void) addPoint: (MapPoint*) point;

-(MapPoint*) getClosestMapPointToPosition:(CGPoint) pos;
-(MapPoint*) getClosestMapPointToAnnotation:(Annotation*) anno;

-(Map*) initWithMapImage:(UIImage*) img annotationList:(NSArray*) annList pointList:(NSArray*) pointList edgeList:(NSArray*) edgeList;
-(NSArray*) findPathFrom:(MapPoint*) point1 to: (MapPoint*) point2;
// find path from point1 to an item in category type: 
//-(NSArray*) findPathFrom:() point1 to: () type;

@end
