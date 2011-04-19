    //
//  AnnoViewController.m
//  MallExplorer
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import "AnnoViewController.h"

@implementation AnnoViewController

@synthesize annotation;
@synthesize titleIsShown;
@synthesize titleButton;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

-(CGRect) getAnnoTitleRect{
	int length = self.annotation.title.length;
	return CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+ANNOTATION_VIEW_HEIGHT, length*LENGTH_PER_CHARACTER, CAPTION_HEIGHT);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) addGestureRecognizer{
	UITapGestureRecognizer* tapGesture	 = [[UITapGestureRecognizer alloc]
											initWithTarget:self action:@selector(annotationViewTapped:)];
	[tapGesture setNumberOfTapsRequired:1];
	[self.view addGestureRecognizer:tapGesture];
	[tapGesture release];
	
}

-(void) annotationViewTapped: (UIGestureRecognizer*) recognizer{
		if (!titleIsShown) {
			titleIsShown = YES;
			titleButton.hidden = NO;
		} else {
			titleIsShown = NO;
			titleButton.hidden = YES;
		}

}

+(AnnoViewController*) annoViewControllerWithAnnotation:(Annotation *)anno{
	AnnoViewController* anAVC = [[AnnotationFactory createAnnotationViewWithAnnotation:anno] retain];
	[anAVC addGestureRecognizer];
	return [anAVC autorelease];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[titleButton release];
    [super dealloc];
}


@end
