//
//  Annotation.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import "Annotation.h"
#import "Map.h"
#import "Shop.h"
#import "AnnotationFactory.h"

@implementation Annotation
@synthesize annoType;
@synthesize position;
@synthesize title;
@synthesize content;
@synthesize isDisplayed;
@synthesize level;
@synthesize shop;
+(Annotation*) annotationWithAnnotationType: (AnnotationType) annType inlevel:(Map*)lev WithPosition: (CGPoint) pos title:(NSString*) tit content: (NSString*) cont{
	Annotation* anAnnotation = [[AnnotationFactory createAnnotationType:annType] retain];
	if (!anAnnotation) return nil;
	anAnnotation.annoType = annType;	
	anAnnotation.level = lev;
	anAnnotation.isDisplayed = YES;
	anAnnotation.position = pos;
	anAnnotation.title = tit;
	anAnnotation.content = cont;
	anAnnotation.shop = nil;
	return [anAnnotation autorelease];
}

-(BOOL) isEqual:(id)o{
	if (![o isKindOfClass:[Annotation class]]) {
		return NO;
	}
	Annotation* obj = (Annotation*) o;
	if ([self.level isEqual: obj.level] && (self.position.x == obj.position.x) && (self.position.y == obj.position.y) && (self.annoType == obj.annoType)){
		return YES;
	} else return NO;
}

-(void) dealloc{
	[level release];
	[shop release];
	[title release];
	[content release];
	[super dealloc];
}
@end
