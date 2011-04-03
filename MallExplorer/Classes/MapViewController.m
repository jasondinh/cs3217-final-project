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
NSMutableArray* edgeList;

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
	for (int i = 0; i<[edgeDisplayedList count]; i++) {
		LineEdgeView* aLine = [edgeDisplayedList objectAtIndex:i];
		aLine.startPoint = [self translatePointToMapCoordinationFromScrollViewCoordination: aLine.startPoint];
		aLine.goalPoint = [self translatePointToMapCoordinationFromScrollViewCoordination: aLine.goalPoint];
		NSLog(@"before zooming %lf %lf %lf %lf", aLine.startPoint.x, aLine.startPoint.y, aLine.goalPoint.x, aLine.goalPoint.y);
		[aLine removeFromSuperview];
	}
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
	
	for (int i = 0; i<[edgeDisplayedList count]; i++) {
		LineEdgeView* aLine = [edgeDisplayedList objectAtIndex:i];
		aLine.startPoint = [self translatePointToScrollViewCoordinationFromMapCoordination:aLine.startPoint];
		aLine.goalPoint = [self translatePointToScrollViewCoordinationFromMapCoordination: aLine.goalPoint];
		[aLine adjustFrameToPoint1: aLine.startPoint andPoint2:aLine.goalPoint];
		NSLog(@"after zooming %lf %lf %lf %lf", aLine.startPoint.x, aLine.startPoint.y, aLine.goalPoint.x, aLine.goalPoint.y);
		[displayArea addSubview:aLine];
		[displayArea sendSubviewToBack:aLine];
		
	}
	[displayArea sendSubviewToBack:imageView];
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

