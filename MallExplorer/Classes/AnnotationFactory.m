//
//  AnnotationFactory.m
//  MallExplorer
//
//  Created by Tran Cong Hoang on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import "AnnotationFactory.h"
#import "Annotation.h"
#import "AnnoViewController.h"

@implementation AnnotationFactory

+(AnnoViewController*) createAnnotationViewWithAnnotation:(Annotation*) annotation{
	switch (annotation.annoType) {
		case kAnnoStart:
//			Annotation* anAnno = [[Annotation alloc] init]
		case kAnnoGoal:
			return [[[AnnoPathPointViewController alloc]  initWithAnnotation:annotation] autorelease];
			break;
		case kAnnoShop:
			return [[[AnnoShopViewController alloc]  initWithAnnotation:annotation] autorelease];
			break;
		case kAnnoLift:
			return [[[AnnoLiftViewController alloc]  initWithAnnotation:annotation] autorelease];
			break;
		case kAnnoStair:
			return [[[AnnoStairViewController alloc]  initWithAnnotation:annotation] autorelease];
			break;
		case kAnnoConnector:
			return [[[AnnoLevelConnectorViewController alloc] initWithAnnotation: annotation] autorelease];
		default:
			break;
	}
	return nil;
}


+(Annotation*) createAnnotationType: (AnnotationType)annoType{
	switch (annoType) {
		case kAnnoStart:
		case kAnnoGoal:
		case kAnnoShop:
			return [[[Annotation alloc]  init] autorelease];
		case kAnnoLift:
		case kAnnoStair:
		case kAnnoConnector:
			return [[[AnnotationLevelConnector alloc] init] autorelease];
		default:
			break;
	}
	return nil;
}


@end
