    //
//  AnnoStairViewController.m
//  MallExplorer
//
//  Created by Tran Cong Hoang on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnnoStairViewController.h"


@implementation AnnoStairViewController

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

-(AnnoStairViewController*) initWithAnnotation:(AnnotationLevelConnector *)anno{
	self = [super init];
	if (!self) return nil;
	self.annotation = anno;
	NSString* imageName = [NSString stringWithString:@"icon_stair.png"];
	UIImage* image = [UIImage imageNamed:imageName];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
	imageView.frame = CGRectMake(0, 0, 30, 30);	
	self.view = [[UIView alloc] initWithFrame:imageView.frame];
	//self.view.backgroundColor = [UIColor redColor];
	[self.view addSubview: imageView];
	[imageView release];
	return self;
}

-(void) addGestureRecognizer{
	[super addGestureRecognizer];
	UITapGestureRecognizer* tapGesture	 = [[UITapGestureRecognizer alloc]
											initWithTarget:self action:@selector(stairChosen:)];
	[tapGesture setNumberOfTapsRequired:2];
	[self.view addGestureRecognizer:tapGesture];
	[tapGesture release];
	
}

-(void) stairChosen:(UIGestureRecognizer*) gesture{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"move to destination of a stair" object:self];
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
