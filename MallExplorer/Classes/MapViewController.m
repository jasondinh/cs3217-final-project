//
//  MapViewController.m
//  MallExplorer
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController
@synthesize annotationList;
@synthesize map;
@synthesize displayAllTitleMode;

NSMutableArray* hiddenAttribute;

CGRect aFrame;

#pragma mark map view update methods

-(CGPoint) translatePointToScrollViewCoordinationFromMapCoordination:(CGPoint) point{
	double newSizeWidth = mapSize.width * displayArea.zoomScale;
	double newSizeHeight = mapSize.height * displayArea.zoomScale;
	NSLog(@"zoom scale %lf", displayArea.zoomScale);
	return CGPointMake(point.x/mapSize.width*newSizeWidth, point.y/mapSize.height*newSizeHeight);
}

-(CGPoint) translatePointToMapCoordinationFromScrollViewCoordination:(CGPoint) point{
	double newSizeWidth = mapSize.width * displayArea.zoomScale;
	double newSizeHeight = mapSize.height * displayArea.zoomScale;
	return CGPointMake(point.x/newSizeWidth*mapSize.width, point.y/newSizeHeight*mapSize.height);
}

-(void) mapUpdate{
	
}

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return [scrollView.subviews objectAtIndex:0];
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
	hiddenAttribute = [[NSMutableArray alloc] initWithCapacity:[scrollView.subviews count]];
	for (int i = 0; i<[scrollView.subviews count]; i++) {
		NSNumber* aNumber = [NSNumber numberWithInt:[[scrollView.subviews objectAtIndex:i] isHidden]];
		[hiddenAttribute addObject:aNumber];
	}
	for (int i = 1; i<[scrollView.subviews count]; i++) {
		[[scrollView.subviews objectAtIndex:i] setHidden:YES];
	}
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
	for (int i = 0; i<[annotationList count]; i++) {
		AnnoViewController* annoVC = [annotationList objectAtIndex:i];
		annoVC.view.center = [self translatePointToScrollViewCoordinationFromMapCoordination:annoVC.annotation.position];
		annoVC.titleButton.frame = [annoVC getAnnoTitleRect];
	}
	
	
	for (int i = 1; i<[hiddenAttribute count]; i++) {
		[[scrollView.subviews objectAtIndex:i] setHidden:[[hiddenAttribute objectAtIndex:i] intValue]];
	}
	[hiddenAttribute release];
}

#pragma mark -
#pragma mark add annotation methods

-(void) addAnnotationToMap: (AnnoViewController*) annoView{
	[displayArea addSubview:annoView.view];
	[annoView.view setCenter:annoView.annotation.position];
	UIButton* titleButton = [[UIButton alloc] initWithFrame:[annoView getAnnoTitleRect]];
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
	
	if ([annotationList isMemberOfClass:[NSMutableArray class]]) {
		NSLog(@"can add object");
	} else if ([annotationList isMemberOfClass:[NSArray class]]) {
		NSLog(@"cannot add object");
	}
	else {
		NSLog(@"not member of any array clas");
	}

	[annotationList addObject:annoView];
	[self addAnnotationToMap:annoView];
	NSLog(@"%d", [annotationList count]);
	[annoView release];
}


#pragma mark -
#pragma mark initializers


-(MapViewController*) initMallWithFrame:(CGRect) aFr{
	aFrame = aFr;
	NSLog(@"initMall");
	UIImage* image = [UIImage imageNamed:@"map.gif"];
	Annotation* location1 = [[Annotation alloc] initWithPosition:CGPointMake(50, 50) title:@"xxx shop" content:@"xxx toy shop, for 21+ only =)"];
	Annotation* location2 = [[Annotation alloc] initWithPosition:CGPointMake(160, 160) title:@"gd service" content:@"gender education service =)"];
	CGPoint defaultPoint = CGPointMake(100, 100);
	return [self initWithMapImage:image 
		   withDefaultCenterPoint:(CGPoint) defaultPoint 
			   withAnnotationList:[NSArray arrayWithObjects:location1, location2, nil]];
	
}

-(MapViewController*) initWithMapImage:(UIImage*)img 
				withDefaultCenterPoint:(CGPoint)defaultPoint
					withAnnotationList:(NSArray*) annList{
	self = [super init];
	if (!self) return nil;
	zoomScale = 1.0;
	mapCenterPoint = defaultPoint;
	annotationList = [[NSMutableArray alloc] init];
	self.map = [[Map alloc] initWithMapImage:img annotationList:annList];
	mapSize = img.size;
	for (int i= 0; i<[annList count]; i++) {
		AnnoViewController* annoView = [[AnnoViewController alloc] initWithAnnotation: [annList objectAtIndex:i]];
		[annotationList addObject:annoView];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationChangeToggle:) name:@"title is shown" object:nil];
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
	displayArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,aFrame.size.width,aFrame.size.height)];
	NSLog(@"%lf %lf %lf %lf", displayArea.frame.origin.x, displayArea.frame.origin.y, displayArea.frame.size.width, displayArea.frame.size.height);
	//displayArea = [[UIScrollView alloc] initWithFrame:CGRectMake(MAP_ORIGIN_X, MAP_ORIGIN_Y, MAP_WIDTH, MAP_HEIGHT)];
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
	//[self.view addSubview: displayArea];
	self.view = displayArea;
	[imageView release];
	[displayArea release];
	displayArea.maximumZoomScale = 2.0;
	displayArea.minimumZoomScale = 0.5;
	[displayArea setDelegate:self];
	//[self addGestureRecognizer];
	NSLog(@"%d", [displayArea.subviews count]);
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

-(void) zoomMap:(UIGestureRecognizer*) gesture{
	NSLog(@"zooming");
	double scale = [(UIPinchGestureRecognizer *) gesture scale];
	((UIPinchGestureRecognizer *) gesture).scale = 1;
	double newScale = zoomScale*scale;
	if ((newScale>maxScale) || (newScale<minScale)) {
		return;
	}
	zoomScale = newScale;
	CGSize contentSize = CGSizeMake(mapSize.width*zoomScale, mapSize.height*zoomScale);
	////NSLog(@"position %lf %lf", objectModel.position.x, objectModel.position.y);
	//double newWidth = objectModel.bound.size.width*scale;
	//double newHeight = objectModel.bound.size.height*scale;
	self.view.bounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
	[self.view setNeedsDisplay];
//	[self.objectModel updateModel];	
	//[self viewUpdate];
	
}


#pragma mark -
#pragma mark Handling annotation title toggling

-(void) toggleDisplayText{
	if (!displayAllTitleMode) {
		displayAllTitleMode = YES;
		for (int i = 0; i<[annotationList count]; i++) {
			[[annotationList objectAtIndex:i] titleButton].hidden = NO;
		}
	} else {
		displayAllTitleMode = NO;
		for (int i = 0; i<[annotationList count]; i++) {
			[[annotationList objectAtIndex:i] titleButton].hidden = YES;
		}
		annoBeingSelected = nil;
	}

}

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
