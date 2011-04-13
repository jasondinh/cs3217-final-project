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

const BOOL DEBUG = YES;
int startPoint,endPoint;

NSMutableArray* hiddenAttribute;
NSMutableArray* pointPathList;

CGRect frame;
NSMutableArray* edgeList;

#pragma mark map view update methods

-(CGPoint) translatePointToScrollViewCoordinationFromMapCoordination:(CGPoint) point{
	double newSizeWidth = mapSize.width * displayArea.zoomScale;
	double newSizeHeight = mapSize.height * displayArea.zoomScale;
	return CGPointMake(point.x/mapSize.width*newSizeWidth, point.y/mapSize.height*newSizeHeight);
}

-(CGPoint) translatePointToMapCoordinationFromScrollViewCoordination:(CGPoint) point{
	double newSizeWidth = mapSize.width * displayArea.zoomScale;
	double newSizeHeight = mapSize.height * displayArea.zoomScale;
	return CGPointMake(point.x/newSizeWidth*mapSize.width, point.y/newSizeHeight*mapSize.height);
}

-(void) addATestPoint:(CGPoint) point withImage:(NSString*) imageName withDuration:(double) time{
	UIImageView* imgView = [UIImageView  imageViewWithImageNamed:imageName];
	imgView.frame = CGRectMake(0, 0, 20, 20);
	imgView.center = point;
	[self.view addSubview:imgView];
	[[self.view.subviews lastObject] performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:time];
}

-(void) testGraphNode{
	for (int i = 0; i<[map.pointList count]; i++) {
		MapPoint* aMapPoint = [map.pointList objectAtIndex:i];
		[self addATestPoint:[self translatePointToScrollViewCoordinationFromMapCoordination: aMapPoint.position] withImage:@"point.png" withDuration:10.0];
	}
}

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return [scrollView.subviews objectAtIndex:0];
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
	for (int i = 0; i<[edgeDisplayedList count]; i++) {
		LineEdgeView* aLine = [edgeDisplayedList objectAtIndex:i];
		aLine.startPoint = [self translatePointToMapCoordinationFromScrollViewCoordination: aLine.startPoint];
		aLine.goalPoint = [self translatePointToMapCoordinationFromScrollViewCoordination: aLine.goalPoint];
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
		annoVC.view.transform = CGAffineTransformIdentity;
		annoVC.view.center = [self translatePointToScrollViewCoordinationFromMapCoordination:annoVC.annotation.position];
		annoVC.titleButton.frame = [annoVC getAnnoTitleRect];
	}
	  
	for (int i = 1; i<[hiddenAttribute count]; i++) {
		[[scrollView.subviews objectAtIndex:i] setHidden:[[hiddenAttribute objectAtIndex:i] intValue]];
	}
	
	[hiddenAttribute release];
	[self redisplayPath];
	
	if (DEBUG) [self testGraphNode];
}

#pragma mark -
#pragma mark handling annotation methods

-(BOOL) addAnnotationToMap: (AnnoViewController*) annoView{
	if (![map checkPositionInsideMap:annoView.annotation.position] || ![map checkFreeAtPoint:annoView.annotation.position]) {
		return NO; // cannot add
	} 
	
	[displayArea addSubview:annoView.view];
	[annoView.view setCenter:[self translatePointToScrollViewCoordinationFromMapCoordination: annoView.annotation.position]];
	UIButton* titleButton = [[UIButton alloc] initWithFrame:[annoView getAnnoTitleRect]];
	[titleButton setTitle:annoView.annotation.title forState:UIControlStateNormal];
	titleButton.backgroundColor = [UIColor	colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.4];
	titleButton.hidden = NO;
	[displayArea addSubview:titleButton];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationOnMapMoved:) name:@"annotation on map moved" object:annoView];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationOnMapRemoved:) name:@"annotation on map removed" object:annoView];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToDestinationOfAStair:) name:@"move to destination of a stair" object:annoView];
	annoView.titleButton = titleButton;
	return YES;
}

-(AnnoViewController*) addAnnotationType:(AnnotationType) annType ToScrollViewAtPosition:(CGPoint)pos withTitle:(NSString*) title withContent:(NSString*) content {
	Annotation* anno = [Annotation annotationWithAnnotationType:annType inlevel:self.map WithPosition:[self translatePointToMapCoordinationFromScrollViewCoordination:pos] title:title content:content];
	AnnoViewController* annoView = [AnnoViewController annoViewControllerWithAnnotation:[[anno retain] autorelease]];
	[[annoView retain] autorelease];
	if (![self addAnnotationToMap:annoView]) return nil;
	[annotationList addObject:annoView];
	return annoView;
}

