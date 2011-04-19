//
//  AnnotationLevelConnector.h
//  MallExplorer
//
//  Created by Tran Cong Hoang on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import <Foundation/Foundation.h>
#import "Annotation.h"
#import "Map.h"
@interface AnnotationLevelConnector : Annotation {
	Map* destination;
	BOOL isDepartingConnector;
	BOOL isUp;
}
@property (nonatomic, retain) Map* destination;
@property BOOL isDepartingConnector;
@property BOOL isUp;
@end
