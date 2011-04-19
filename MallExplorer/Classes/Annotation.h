//
//  Annotation.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import <Foundation/Foundation.h>
#import "MapPoint.h"

@class Map;
@class Shop;
typedef enum {
	kAnnoShop,
 	kAnnoStart,
	kAnnoGoal,
	kAnnoStair,
	kAnnoLift,
	kAnnoConnector
} AnnotationType;

@interface Annotation : NSObject {
	CGPoint position;
	NSString* title;
	NSString* content;
	BOOL isDisplayed;
	AnnotationType annoType;
	MapPoint* thePoint;
	Map* level;
	Shop* shop;
}
@property AnnotationType annoType;
@property CGPoint position;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* content;
@property (retain) Map* level;
@property (retain) Shop* shop;
@property BOOL isDisplayed;
+(Annotation*) annotationWithAnnotationType: (AnnotationType) annType inlevel:(Map*)level WithPosition: (CGPoint) position title:(NSString*) title content: (NSString*) content;
@end