-(void) addAnnotation: (Annotation*) annotation{
	[self.map addAnnotation:annotation];
	AnnoViewController* annoView = [AnnoViewController annoViewControllerWithAnnotation: annotation];
	[[annoView retain] autorelease];
	[annotationList addObject:annoView];
	[self addAnnotationToMap:annoView];
}

-(void) removeAllAnnotationOfType:(AnnotationType) typeToRemove{
	for (int i=[annotationList count]-1; i>=0; i--) {
		AnnoViewController* anMVC = [annotationList objectAtIndex:i];
		if (anMVC.annotation.annoType == typeToRemove) {
			[map removeAnnotation:anMVC.annotation];
			[anMVC.view removeFromSuperview];
			[anMVC.titleButton removeFromSuperview];
			[annotationList removeObjectAtIndex:i];
		}
	}
}

#pragma mark -
#pragma mark initializers

-(void) stretchTheFirstTime{
	double ratiox = self.view.frame.size.width/imageView.bounds.size.width;
	double ratioy = self.view.frame.size.height/imageView.bounds.size.height;
	double ratio;
	if (ratiox>1 || ratioy>1) {
		ratio = fmin(displayArea.maximumZoomScale, fmax(ratiox, ratioy));
		displayArea.zoomScale = ratio;
	} 
	
}

+(CGRect) getSuitableFrame{
	CGFloat width = MAP_WIDTH, height = MAP_HEIGHT;
	switch ([UIDevice currentDevice].orientation) {
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:			
			width = MAP_WIDTH;
			height = MAP_HEIGHT;
			break;
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
			width = MAP_PORTRAIT_WIDTH;
			height = MAP_PORTRAIT_HEIGHT;		
			break;
		default:
			break;
	}
	return CGRectMake(MAP_ORIGIN_X, MAP_ORIGIN_Y, width, height);
}

-(MapViewController*) initWithMapImage:(UIImage*)img 
				withDefaultCenterPoint:(CGPoint)defaultPoint
					withAnnotationList:(NSArray*) annList
							 pointList:(NSArray*) pointList
							  edgeList:(NSArray*) edgeList
{
	Map* aMap = [[Map alloc] initWithMapImage:img annotationList:annList pointList:pointList edgeList:edgeList defaultCenterPoint:defaultPoint];
	return [self initMallWithFrame:[MapViewController getSuitableFrame] andMap:aMap];
}

-(MapViewController*) initMallWithFrame: (CGRect) aFrame andMap:(Map*) aMap{
	self = [super init];
	if (!self) return nil;
	frame = aFrame;
	self.map = aMap;
	zoomScale = 1.0;
	mapCenterPoint = aMap.defaultCenterPoint;
	annotationList = [[NSMutableArray alloc] init];
	edgeDisplayedList = [[NSMutableArray alloc] init];
	mapSize = aMap.imageMap.size;
	for (int i= 0; i<[aMap.annotationList count]; i++) {
		AnnoViewController* annoView = [AnnoViewController annoViewControllerWithAnnotation: [map.annotationList objectAtIndex:i]];
		[annotationList addObject:annoView];
	}
	annoBeingSelected = nil;
	return self;
}


