//
//  PQObject.h
//  MallExplorer
//
//  Created by Tran Cong Hoang on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PQObject : NSObject {
	id object;
	double value;
}
@property (assign) id object;
@property (assign) double value;
-(PQObject*) initWithObject:(id) object andValue:(double) value;
@end
