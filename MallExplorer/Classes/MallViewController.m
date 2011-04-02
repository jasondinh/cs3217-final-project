    //
//  MallViewController.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MallViewController.h"
#define MAP_ORIGIN_X 0
#define MAP_ORIGIN_Y 46
#define MAP_WIDTH	 703
#define MAP_HEIGHT	 703

@implementation MallViewController
//@synthesize coordinate;

@synthesize toolbar;
@synthesize detailItem;
@synthesize popoverController;
@synthesize toogleTextButton;
@synthesize startFlagButton;
@synthesize goalFlagButton;
@synthesize pathFindingButton;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.

    }
    return self;
}*/


#pragma mark viewDidLoad

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	mapViewController = [[MapViewController alloc] initMallWithFrame:CGRectMake(MAP_ORIGIN_X, MAP_ORIGIN_Y, MAP_WIDTH, MAP_HEIGHT)];
	mapViewController.view.frame = CGRectMake
	(MAP_ORIGIN_X, MAP_ORIGIN_Y, MAP_WIDTH, MAP_HEIGHT);
	[self.view addSubview: mapViewController.view];
	[self.view sendSubviewToBack:mapViewController.view];
	UITapGestureRecognizer* tapGesture	 = [[UITapGestureRecognizer alloc]
											initWithTarget:self action:@selector(toggleText:)];
	[tapGesture setNumberOfTapsRequired:1];
	[toogleTextButton addGestureRecognizer:tapGesture];
	
	tapGesture	 = [[UITapGestureRecognizer alloc]
											initWithTarget:self action:@selector(pathFinding)];
	[tapGesture setNumberOfTapsRequired:1];
	[pathFindingButton addGestureRecognizer:tapGesture];

	UIPanGestureRecognizer* panGesture	 = [[UIPanGestureRecognizer alloc]
											initWithTarget:self action:@selector(startFlagMove:)];
	[startFlagButton addGestureRecognizer:panGesture];
	[panGesture release];

	panGesture	 = [[UIPanGestureRecognizer alloc]
											initWithTarget:self action:@selector(goalFlagMove:)];
	[goalFlagButton addGestureRecognizer:panGesture];

	[panGesture release];
	[tapGesture release];
	
}

#pragma mark -
#pragma mark event handling for toolbar button

-(void) moveButton:(UIImageView*) button 
	   withGesture: (UIGestureRecognizer*) gesture 
	toMakeAnnotationWithTitle:(NSString*) title
		andContent:(NSString*) content
{
	CGPoint	translation = [(UIPanGestureRecognizer*) gesture translationInView:self.view];
	[(UIPanGestureRecognizer*)gesture setTranslation:CGPointZero inView:self.view];
	if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateChanged) {
		button.transform = CGAffineTransformTranslate(button.transform, translation.x, translation.y);
	}
	if (gesture.state == UIGestureRecognizerStateEnded) {
		double newX = button.frame.origin.x - mapViewController.view.frame.origin.x;
		double newY = button.frame.origin.y - mapViewController.view.frame.origin.y;
		NSLog(@"new x new y %lf %lf", newX, newY);
		if (newX>= 0 && newY>=0)
		{
			//GameObject* aController = [[GameObject alloc] initWithType:objectType withShape:shapeType atX:newX+gamearea.contentOffset.x atY:newY+ gamearea.contentOffset.y  withWidth:size.width withHeight:size.height];
			UIScrollView* theScrollView = (UIScrollView*) mapViewController.view;
			double x = newX + button.frame.size.width/2  + theScrollView.contentOffset.x;
			double y = newY + button.frame.size.height/2 + theScrollView.contentOffset.y ;
			NSLog(@"new x new y %lf %lf", x, y);
			Annotation* aNewAnnotation = [[Annotation alloc] initWithPosition:CGPointMake(x, y) title:title content:content];
			[mapViewController addAnnotation: aNewAnnotation];
//			AnnoViewController* anAnnoViewController = [[AnnoViewController alloc] initWithAnnotation:aNewAnnotation];
		}
		button.transform = CGAffineTransformIdentity;
	}
	
}

- (void)startFlagMove:(UIGestureRecognizer *)gesture{
	[self moveButton:startFlagButton withGesture:gesture toMakeAnnotationWithTitle:@"Start" andContent:@"Your starting position"];
}

- (void)goalFlagMove:(UIGestureRecognizer *)gesture{
	[self moveButton:goalFlagButton withGesture:gesture toMakeAnnotationWithTitle:@"Goal" andContent:@"Your destination"];
}

-(void) toggleText:(UIGestureRecognizer*) gesture{
	NSLog(@"toggle title");
	[mapViewController toggleDisplayText];
}

#pragma mark -


- (NSString *)subtitle{
	return @"Put some text here";
}
- (NSString *)title{
	return @"Parked Location";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	if(self = [super init]){
		coordinate=c;
		NSLog(@"%f,%f",c.latitude,c.longitude);
	}
	return self;
}

#pragma mark -
#pragma mark Split view support
- (void)splitViewController: (UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem 
	   forPopoverController: (UIPopoverController*)pc {
	
    barButtonItem.title = @"Root List";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

- (void)splitViewController: (UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
	
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


-(void) buttonClicked:(UIButton *)sender{
	
}

@end
