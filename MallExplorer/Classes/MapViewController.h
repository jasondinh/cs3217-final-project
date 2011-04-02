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
@interface MapViewController : UIViewController {
	NSMutableArray* annotationList;
	Map* map;
	UIScrollView* displayArea;
	BOOL displayAllTitleMode;
	AnnoViewController* annoBeingSelected;
}

@property (nonatomic, retain) NSArray* annotationList;
@property (nonatomic, retain) Map* map;
@property BOOL displayAllTitleMode;
//@property (nonatomic, retain) UIImage* imageMap;

-(void) addAnnotation: (Annotation*) annotation;
-(MapViewController*) initWithMapImage:(UIImage*) img annotationList:(NSArray*) annList;
-(MapViewController*) initMall;
@end
