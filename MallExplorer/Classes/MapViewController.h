//
//  MapViewController.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnoViewController.h"
#import "Annotation.h"
#import "Map.h"
@interface MapViewController : UIViewController {
	NSMutableArray* annotationList;
	Map* map;
	UIScrollView* displayArea;
}

@property (nonatomic, retain) NSArray* annotationList;
@property (nonatomic, retain) Map* map;
//@property (nonatomic, retain) UIImage* imageMap;

-(void) addAnnotation: (Annotation*) annotation;
-(MapViewController*) initWithMapImage:(UIImage*) img annotationList:(NSArray*) annList;

@end