-(MapViewController*) initMallWithFrame:(CGRect) aFrame{
	frame = aFrame;
	UIImage* image = [UIImage imageNamed:@"map.jpg"];
	NSMutableArray* pointList = [[NSMutableArray alloc] init];
	edgeList = [[NSMutableArray alloc] init];
	MapPoint* point = [[MapPoint alloc] initWithPosition:CGPointMake(31.000000, 30.000000) inLevel:self.map andIndex:0];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(126.000000, 33.000000) inLevel:self.map andIndex:1];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(297.000000, 69.000000) inLevel:self.map andIndex:2];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(249.000000, 16.000000) inLevel:self.map andIndex:3];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(101.000000, 197.000000) inLevel:self.map andIndex:4];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(22.000000, 185.000000) inLevel:self.map andIndex:5];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(90.000000, 282.000000) inLevel:self.map andIndex:6];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(71.000000, 331.000000) inLevel:self.map andIndex:7];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(32.000000, 373.000000) inLevel:self.map andIndex:8];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(176.000000, 462.000000) inLevel:self.map andIndex:9];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(335.000000, 469.000000) inLevel:self.map andIndex:10];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(407.000000, 277.000000) inLevel:self.map andIndex:11];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(556.000000, 279.000000) inLevel:self.map andIndex:12];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(688.000000, 278.000000) inLevel:self.map andIndex:13];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(403.000000, 115.000000) inLevel:self.map andIndex:14];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(535.000000, 59.000000) inLevel:self.map andIndex:15];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(537.000000, 184.000000) inLevel:self.map andIndex:16];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(534.000000, 121.000000) inLevel:self.map andIndex:17];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(685.000000, 139.000000) inLevel:self.map andIndex:18];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(442.000000, 319.000000) inLevel:self.map andIndex:19];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(455.000000, 424.000000) inLevel:self.map andIndex:20];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(530.000000, 448.000000) inLevel:self.map andIndex:21];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(529.000000, 387.000000) inLevel:self.map andIndex:22];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(545.000000, 516.000000) inLevel:self.map andIndex:23];
	[pointList addObject:point];
	[point release];
	Edge* edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 0] point2:[pointList objectAtIndex: 1] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 0] andPoint:[pointList objectAtIndex: 1]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 1] point2:[pointList objectAtIndex: 3] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 1] andPoint:[pointList objectAtIndex: 3]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 3] point2:[pointList objectAtIndex: 2] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 3] andPoint:[pointList objectAtIndex: 2]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 2] point2:[pointList objectAtIndex: 1] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 2] andPoint:[pointList objectAtIndex: 1]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 1] point2:[pointList objectAtIndex: 4] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 1] andPoint:[pointList objectAtIndex: 4]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 4] point2:[pointList objectAtIndex: 5] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 4] andPoint:[pointList objectAtIndex: 5]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 4] point2:[pointList objectAtIndex: 6] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 4] andPoint:[pointList objectAtIndex: 6]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 6] point2:[pointList objectAtIndex: 7] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 6] andPoint:[pointList objectAtIndex: 7]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 7] point2:[pointList objectAtIndex: 8] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 7] andPoint:[pointList objectAtIndex: 8]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 8] point2:[pointList objectAtIndex: 9] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 8] andPoint:[pointList objectAtIndex: 9]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 9] point2:[pointList objectAtIndex: 10] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 9] andPoint:[pointList objectAtIndex: 10]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 4] point2:[pointList objectAtIndex: 11] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 4] andPoint:[pointList objectAtIndex: 11]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 11] point2:[pointList objectAtIndex: 14] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 11] andPoint:[pointList objectAtIndex: 14]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 14] point2:[pointList objectAtIndex: 17] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 14] andPoint:[pointList objectAtIndex: 17]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 17] point2:[pointList objectAtIndex: 15] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 17] andPoint:[pointList objectAtIndex: 15]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 17] point2:[pointList objectAtIndex: 16] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 17] andPoint:[pointList objectAtIndex: 16]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 17] point2:[pointList objectAtIndex: 18] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 17] andPoint:[pointList objectAtIndex: 18]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 14] point2:[pointList objectAtIndex: 15] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 14] andPoint:[pointList objectAtIndex: 15]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 14] point2:[pointList objectAtIndex: 16] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 14] andPoint:[pointList objectAtIndex: 16]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 16] point2:[pointList objectAtIndex: 18] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 16] andPoint:[pointList objectAtIndex: 18]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 11] point2:[pointList objectAtIndex: 19] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 11] andPoint:[pointList objectAtIndex: 19]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 19] point2:[pointList objectAtIndex: 20] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 19] andPoint:[pointList objectAtIndex: 20]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 20] point2:[pointList objectAtIndex: 21] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 20] andPoint:[pointList objectAtIndex: 21]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 21] point2:[pointList objectAtIndex: 22] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 21] andPoint:[pointList objectAtIndex: 22]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 21] point2:[pointList objectAtIndex: 23] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 21] andPoint:[pointList objectAtIndex: 23]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 11] point2:[pointList objectAtIndex: 12] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 11] andPoint:[pointList objectAtIndex: 12]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 12] point2:[pointList objectAtIndex: 13] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 12] andPoint:[pointList objectAtIndex: 13]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 12] point2:[pointList objectAtIndex: 19] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 12] andPoint:[pointList objectAtIndex: 19]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	CGPoint defaultPoint = CGPointMake(100, 100);
	return [self initWithMapImage:image 
		   withDefaultCenterPoint:(CGPoint) defaultPoint 
			   withAnnotationList:[NSArray arrayWithObjects:/*location1, location2,*/ nil]
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
	displayArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
	imageView = [[UIImageView alloc] initWithImage:self.map.imageMap];
	[displayArea addSubview:imageView];
	[displayArea setContentSize:imageView.bounds.size];
	for (int i = 0; i < [annotationList count]; i++) {
		[self addAnnotationToMap:[annotationList objectAtIndex:i]];
		
	}
	[displayArea setContentOffset:CGPointMake(0, 0)];
	self.view = displayArea;
	
	[displayArea sendSubviewToBack:imageView];	
	[imageView release];
	[displayArea setDelegate:self];
	displayArea.maximumZoomScale = 2.5;
	displayArea.minimumZoomScale = 0.5;
	[self stretchTheFirstTime];
	[self focusToAMapPosition:map.defaultCenterPoint];
	[displayArea release];
	
	
	if (DEBUG){
		pointPathList = [[NSMutableArray alloc] init];
		[self testGraphNode];
	}
	theTimer =[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector: @selector(timerLoop:) userInfo:nil repeats:YES];
	[theTimer retain];
	
}

