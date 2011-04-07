//
//  Annotation.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"Shop.h"
#import "MapPoint.h"

@class Map;
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
}
@property AnnotationType annoType;
@property CGPoint position;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* content;
@property (nonatomic, retain) Map* level;
@property BOOL isDisplayed;
-(Annotation*) initAnnotationType: (AnnotationType) annType inlevel:(Map*)level WithPosition: (CGPoint) position title:(NSString*) title content: (NSString*) content;
@end
