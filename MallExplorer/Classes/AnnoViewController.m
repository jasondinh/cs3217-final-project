    //
//  AnnoViewController.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnnoViewController.h"


@implementation AnnoViewController

@synthesize annotation;

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
	NSLog(@"adding tooltip");
	
	 UIButton* buttonLabel = [[UIButton alloc] initWithFrame:CGRectMake(0,35,100,20)];
	 [buttonLabel setTitle:annotation.title forState:UIControlStateNormal];
	//buttonLabel.backgroundColor = [UIColor greenColor];
	 [self.view addSubview:buttonLabel];
	
}

-(AnnoViewController*) initWithAnnotation:(Annotation *)anno{
	self = [super init];
	if (!self) return nil;
	self.annotation = anno;
	UIImage* image = [UIImage imageNamed:@"icon_shop.png"];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = CGRectMake(0, 0, 30, 30);	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
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
