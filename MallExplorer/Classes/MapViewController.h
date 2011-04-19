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
#import "Constant.h"
//#import "AnnotationFactory.h"
@interface MapViewController : UIViewController<UIScrollViewDelegate> {
	NSMutableArray* annotationList;
	NSMutableArray* edgeDisplayedList;
	Map* map;
	CGSize mapSize;
	CGPoint mapCenterPoint;
	UIScrollView* displayArea;
	AnnoViewController* annoBeingSelected;
	double zoomScale, maxScale, minScale;
	UIImageView* imageView;
	NSTimer* theTimer;
}

@property (nonatomic, retain) NSArray* annotationList;
@property (nonatomic, retain) Map* map;

//@property (nonatomic, retain) UIImage* imageMap;

+(CGRect) getSuitableFrame;

// add an annotation to the map, at the position based on scrollview coordination
-(AnnoViewController*) addAnnotationType:(AnnotationType) annType ToScrollViewAtPosition:(CGPoint)pos withTitle:(NSString*) title withContent:(NSString*) content ;

// add an annotation to the map, since this is the model, the annotation's position is in map's coordination
-(void) addAnnotation: (Annotation*) annotation;
// remove annotations
-(void) removeAllLevelConnectorAnnotation;
-(void) removeAllAnnotationOfType:(AnnotationType)typeToRemove;
-(void) removeAnnotation:(Annotation*) annotation;

-(MapViewController*) initWithMapImage:(UIImage*)img 
				withDefaultCenterPoint:(CGPoint)defaultPoint
					withAnnotationList:(NSArray*) annList
							 pointList:(NSArray*) pointList
							  edgeList:(NSArray*) edgeList;
-(MapViewController*) initMallWithFrame: (CGRect) aFrame;
-(MapViewController*) initMallWithFrame: (CGRect) aFrame andMap:(Map*) aMap;

-(void) toggleDisplayText;
// startPos and goalPos is the position on scrollView coordination
-(NSArray*) findPathFromStartPosition:(CGPoint)startPos ToGoalPosition:(CGPoint) goalPos;

// annotation - model's position is the map coordination
-(NSArray*) findPathFromStartAnnotation:(Annotation*)start ToGoalAnnotaion:(Annotation*) goal;
// find path from point1 to an item in category type: 
//-(NSArray*) findPathFrom:() point1 to: () type;

// focusing support methods
-(void) focusToAMapPosition:(CGPoint) point;
-(void) focusToAScrollViewPosition:(CGPoint) point;

-(void) redisplayPath;
@end
