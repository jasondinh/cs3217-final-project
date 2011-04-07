//
//  Annotation.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"
#import "Map.h"
#import "AnnotationFactory.h"

@implementation Annotation
@synthesize annoType;
@synthesize position;
@synthesize title;
@synthesize content;
@synthesize isDisplayed;
@synthesize level;
-(Annotation*) initAnnotationType: (AnnotationType) annType inlevel:(Map*)lev WithPosition: (CGPoint) pos title:(NSString*) tit content: (NSString*) cont{
	[self release];
	self = [[AnnotationFactory createAnnotationType:annType] retain];
	self.annoType = annType;
	if (!self) return nil;
	self.level = lev;
	self.isDisplayed = YES;
	self.position = pos;
	self.title = tit;
	self.content = cont;
	return self;
}
@end
