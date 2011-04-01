//
//  Map.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Map.h"


@implementation Map

@synthesize annotationList;
@synthesize imageMap;
-(void) addAnnotation: (Annotation*) annotation{
	[annotationList addObject:annotation];
}
-(Map*) initWithMapImage:(UIImage*) img annotationList:(NSArray*) annList{
	self = [super init];
	if (!self) return nil;
	self.imageMap = img;
	self.annotationList = annList;
	return self;
}
-(void) dealloc{
	[imageMap release];
	[annotationList release];
	[super dealloc];
}
@end
