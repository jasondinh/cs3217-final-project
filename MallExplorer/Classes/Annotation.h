//
//  Annotation.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Annotation : NSObject {
	CGPoint position;
	NSString* title;
	NSString* content;
}
@property CGPoint position;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* content;
-(Annotation*) initWithPosition: (CGPoint) position title:(NSString*) title content: (NSString*) content;
@end
