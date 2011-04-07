//
//  MapPoint.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Map;
@class Annotation;
// a class represent the "skeleton point" of the map graph
@interface MapPoint : NSObject {
	int index;
	CGPoint position;
	// the annotation(if available) that is associated with this point;
	// this annotation is used for searching for an annotation of a given type (shop of a given type)
	Annotation* annotation; 
	Map* level;
}
@property CGPoint position;
@property int index;
@property (nonatomic, retain) Annotation* annotation;
@property (assign) Map* level;
-(MapPoint*) initWithPosition:(CGPoint)pos inLevel:(Map*)map andIndex:(int) ind;
+(double) getDistantBetweenPoint:(MapPoint*) p1 andPoint: (MapPoint*) p2;
+(double) getDistantBetweenPoint:(MapPoint*) p1 andCoordination: (CGPoint) p2;
+(double) getDistantBetweenCoordination:(CGPoint) p1 andCoordination: (CGPoint) p2;
@end
