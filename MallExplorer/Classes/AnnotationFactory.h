//
//  AnnotationFactory.h
//  MallExplorer
//
//  Created by Tran Cong Hoang on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import <Foundation/Foundation.h>
#import "Annotation.h"
@class AnnoViewController;
@class AnnoShopViewController;
@class AnnoLiftViewController;
@class AnnoStairViewController;
@class AnnoPathPointViewController;
@class AnnoLevelConnectorViewController;
@class Annotation;
@class AnnotationLevelConnector;
//@class
@interface AnnotationFactory : NSObject {
}

// method to create an annotation view controller
+(AnnoViewController*) createAnnotationViewWithAnnotation:(Annotation*) annotation;
// method to create an annotation
+(Annotation*) createAnnotationType: (AnnotationType)annType;
@end
