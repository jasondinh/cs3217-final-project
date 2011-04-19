//
//  MapViewController.m
//  MallExplorer
//
//  Created by Tran Cong Hoang on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import "MapViewController.h"


@implementation MapViewController
@synthesize annotationList;
@synthesize map, displayArea;

int startPoint,endPoint;

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
	for (int i = 0; i<[map.edgeList count]; i++) {
		Edge* edge = [map.edgeList objectAtIndex:i];
		LineEdgeView* aLine = [[LineEdgeView alloc] initWithPoint1:[self translatePointToScrollViewCoordinationFromMapCoordination:edge.pointA.position] andPoint2: [self translatePointToScrollViewCoordinationFromMapCoordination:edge.pointB.position]];
		[self.view addSubview:aLine];
		[aLine performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:5];
		[aLine release];
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
	for (int i = 0; i<[annotationList count]; i++) {
		AnnoViewController* anAVC = [annotationList objectAtIndex:i];
		anAVC.view.hidden = YES;
		anAVC.titleButton.hidden = YES;
	}
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
	for (int i = 0; i<[annotationList count]; i++) {
		AnnoViewController* annoVC = [annotationList objectAtIndex:i];
		annoVC.view.transform = CGAffineTransformIdentity;
		annoVC.view.center = [self translatePointToScrollViewCoordinationFromMapCoordination:annoVC.annotation.position];
		annoVC.titleButton.frame = [annoVC getAnnoTitleRect];
	}
	for (int i = 0; i<[annotationList count]; i++) {
		AnnoViewController* anAVC = [annotationList objectAtIndex:i];
		anAVC.view.hidden = NO;
		anAVC.titleButton.hidden = anAVC.titleIsShown;
	}
	
	[self redisplayPath];
	
	if (debug) [self testGraphNode];
}

#pragma mark -
#pragma mark handling annotation methods

-(BOOL) addAnnotationToMap: (AnnoViewController*) annoView{
	if (![map checkPositionInsideMap:annoView.annotation.position])
		
	// || ![map checkFreeAtPoint:annoView.annotation.position]) {
	{
		
	
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

-(void) removeAnnotation: (Annotation*) annotation{
	[self.map removeAnnotation:annotation];
	for (int i = 0; i<[annotationList count]; i++) {
		AnnoViewController* annoView = [annotationList objectAtIndex:i];
		if ([annoView.annotation isEqual: annotation]) {
			[annotationList removeObjectAtIndex:i];
			break;
		}
	}
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
	self.displayArea = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
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
	
	
	if (debug){
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
	if (![map checkPositionInsideMap:newAnnoMapPosition])// || ![map checkFreeAtPoint:newAnnoMapPosition]) {
	{
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
	[UIView animateWithDuration:0.4 animations:^ {
		displayArea.contentOffset = newOrigin;
	}];
}

-(CGSize) getDistanceFromBoundForObjectAtScrollviewPosition: (CGPoint) aPos{
	CGSize result = {aPos.x-displayArea.contentOffset.x, aPos.y-displayArea.contentOffset.y};
	return result;
}


-(CGSize) getDistanceFromBoundForObjectAtMapPosition: (CGPoint) aPos{
	return [self getDistanceFromBoundForObjectAtScrollviewPosition: [self translatePointToScrollViewCoordinationFromMapCoordination:aPos]];
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
	[displayArea release];
	[edgeDisplayedList release];
	[annotationList release];
	[map release];
    [super dealloc];
}


@end
