//
//  Mall.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Map.h"
#import "MapPoint.h"
#import "Graph.h"
#import "Constant.h"

@interface Mall : NSObject <MKAnnotation> {
	NSInteger mId;
	NSString *name;
	NSString *longitude;
	NSString *latitude;
	NSString *address;
	NSInteger zip;
	NSInteger numberOfMaps;
	BOOL mapLoaded;
	// this list holds a set of maps
	NSMutableArray* mapList;
	// this list holds the "connecting points" that connect map to map
	// this list form a graph that is used for searching path between different levels
	NSMutableArray* mapPointList;
	Graph* mallGraph;
}

@property (retain) NSString *name;
@property (retain) NSString *longitude;
@property (retain) NSString *latitude;
@property (retain) NSString *address;
@property (retain) NSArray* mapList;
@property (retain) NSArray* mapPointList;
@property BOOL mapLoaded;

@property NSInteger mId;
@property NSInteger zip;
-(CLLocationCoordinate2D) coordinate;
- (id) initWithId: (NSInteger) mId  
		  andName: (NSString *) n 
	 andLongitude: (NSString *) lon 
	  andLatitude: (NSString *) lat
	   andAddress: (NSString *)a
		   andZip: (NSInteger) z;

//-(void) loadConnectingPointList:(NSArray *)pLists withEdgeList:(NSArray*) edgeLists;

//stair is an array of edge
-(void) buildGraphWithMaps: (NSArray*) mList andStairs:(NSArray*) edgeList;

- (NSString *)subtitle;
- (NSString *)title;

// find path between any two points in any two levels
-(NSArray*) findPathFrom:(CGPoint) point1 inLevel:(Map*)level1 to: (CGPoint) point2 inLevel:(Map*) level2;
-(NSArray*) findPathFromStartAnnotation:(Annotation*) anno1 ToGoalAnnotaion:(Annotation*) anno2;

// remove the path on all the maps
-(void) resetPath;

// data for shop list view controller
@property (retain) NSArray* mapNameList;

// load data functions

-(NSArray*)createPointListFromDictionary:(NSDictionary*) aPointList;
-(NSArray*)createMapFromDictionary:(NSDictionary*) aMap;
-(NSArray*)createMapListFromDictionary:(NSDictionary*) aMapList;
-(NSArray*)createAnnotationListFromDictionary:(NSDictionary*) anAnnoList; 
-(NSArray*)createEdgeListFromDictionary:(NSDictionary*) anEdgeList;
-(NSArray*)createStairListFromDictionary:(NSDictionary*) aStairList;



-(NSArray*) getAllShopFromThisMall;

@end
