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

typedef enum {
	kAnnoShop,
 	kAnnoStart,
	kAnnoGoal
} AnnotationType;

@interface Annotation : NSObject {
	CGPoint position;
	NSString* title;
	NSString* content;
	BOOL isDisplayed;
	AnnotationType annoType;
	MapPoint* thePoint;
}
@property AnnotationType annoType;
@property CGPoint position;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* content;
@property BOOL isDisplayed;
-(Annotation*) initAnnotationType: (AnnotationType) annType WithPosition: (CGPoint) position title:(NSString*) title content: (NSString*) content;
@end