-(MapViewController*) initWithMapImage:(UIImage*)img 
				withDefaultCenterPoint:(CGPoint)defaultPoint
					withAnnotationList:(NSArray*) annList
							 pointList:(NSArray*) pointList
							  edgeList:(NSArray*) edgeList
{
	self = [super init];
	if (!self) return nil;
	zoomScale = 1.0;
	mapCenterPoint = defaultPoint;
	annotationList = [[NSMutableArray alloc] init];
	edgeDisplayedList = [[NSMutableArray alloc] init];
	self.map = [[Map alloc] initWithMapImage:img annotationList:annList pointList:pointList edgeList:edgeList];
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


-(MapViewController*) initMallWithFrame:(CGRect) aFr{
	aFrame = aFr;
	NSLog(@"initMall");
	UIImage* image = [UIImage imageNamed:@"map.gif"];
	Annotation* location1 = [[Annotation alloc] initAnnotationType:kAnnoShop WithPosition:CGPointMake(50, 50) title:@"abc" content:@"abcxyz"];
	Annotation* location2 = [[Annotation alloc] initAnnotationType:kAnnoShop WithPosition:CGPointMake(160, 160) title:@"nmf" content:@"ghijkl"];
	CGPoint defaultPoint = CGPointMake(100, 100);
	MapPoint* p0 = [[MapPoint alloc] initWithPosition:CGPointMake(105, 10) andIndex:0];
	MapPoint* p1 = [[MapPoint alloc] initWithPosition:CGPointMake(35, 40) andIndex:1];
	MapPoint* p2 = [[MapPoint alloc] initWithPosition:CGPointMake(155, 50) andIndex:2];
	MapPoint* p3 = [[MapPoint alloc] initWithPosition:CGPointMake(70, 260) andIndex:3];
	MapPoint* p4 = [[MapPoint alloc] initWithPosition:CGPointMake(195, 80) andIndex:4];
	MapPoint* p5 = [[MapPoint alloc] initWithPosition:CGPointMake(95, 75) andIndex:5];
	MapPoint* p6 = [[MapPoint alloc] initWithPosition:CGPointMake(40, 125) andIndex:6];
	MapPoint* p7 = [[MapPoint alloc] initWithPosition:CGPointMake(150, 95) andIndex:7];
	MapPoint* p8 = [[MapPoint alloc] initWithPosition:CGPointMake(160, 175) andIndex:8];
	MapPoint* p9 = [[MapPoint alloc] initWithPosition:CGPointMake(145, 155) andIndex:9];
	NSArray* pointList = [NSArray arrayWithObjects:p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,nil];
	int edgeNode1[] = {0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8, 9, 9};
	int edgeNode2[] = {1, 3, 4, 2, 3, 5, 0, 7, 6, 8, 2, 7, 9, 0, 3, 2, 7, 9, 3, 5};
	edgeList = [[NSMutableArray alloc] init];
	for (int i = 0; i<20; i++) {
		MapPoint* point1 = [pointList objectAtIndex:edgeNode1[i]];
		MapPoint* point2 = [pointList objectAtIndex:edgeNode2[i]];
		Edge* anEdge = [[Edge alloc] initWithPoint1:point1 point2:point2 withLength:[MapPoint getDistantBetweenPoint:point1 andPoint:point2] isBidirectional:YES withTravelType:kWalk];
		[edgeList addObject:anEdge];		
	}
	return [self initWithMapImage:image 
		   withDefaultCenterPoint:(CGPoint) defaultPoint 
			   withAnnotationList:[NSArray arrayWithObjects:location1, location2, nil]
						pointList:pointList 
						 edgeList:edgeList
			];
	
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
	imageView = [[UIImageView alloc] initWithImage:self.map.imageMap];
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
	
	// test line edge view
	/*
	for (int i = 1; i<[annotationList count]; i++) {
		AnnoViewController* annoView0 = [annotationList objectAtIndex:i-1];
		AnnoViewController* annoView1 = [annotationList objectAtIndex:i];
		NSLog(@"adding line edge between %lf %lf and %lf %lf", annoView0.annotation.position.x, annoView0.annotation.position.y, annoView1.annotation.position.x, annoView1.annotation.position.y);
		LineEdgeView* aLineView = [[LineEdgeView alloc] initWithPoint1:annoView0.annotation.position  andPoint2:annoView1.annotation.position];
		[displayArea addSubview:aLineView];
		[displayArea sendSubviewToBack:aLineView];
		[edgeDisplayedList addObject:aLineView];
		[aLineView release];
	}
	for (int i = 0; i<[edgeList count]; i++) {
		MapPoint* point1 = [[edgeList objectAtIndex:i] pointA];
		MapPoint* point2 = [[edgeList objectAtIndex:i] pointB];
		LineEdgeView* aLineView = [[LineEdgeView alloc] initWithPoint1:point1.position  andPoint2:point2.position];
		[displayArea addSubview:aLineView];
		[displayArea sendSubviewToBack:aLineView];
		[edgeDisplayedList addObject:aLineView];		
		[aLineView release];
		
	}*/
	//
	
	
	[displayArea sendSubviewToBack:imageView];	
	[imageView release];
	[displayArea release];
	displayArea.maximumZoomScale = 2.0;
	displayArea.minimumZoomScale = 0.5;
	[displayArea setDelegate:self];
	NSLog(@"%d", [displayArea.subviews count]);
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

#pragma mark -
#pragma mark path finding
-(NSArray*) findPathFromStartPosition:(CGPoint)startPos ToGoalPosition:(CGPoint) goalPos{
	MapPoint* startPoint = [[MapPoint alloc] initWithPosition:startPos andIndex:0];
	MapPoint* goalPoint = [[MapPoint alloc] initWithPosition:goalPos andIndex:0];
	MapPoint* point1 = [map getClosestMapPointToPosition:startPos];
	MapPoint* point2 = [map getClosestMapPointToPosition:goalPos];
	
	NSMutableArray* result = [[NSMutableArray alloc] initWithObjects:startPoint, nil];
	[result addObjectsFromArray:[map findPathFrom:point1 to:point2]];
	[result addObject:goalPoint];
	for	(int i = 0; i<[result count]-1; i++)
	{
		CGPoint pos1 = [self translatePointToScrollViewCoordinationFromMapCoordination:[[result objectAtIndex:i] position]];
		CGPoint pos2 = [self translatePointToScrollViewCoordinationFromMapCoordination:[[result objectAtIndex:i+1] position]];
		LineEdgeView* aLineView = [[LineEdgeView alloc] initWithPoint1:pos1 andPoint2:pos2];
		[displayArea addSubview:aLineView];
		[displayArea sendSubviewToBack:aLineView];
		[edgeDisplayedList addObject:aLineView];
		[aLineView release];
	}
	[displayArea sendSubviewToBack:imageView];
	return result;
}


-(NSArray*) findPathFromStartAnnotation:(Annotation*)start ToGoalAnnotaion:(Annotation*) goal{
	return [self findPathFromStartPosition:start.position ToGoalPosition:goal.position];
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
	[edgeDisplayedList release];
	[annotationList release];
	[map release];
    [super dealloc];
}


@end
