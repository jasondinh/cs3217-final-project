//
//  MapViewController.h
//  MallExplorer
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.


#import <UIKit/UIKit.h>
#import "AnnoViewController.h"
#import "Annotation.h"
#import "Map.h"
#import "LineEdgeView.h"
@interface MapViewController : UIViewController<UIScrollViewDelegate> {
	NSMutableArray* annotationList;
	NSMutableArray* edgeDisplayedList;
	Map* map;
	CGSize mapSize;
	CGPoint mapCenterPoint;
	UIScrollView* displayArea;
	BOOL displayAllTitleMode;
	AnnoViewController* annoBeingSelected;
	double zoomScale, maxScale, minScale;
	UIImageView* imageView;
}

@property (nonatomic, retain) NSArray* annotationList;
@property (nonatomic, retain) Map* map;

@property BOOL displayAllTitleMode;
//@property (nonatomic, retain) UIImage* imageMap;

-(void) addAnnotation: (Annotation*) annotation;
-(MapViewController*) initWithMapImage:(UIImage*)img 
				withDefaultCenterPoint:(CGPoint)defaultPoint
					withAnnotationList:(NSArray*) annList
							 pointList:(NSArray*) pointList
							  edgeList:(NSArray*) edgeList;
-(MapViewController*) initMallWithFrame: (CGRect) aFrame;
-(void) toggleDisplayText;
-(NSArray*) findPathFromStartPosition:(CGPoint)startPos ToGoalPosition:(CGPoint) goalPos;
-(NSArray*) findPathFromStartAnnotation:(Annotation*)start ToGoalAnnotaion:(Annotation*) goal;
// find path from point1 to an item in category type: 
//-(NSArray*) findPathFrom:() point1 to: () type;
@end
