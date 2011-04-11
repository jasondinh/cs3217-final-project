    //
//  AnnoPathPointViewController.m
//  MallExplorer
//
//  Created by Tran Cong Hoang on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnnoPathPointViewController.h"


@implementation AnnoPathPointViewController

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
-(AnnoPathPointViewController*) initWithAnnotation:(Annotation *)anno{
	self = [super init];
	if (!self) return nil;
	self.annotation = anno;
	NSString* imageName;
	switch (anno.annoType) {
		case kAnnoStart:
			imageName = [NSString stringWithString:@"green_flag_icon.png"];
			break;
		case kAnnoGoal:
			imageName = [NSString stringWithString:@"red_flag_icon.png"];
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
	[imageView release];
	return self;
}

#pragma mark addGestureRecognizer

-(void) addGestureRecognizer{
	[super addGestureRecognizer];
	
	UIPanGestureRecognizer* panGesture	 = [[UIPanGestureRecognizer alloc]
											initWithTarget:self action:@selector(annoMoved:)];
	[self.view addGestureRecognizer:panGesture];
	[panGesture release];
	
	UITapGestureRecognizer* tapGesture	 = [[UITapGestureRecognizer alloc]
											initWithTarget:self action:@selector(annoRemoved:)];
	tapGesture.numberOfTapsRequired = 2;
	[self.view addGestureRecognizer:tapGesture];
	[tapGesture release];
}

-(void) annoMoved: (UIGestureRecognizer*) gesture{
	CGPoint	translation = [(UIPanGestureRecognizer*) gesture translationInView:self.view];
	[(UIPanGestureRecognizer*)gesture setTranslation:CGPointZero inView:self.view];
		
	if (gesture.state == UIGestureRecognizerStateBegan){
		previousFrame = self.view.frame;
	} 
	if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateChanged) {
		self.view.transform = CGAffineTransformTranslate(self.view.transform, translation.x, translation.y);
	}
	if (gesture.state == UIGestureRecognizerStateEnded) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"annotation on map moved" object:self];     // notify to update the annotation position
	}
}

-(void) annoRemoved: (UIGestureRecognizer*) gesture{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"annotation on map removed" object:self];
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


-(void) invalidatePosition{
	self.view.frame = previousFrame;
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
