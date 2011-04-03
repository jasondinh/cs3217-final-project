//
//  Annotation.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"


@implementation Annotation
@synthesize annoType;
@synthesize position;
@synthesize title;
@synthesize content;
@synthesize isDisplayed;
-(Annotation*) initAnnotationType: (AnnotationType) annType WithPosition: (CGPoint) pos title:(NSString*) tit content: (NSString*) cont{
	self = [super init];
	self.annoType = annType;
	/*switch (annoType) {
		case kAnnoShop:
			self = nil;
			self = [[Shop alloc] init];
			break;
		case kAnnoPoint:			
			self = nil;
			self = [[MapPoint alloc] init];
			break;
		default:
			break;
	}*/
	if (!self) return nil;
	self.isDisplayed = YES;
	self.position = pos;
	self.title = tit;
	self.content = cont;
	return self;
}
@end
