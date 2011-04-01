    //
//  MapViewController.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
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



-(void) addAnnotationToMap: (AnnoViewController*) annoView{
	[displayArea addSubview:annoView.view];
	[annoView.view setCenter:annoView.annotation.position];
}

-(void) addAnnotation: (Annotation*) annotation{
	[self.map addAnnotation:annotation];
	AnnoViewController* annoView = [[AnnoViewController alloc] initWithAnnotation: annotation];
	[annotationList addObject:annoView];
	[self addAnnotationToMap:annoView];
	[annoView release];
}

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
	self.map = [[Map alloc] initWithMapImage:img annotationList:annList];
	for (int i= 0; i<[annList count]; i++) {
		AnnoViewController* annoView = [[AnnoViewController alloc] initWithAnnotation: [annList objectAtIndex:i]];
		[annotationList addObject:annoView];
		[self.view addSubview: annoView.view];
		annoView.view.center = annoView.annotation.position;
		NSLog(@"%d", [annoView retainCount]);
		//[annoView release];
	}
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
	for (int i = 0; i < [annotationList count]; i++) {
		[self addAnnotationToMap:[annotationList objectAtIndex:i]];
	}
	// set inset 
	
	// set off set
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
