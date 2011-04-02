//
//  MapViewController.m
//  MallExplorer
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#define MAP_ORIGIN_X 100
#define MAP_ORIGIN_Y 50
#define MAP_WIDTH	 500
#define MAP_HEIGHT	 500

@implementation MapViewController
@synthesize annotationList;
@synthesize map;
@synthesize displayAllTitleMode;

#pragma mark -
#pragma mark add annotation methods

-(void) addAnnotationToMap: (AnnoViewController*) annoView{
	[displayArea addSubview:annoView.view];
	[annoView.view setCenter:annoView.annotation.position];
	UIButton* titleButton = [[UIButton alloc] initWithFrame:CGRectMake(annoView.view.frame.origin.x, annoView.view.frame.origin.y+annoView.view.frame.size.height+5, annoView.view.frame.size.width*3, 20)];
	NSLog(@"%lf %lf %lf %lf", titleButton.frame.origin.x, titleButton.frame.origin.y, titleButton.frame.size.width, titleButton.frame.size.height);
	[titleButton setTitle:annoView.annotation.title forState:UIControlStateNormal];
	titleButton.backgroundColor = [UIColor	colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.4];
	titleButton.hidden = YES;
	[displayArea addSubview:titleButton];
	annoView.titleButton = titleButton;
}

-(void) addAnnotation: (Annotation*) annotation{
	[self.map addAnnotation:annotation];
	AnnoViewController* annoView = [[AnnoViewController alloc] initWithAnnotation: annotation];
	[annotationList addObject:annoView];
	[annoView release];
}


#pragma mark -
#pragma mark initializers


-(MapViewController*) initMall{
	NSLog(@"initMall");
	UIImage* image = [UIImage imageNamed:@"map.gif"];
	Annotation* location1 = [[Annotation alloc] initWithPosition:CGPointMake(50, 50) title:@"xxx shop" content:@"xxx toy shop, for 21+ only =)"];
	Annotation* location2 = [[Annotation alloc] initWithPosition:CGPointMake(160, 160) title:@"gd service" content:@"gender education service =)"];
	return [self initWithMapImage:image annotationList:[NSArray arrayWithObjects:location1, location2, nil]];
	
}

-(MapViewController*) initWithMapImage:(UIImage*) img annotationList:(NSArray*) annList{
	self = [super init];
	if (!self) return nil;
	annotationList = [[NSMutableArray alloc] init];
	self.map = [[Map alloc] initWithMapImage:img annotationList:annList];
	for (int i= 0; i<[annList count]; i++) {
		AnnoViewController* annoView = [[AnnoViewController alloc] initWithAnnotation: [annList objectAtIndex:i]];
		[annotationList addObject:annoView];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationChangeToggle:) name:@"title is shown" object:nil];
		NSLog(@"retain count %d", [annoView retainCount]);
		[annoView release];
	}
	displayAllTitleMode = NO;
	annoBeingSelected = nil;
	return self;
}



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
	NSLog(@"mall view did load");
	displayArea = [[UIScrollView alloc] initWithFrame:CGRectMake(MAP_ORIGIN_X, MAP_ORIGIN_Y, MAP_WIDTH, MAP_HEIGHT)];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:self.map.imageMap];
	[displayArea addSubview:imageView];
	[displayArea setContentSize:imageView.bounds.size];
	NSLog(@"annotationList count %d", [annotationList count]);
	for (int i = 0; i < [annotationList count]; i++) {
		[self addAnnotationToMap:[annotationList objectAtIndex:i]];
	}
	// set inset 
	
		
	// set off set
	
	NSLog(@"finish adding annotation to map");
	[displayArea setContentOffset:CGPointMake(0, 0)];
	self.view = displayArea;
	[imageView release];
	[displayArea release];
	//[self addGestureRecognizer];
	
}

-(void) addGestureRegconizer{
	UIPinchGestureRecognizer* pinchGesture	 = [[UIPinchGestureRecognizer alloc]
												initWithTarget:self action:@selector(zoomMap:)];
	[self.view addGestureRecognizer:pinchGesture];
	[pinchGesture release];
	
	
	//panGesture	 = [[UIPanGestureRecognizer alloc]
	//					initWithTarget:self action:@selector(movePigButton:)];
	//	[pigButton addGestureRecognizer:panGesture];
	//	[panGesture release];
	//	
	//	
	//	panGesture	 = [[UIPanGestureRecognizer alloc]
	//					initWithTarget:self action:@selector(moveBlockButton:)];
	//	[blockButton addGestureRecognizer:panGesture];
	//	[panGesture release];
	//	
	//	panGesture	 = [[UIPanGestureRecognizer alloc]
	//					initWithTarget:self action:@selector(moveSquareBlockButton:)];
	//	[squareBlockButton addGestureRecognizer:panGesture];
	//	[panGesture release];
	//	
	//	UITapGestureRecognizer* tapGesture	 = [[UITapGestureRecognizer alloc]
	//											initWithTarget:self action:@selector(blueWindButton:)];
	//	[tapGesture setNumberOfTapsRequired:1];
	//	[blueWindButton addGestureRecognizer:tapGesture];
	//	[tapGesture release];
	//	
	//	tapGesture	 = [[UITapGestureRecognizer alloc]
	//					initWithTarget:self action:@selector(redWindButton:)];
	//	[tapGesture setNumberOfTapsRequired:1];
	//	[redWindButton addGestureRecognizer:tapGesture];
	//	[tapGesture release];
	//	
	//	tapGesture	 = [[UITapGestureRecognizer alloc]
	//					initWithTarget:self action:@selector(greenWindButton:)];
	//	[tapGesture setNumberOfTapsRequired:1];
	//	[greenWindButton addGestureRecognizer:tapGesture];
	//	[tapGesture release];
}



#pragma mark -
#pragma mark Handling annotation title toggling

-(void) annotationChangeToggle:(NSNotification*) notification{
	if (!displayAllTitleMode) {
	NSLog(@"anno change toggled");
		if (annoBeingSelected) {
			NSLog(@"turned off something");
			annoBeingSelected.titleIsShown = NO;
			annoBeingSelected.titleButton.hidden = YES;
			NSLog(@"anno is being display %d", annoBeingSelected.titleButton.hidden);
		}
		annoBeingSelected = notification.object;
		annoBeingSelected.titleButton.hidden = NO;
		NSLog(@"%d",  annoBeingSelected.titleButton.hidden);
		for (int i = 0; i<[annotationList count]; i++) {
			NSLog(@"anno %d is being display: %d", i, [[annotationList objectAtIndex:i] titleButton].hidden);
		}
	}
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
