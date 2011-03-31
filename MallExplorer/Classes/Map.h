//
//  Map.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Annotation.h"

@interface Map : NSObject {
	NSMutableArray* annotationList;
	UIImage* imageMap;
}

@property (nonatomic, retain) NSArray* annotationList;
@property (nonatomic, retain) UIImage* imageMap;
-(void) addAnnotation: (Annotation*) annotation;
-(Map*) initWithMapImage:(UIImage*) img annotationList:(NSArray*) annList;


@end
