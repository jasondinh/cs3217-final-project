//
//  Annotation.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"


@implementation Annotation
@synthesize position;
@synthesize title;
@synthesize content;
-(Annotation*) initWithPosition: (CGPoint) pos title:(NSString*) tit content: (NSString*) cont{
	self = [super init];
	if (!self) return nil;
	self.position = pos;
	self.title = tit;
	self.content = cont;
	return self;
}
@end
