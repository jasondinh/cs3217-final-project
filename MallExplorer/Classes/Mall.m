//
//  Mall.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import "Mall.h"

const int MAX_LEVEL_POSSIBLE = 10000;
@implementation Mall
@synthesize name, longitude, latitude, address, mId, zip;
@synthesize mapList;
@synthesize mapPointList;
@synthesize mapLoaded;
@synthesize defaultMap;
@synthesize travelTime;


-(BOOL) isEqual:(id)o{
	if (![o isMemberOfClass:[Mall class]]) {
		return NO;
	}
	Mall* obj = (Mall*) o;
	if (self.mId == obj.mId){
		return YES;
	} else return NO;
}


-(CLLocationCoordinate2D) coordinate{
	CLLocationCoordinate2D cor;
	cor.latitude = [latitude doubleValue];
	cor.longitude = [longitude doubleValue];
	return cor;
}
- (NSString *)subtitle{
	if (self.address !=nil) {
		return address;
	}
}
- (NSString *)title{
	return name;
}

- (id) initWithId: (NSInteger) _mId  
		  andName: (NSString *) n 
	 andLongitude: (NSString *) lon 
	  andLatitude: (NSString *) lat
	   andAddress: (NSString *)a
		   andZip: (NSInteger) z 
{
	
	self = [super init];
	
	if (self) {
		self.name = n;
		self.mId = _mId;
		self.longitude = lon;
		self.latitude = lat;
		self.address = a;
		self.zip = z;
		self.mapList = nil;
		mapList = nil;
		mapPointList = nil;
		mapLoaded = NO;
	}
	return self;
}

-(MapPoint*) addConnectingPoint:(MapPoint*) aPoint{
	int index = [mapPointList indexOfObject:aPoint];
	if (index == NSNotFound) {
		[mapPointList addObject:aPoint];
		[mallGraph addNode:aPoint];
		Map* aLevel = [mapList objectAtIndex:[mapList indexOfObject:aPoint.level]];
		[mallGraph addEdge:[mapPointList lastObject] andObject2: aLevel withWeight:MAX_LEVEL_POSSIBLE+100];
		[mallGraph addEdge:aLevel andObject2:[mapPointList lastObject]  withWeight:MAX_LEVEL_POSSIBLE+100];
		for ( int i = 0; i<[mapPointList count]; i++) {
			MapPoint* aMapPoint = [mapPointList objectAtIndex:i];
			if (![aMapPoint isEqual:aPoint] && [aMapPoint.level isEqual:aPoint.level]) {
				// later this function can change to accommodate the path between two stairs on a same level.
				// now that path is assumed to be of length 1
				[mallGraph addEdge:aMapPoint andObject2:aPoint withWeight:1];
			}
		}
		return [mapPointList lastObject];
	} else {
		return [mapPointList objectAtIndex:index];
	}

}

-(void) buildGraphWithMaps: (NSArray*) mList andStairs:(NSArray*) stairList{
	// building graph
	mallGraph = [[Graph alloc] init];
	mapList = [[NSMutableArray arrayWithArray:mList] retain];
	mapPointList = [[NSMutableArray alloc] init];
	 if (debug) NSLog(@"mall with: %d level", [mapList count]);
	 if (debug) NSLog(@"stair list with: %d", [stairList count]);
	for (int i = 0; i<[mapList count]; i++) {
		Map* aNode = [mapList objectAtIndex:i];
		[mallGraph addNode:aNode];
	}
	for (int i = 0; i<[stairList count]; i++) {
		Edge* anEdge = [stairList objectAtIndex: i];
		MapPoint* node1 = anEdge.pointA;
		node1 = [self addConnectingPoint:node1];
		MapPoint* node2 = anEdge.pointB;
		node2 = [self addConnectingPoint:node2];
		 if (debug) NSLog(@"%@ %@", node1.level.mapName, node2.level.mapName);
		[mallGraph addEdge:node1 andObject2:node2 withWeight:1];
		if (anEdge.isBidirectional) {
			[mallGraph addEdge:node2 andObject2:node1 withWeight:1];
		}
	}
	mapLoaded = YES;
}

-(void) resetData{
	[defaultMap release];
	defaultMap = nil;
	[mapList release];
	mapList = nil;
	[mapPointList release];
	mapPointList = nil;
	[mallGraph release];
	mallGraph = nil;
	mapLoaded = NO;
}

-(void)addMap:(Map*) aMap{
	
}

#pragma mark -
#pragma mark load data functions

