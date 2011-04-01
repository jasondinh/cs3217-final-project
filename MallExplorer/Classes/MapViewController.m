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


-(MapViewController*) initWithMapImage:(UIImage*) img annotationList:(NSArray*) annList{
	self = [super init];
	if (!self) return nil;
	self.map = [[Map alloc] initWithMapImage:img annotationList:annList];
	for (int i= 0; i<[annList count]; i++) {
		AnnoViewController* annoView = [[AnnoViewController alloc] initWithAnnotation: [annList objectAtIndex:i]];
		[annotationList addObject:annoView];
		[annoView release];
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
