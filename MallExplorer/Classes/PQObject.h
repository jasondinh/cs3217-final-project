//
//  PQObject.h
//  MallExplorer
//
//  Created by Tran Cong Hoang on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import <Foundation/Foundation.h>


@interface PQObject : NSObject {
	id object;
	double val;
}
@property (assign) id object;
@property (assign) double val;
@property (assign) int posInHeap;
-(PQObject*) initWithObject:(id) object andValue:(double) value;
@end