-(void) timerLoop:(NSTimer*) theTimer{
	for (int i = 0; i<[edgeDisplayedList count]; i++) {
		[[edgeDisplayedList objectAtIndex:i] setNeedsDisplay];
	}
}

-(void) tapToScrollViewPoint:(UIGestureRecognizer*) gesture{
	CGPoint aPoint = [gesture locationInView:displayArea];
	MapPoint* point = [[MapPoint alloc] initWithPosition:aPoint inLevel:self.map andIndex: [map.pointList count]];
	LineEdgeView* aLine = [[LineEdgeView alloc] initWithPoint1:aPoint andPoint2:CGPointMake(aPoint.x+2, aPoint.y+2)];
	[displayArea addSubview:aLine];
	[aLine release];
	[map addPoint:point];
	[point release];
}

-(int) getTheClosestPointToCoordination:(CGPoint) pos{
	double min = INFINITY;
	int minpos = 0;
	for (int i = 0; i<[map.pointList count]; i++) {
		MapPoint* aPoint = [map.pointList objectAtIndex:i];
		double dis = sqrt((aPoint.position.x-pos.x)*(aPoint.position.x-pos.x) + (aPoint.position.y-pos.y)*(aPoint.position.y-pos.y));
		if (dis<min) {
			min = dis;
			minpos = i;
		}
	}
	return minpos;
}

-(void) connectPoint:(UIGestureRecognizer*) gesture{
	if (gesture.state == UIGestureRecognizerStateBegan){
		startPoint = [self getTheClosestPointToCoordination:[gesture locationInView:displayArea]];
	}
	if (gesture.state == UIGestureRecognizerStateEnded) {
		endPoint = [self getTheClosestPointToCoordination:[gesture locationInView:displayArea]];
	}
//	Edge* edge = [[Edge alloc] initWithPoint1:[map.pointList objectAtIndex: startPoint]
//						  point2:[map.pointList objectAtIndex: endPoint]
//					  withLength:[MapPoint getDistantBetweenPoint:[map.pointList objectAtIndex: startPoint]
//														 andPoint:[map.pointList objectAtIndex: endPoint]] isBidirectional:YES withTravelType:kWalk];
//	[self. addObject:edge];
}

#pragma mark -
#pragma mark Handling annotation notification

-(void) moveToDestinationOfAStair:(NSNotification*) notification{
	AnnoViewController* anAVC = notification.object;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"change map" object: [anAVC.annotation destination]];
}

-(void) annotationOnMapRemoved:(NSNotification*) notification{
	AnnoViewController* anAnnoVC = notification.object;
	int annoType = anAnnoVC.annotation.annoType;
	[self.map removeAnnotation:anAnnoVC.annotation];
	[anAnnoVC.titleButton removeFromSuperview];
	[anAnnoVC.view removeFromSuperview];
	[anAnnoVC.view release];
	if (annoType==kAnnoStart || annoType==kAnnoGoal) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"start or goal removed" object:[NSNumber numberWithInt:annoType]];		
	}
}

