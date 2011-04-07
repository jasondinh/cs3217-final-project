    //
//  AnnoViewController.m
//  MallExplorer
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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
	return CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+self.view.frame.size.height+5, self.view.frame.size.width*3, 20);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) addGestureRecognizer{
	UITapGestureRecognizer* tapGesture	 = [[UITapGestureRecognizer alloc]
											initWithTarget:self action:@selector(togglePopUp:)];
	[tapGesture setNumberOfTapsRequired:1];
	[self.view addGestureRecognizer:tapGesture];
	[tapGesture release];
	
}

-(void) togglePopUp: (UIGestureRecognizer*) recognizer{
		if (!titleIsShown) {
			titleIsShown = YES;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"title is shown" object:self];
		}
}

-(AnnoViewController*) initWithAnnotation:(Annotation *)anno{
	[self release];
	self = [[AnnotationFactory createAnnotationViewWithAnnotation:anno] retain];
	[self addGestureRecognizer];
	return self;
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
    [super dealloc];
}


@end