// load data functions

-(NSArray*)createPointListFromDictionary:(NSDictionary*) aPointList{
	
}
-(NSArray*)createMapFromDictionary:(NSDictionary*) aMap{
	
}
-(NSArray*)createMapListFromDictionary:(NSDictionary*) aMapList{
	
}
-(NSArray*)createAnnotationListFromDictionary:(NSDictionary*) anAnnoList{
	
}
-(NSArray*)createEdgeListFromDictionary:(NSDictionary*) anEdgeList{
	
}
-(NSArray*)createStairListFromDictionary:(NSDictionary*) aStairList{
	
}

#pragma mark -

-(NSArray*) pathFindingBetween:(Map*) map1 and: (Map*) map2{
	return [mallGraph getShortestPathFromObject:map1 toObject:map2];
}

-(void) resetPath{
	for ( int i = 0; i<[mapList count]; i++) {
		[[mapList objectAtIndex:i] resetPathOnMap];
	}
}

-(NSArray*) findPathFrom:(CGPoint) startPos inLevel:(Map*)level1 to: (CGPoint)goalPos inLevel:(Map*) level2{
	// reset all the path now;
	 if (debug) NSLog(@"now finding path ------------------------------");
	[self resetPath];
	MapPoint* startPoint = [[MapPoint alloc] initWithPosition:startPos inLevel:level1  andIndex:0];
	MapPoint* goalPoint = [[MapPoint alloc] initWithPosition:goalPos inLevel:level2 andIndex:0];
	MapPoint* point1 = [level1 getClosestMapPointToPosition:startPos];
	MapPoint* point2 = [level2 getClosestMapPointToPosition:goalPos];
	NSArray* result;
	if ([level1 isEqual:level2]) {
		NSMutableArray* pathInLevel = [[NSMutableArray alloc] init];
		[pathInLevel addObject:startPoint];
		[pathInLevel addObjectsFromArray:[level1 findPathFrom:point1 to:point2]];
		[pathInLevel addObject:goalPoint];
		result = [[level1 refineAPath:pathInLevel] retain];
		travelTime = [level1 estimateTime: result];
		[startPoint release];
		[goalPoint release];	
		[level1 addPathOnMap: result];
		[pathInLevel release];
		return [result autorelease];
	}
	else {
		NSMutableArray* pathBetweenLevel = [NSMutableArray arrayWithArray:[mallGraph getShortestPathFromObject:level1 toObject: level2]];
		[pathBetweenLevel insertObject:startPoint atIndex:0];
		[pathBetweenLevel addObject:goalPoint];
		[startPoint release];
		[goalPoint release];
		travelTime = 0;
		for (int i = [pathBetweenLevel count]-1; i>=0; i--) {
			// the path between level is a mixed of map point and points that represent level.
			// so we need to clear all the points that represent levels before continuing
			if ([[pathBetweenLevel objectAtIndex:i] isMemberOfClass:[Map class]]) 
				[pathBetweenLevel removeObjectAtIndex:i];
		}
		for (int i = 0; i<[pathBetweenLevel count]-1; i++) {
			id p1 = [pathBetweenLevel objectAtIndex:i];
			id p2 = [pathBetweenLevel objectAtIndex:i+1];
			Map* lev1;
			Map* lev2;
			lev1 = [p1 level];
			lev2 = [p2 level];
			if ([lev1 isEqual:lev2]) {
				NSArray* aPath = [lev1 findPathFromStartPosition:[p1 position] ToGoalPosition:[p2 position]];
				travelTime += [lev1 estimateTime: aPath];
				[lev1 addPathOnMap:aPath];
			} else {
				travelTime += TIME_TRAVEL_PER_STAIR_IN_MINUTE;
			}

		}
		
//		[level1 addPathOnMap:[NSArray arrayWithObjects:startPoint, point1, nil]];
//		[level2 addPathOnMap:[NSArray arrayWithObjects:point2, goalPoint, nil]];
		result = pathBetweenLevel;
		
	}
	return [[result retain] autorelease];
}

-(NSArray*) findPathFromStartAnnotation:(Annotation*) anno1 ToGoalAnnotaion:(Annotation*) anno2{
	return [self findPathFrom:anno1.position inLevel:anno1.level to:anno2.position inLevel:anno2.level];
}

- (void) dealloc  {
	[name release];
	[latitude release];
	[longitude release];
	[address release];
	[mapList release];
	[mapPointList release];
	[super dealloc];
}
@end