-(void) annotationOnMapMoved:(NSNotification*) notification{
	AnnoViewController* anAnnoVC = notification.object;
	CGPoint newAnnoMapPosition = [self translatePointToMapCoordinationFromScrollViewCoordination:CGPointMake(anAnnoVC.view.frame.origin.x+anAnnoVC.view.frame.size.width/2, anAnnoVC.view.frame.origin.y+anAnnoVC.view.frame.size.height/2)];
	if (![map checkPositionInsideMap:newAnnoMapPosition] || ![map checkFreeAtPoint:newAnnoMapPosition]) {
		[anAnnoVC invalidatePosition];
		return;
	} 
	anAnnoVC.annotation.position = newAnnoMapPosition;
	anAnnoVC.titleButton.frame = [anAnnoVC getAnnoTitleRect];
	if (anAnnoVC.annotation.annoType==kAnnoStart || anAnnoVC.annotation.annoType==kAnnoGoal) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"start or goal moved" object:self];		
	}
}



#pragma mark -
#pragma mark path finding

// position is in scrollview coordination
-(NSArray*) findPathFromStartPosition:(CGPoint)startPos ToGoalPosition:(CGPoint) goalPos{
	startPos = [self translatePointToMapCoordinationFromScrollViewCoordination: startPos];
	goalPos = [self translatePointToMapCoordinationFromScrollViewCoordination: goalPos];
	MapPoint* startPoint = [[MapPoint alloc] initWithPosition:startPos inLevel:self.map  andIndex:0];
	MapPoint* goalPoint = [[MapPoint alloc] initWithPosition:goalPos inLevel:self.map andIndex:0];
	MapPoint* point1 = [map getClosestMapPointToPosition:startPos];
	MapPoint* point2 = [map getClosestMapPointToPosition:goalPos];
	
	NSMutableArray* result = [[NSMutableArray alloc] initWithObjects:startPoint, nil];
	[result addObjectsFromArray:[map findPathFrom:point1 to:point2]];
	[result addObject:goalPoint];
	[startPoint release];
	[goalPoint release];	
	return [map refineAPath:[result autorelease]];
}

// annotation's position is in map coordination
-(NSArray*) findPathFromStartAnnotation:(Annotation*)start ToGoalAnnotaion:(Annotation*) goal{
	CGPoint startPos = [self translatePointToScrollViewCoordinationFromMapCoordination: start.position];
	CGPoint goalPos = [self translatePointToScrollViewCoordinationFromMapCoordination: goal.position];
	return [self findPathFromStartPosition:startPos ToGoalPosition: goalPos];
}

-(void) redisplayPath{
	for (int i = 0; i<[edgeDisplayedList count]; i++) {
		[[edgeDisplayedList objectAtIndex:i] removeFromSuperview];
	}
	[edgeDisplayedList removeAllObjects];
	for	(int i = 0; i<[map.pathOnMap count]; i++)
	{
		CGPoint pos1 = [self translatePointToScrollViewCoordinationFromMapCoordination:[[[map.pathOnMap objectAtIndex:i] pointA] position]];
		CGPoint pos2 = [self translatePointToScrollViewCoordinationFromMapCoordination:[[[map.pathOnMap objectAtIndex:i] pointB] position]];
		LineEdgeView* aLineView = [[LineEdgeView alloc] initWithPoint1:pos1 andPoint2:pos2];
		[edgeDisplayedList addObject:aLineView];
		[aLineView release];
	}
	for (int i = 0; i<[edgeDisplayedList count]; i++) {
		LineEdgeView* aLineView = [edgeDisplayedList objectAtIndex:i];
		[displayArea addSubview:aLineView];
		[displayArea sendSubviewToBack:aLineView];
		
	}
	[displayArea sendSubviewToBack:imageView];
}

#pragma mark -
#pragma mark focus supporting methods
-(void) focusToAMapPosition:(CGPoint) point{
	[self focusToAScrollViewPosition:[self translatePointToScrollViewCoordinationFromMapCoordination:point]];
}

-(void) focusToAScrollViewPosition:(CGPoint) point{
	CGFloat maxX = displayArea.frame.origin.x+displayArea.contentSize.width-displayArea.frame.size.width;
	CGFloat maxY = displayArea.frame.origin.y+displayArea.contentSize.height-displayArea.frame.size.height;
	CGFloat newOriginX = fmax(0, fmin(point.x-displayArea.frame.size.width/2, maxX));
	CGFloat newOriginY = fmax(0, fmin(point.y-displayArea.frame.size.height/2, maxY));
	CGPoint newOrigin = CGPointMake(newOriginX, newOriginY);
	displayArea.contentOffset = newOrigin;
	// test
	[self addATestPoint:point withImage:@"icon_shop.png" withDuration:5.0];
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

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
