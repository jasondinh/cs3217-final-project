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
+(Annotation*) annotationWithAnnotationType: (AnnotationType) annType inlevel:(Map*)lev WithPosition: (CGPoint) pos title:(NSString*) tit content: (NSString*) cont{
	Annotation* anAnnotation = [AnnotationFactory createAnnotationType:annType];
	if (!anAnnotation) return nil;
	anAnnotation.annoType = annType;	
	anAnnotation.level = lev;
	anAnnotation.isDisplayed = YES;
	anAnnotation.position = pos;
	anAnnotation.title = tit;
	anAnnotation.content = cont;
	return anAnnotation;
}
@end
