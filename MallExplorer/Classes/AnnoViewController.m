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
	
	UIPanGestureRecognizer* panGesture	 = [[UIPanGestureRecognizer alloc]
											initWithTarget:self action:@selector(testAction:)];
	[self.view addGestureRecognizer:panGesture];
	[panGesture release];
	
}

-(void) testAction: (UIGestureRecognizer*) recognizer{
	
}

-(void) togglePopUp: (UIGestureRecognizer*) recognizer{
		if (!titleIsShown) {
			titleIsShown = YES;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"title is shown" object:self];
		}
}

-(AnnoViewController*) initWithAnnotation:(Annotation *)anno{
	self = [super init];
	if (!self) return nil;
	self.annotation = anno;
	NSString* imageName = [[NSString alloc] init];
	switch (anno.annoType) {
		case kAnnoShop:
			imageName = @"icon_shop.png";
			break;
		case kAnnoStart:
			imageName = @"green_flag_icon.png";
			break;
		case kAnnoGoal:
			imageName = @"red_flag_icon.png";
			break;

		default:
			break;
	}
	UIImage* image = [UIImage imageNamed:imageName];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = CGRectMake(0, 0, 30, 30);	
	self.view = [[UIView alloc] initWithFrame:imageView.frame];
	//self.view.backgroundColor = [UIColor redColor];
	[self.view addSubview: imageView];
	[image release];
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
