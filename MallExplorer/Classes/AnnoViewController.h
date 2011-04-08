//
//  AnnoViewController.h
//  MallExplorer
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Annotation.h"
#import "AnnotationFactory.h"
#import "Constant.h"
@interface AnnoViewController : UIViewController {
	Annotation* annotation;
	BOOL titleIsShown;
	UIButton* titleButton;
	CGRect previousFrame; // the frame before anytime this annoview is moved 
}
@property (nonatomic, retain) Annotation* annotation;
@property (nonatomic, retain) UIButton* titleButton;
@property BOOL titleIsShown;
-(AnnoViewController*) initWithAnnotation: (Annotation*) anno;
-(CGRect) getAnnoTitleRect;
-(void) invalidatePosition;
@end
