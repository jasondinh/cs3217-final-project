//
//  AnnoViewController.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Annotation.h"

@interface AnnoViewController : UIViewController {
	Annotation* annotation;
}
@property (nonatomic, retain) Annotation* annotation;
-(AnnoViewController*) initWithAnnotation: (Annotation*) anno;
@end
