//
//  MallExplorerViewController.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  
//	Updated by Dam Tuan Long on 29 Mar 2011 : add city map
#import "MallExplorerViewController.h"
#import "MallViewController.h"
#import "MallListViewController.h"
#import "MapViewController.h"
#import "ShopListViewController.h"

#import "ShopViewController.h"
#import "Shop.h"
#import "Mall.h"

#import <CoreLocation/CoreLocation.h>
#import "FacebookController.h"
#import "APIController.h"
@implementation MallExplorerViewController
@synthesize maps, stairs, shopListLoaded, mallLoaded, mapsLoaded, stairsLoaded, pointsLoaded, edgesLoaded, annotationsLoaded, progress;

double loadtime;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		// Custom initialization
		cityMapViewController = [[[CityMapViewController alloc] initWithNibName:@"CityMapViewController" bundle:nil] retain];
		masterViewController= [[MasterViewController alloc] initWithCityMap:cityMapViewController];
		self.viewControllers = [NSArray arrayWithObjects: masterViewController, cityMapViewController, nil];
		[self setDelegate:cityMapViewController];
		//add observers for notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopEnter:) name:@"shop enter" object:nil];	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mallEnter:) name:@"mall enter" object:nil];	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ListViewWillAppear:) name:@"Listview will appear" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShopViewWillAppear:) name:@"Shopview will appear"  object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDidFail:) name:@"request did fail"  object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopListLoaded:) name:@"shop list loaded" object:nil];
		currentLoadedMall = nil;
    }
    return self;
}

#pragma mark -
#pragma mark Nofications
-(void) requestDidFail:(id)sender{
/*	if (debug) NSLog(@"REQUEST FAILED");
	RequesFailViewController * requestFail = [[RequesFailViewController alloc]init];
	[masterViewController pushViewController:requestFail animated:YES];*/
}
-(void) mallEnter:(id)sender{
	loadtime = [NSDate timeIntervalSinceReferenceDate];
	id object = [sender object];
	if ([masterViewController.topViewController isKindOfClass:[MallListViewController class]]) {		
		Mall* aMall = object;
		if (![aMall isEqual:currentLoadedMall]) {			
			[currentLoadedMall resetData];
			currentLoadedMall = aMall;
			self.maps = nil;
			self.stairs = nil;
		}
		
		mallLoaded = aMall.mapLoaded;
		shopListLoaded = NO;
		ShopListViewController* shopListViewController = [[ShopListViewController alloc] initWithMall:aMall] ;
		masterViewController.delegate = shopListViewController;
		[masterViewController pushViewController:shopListViewController animated:YES];
		[shopListViewController loadData:nil];
		[shopListViewController release];
		MallViewController* aMVC = [[MallViewController alloc] initWithNibName:@"MallViewController" bundle:nil];
		shopListViewController.delegate = aMVC;
		aMVC.mall = aMall;
		self.viewControllers = [NSArray arrayWithObjects:masterViewController, aMVC, nil];	
		self.progress = [[MBProgressHUD alloc] initWithView:aMVC.view];
		[aMVC.view addSubview:progress];
		[progress release];
		[progress show:YES];
		if (!aMall.mapLoaded) {
			if (debug) NSLog(@"em dang load map");
			[self loadMaps];				
		}
		else {
			[aMVC display];
			[progress hide:YES];
			loadtime = [NSDate timeIntervalSinceReferenceDate] - loadtime;
			NSLog(@"time loaded %lf", loadtime);
		}
		
		[self setDelegate: aMVC];
		if (((UIBarButtonItem*)[[cityMapViewController toolbar].items objectAtIndex:0]).title == @"Root List") {
			UIBarButtonItem *barButtonItem = [[cityMapViewController toolbar].items objectAtIndex:0];	
			NSMutableArray *items = [[aMVC.toolbar items] mutableCopy];
			[items insertObject:barButtonItem atIndex:0];
			
			[aMVC.toolbar setItems:items animated:YES];
			[items release];
		}
	}
	
}
-(void) shopEnter:(id)sender{
	Shop* aShop = (Shop*)[sender object];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"shop chosen"
														object:aShop];
	MallViewController* aMVC = [self.viewControllers objectAtIndex:1];
	CGSize distanceFromBound = [aMVC getDistanceFromBoundForObjectAtMapPosition: aShop.annotation.position];
	if (debug) NSLog(@" distance from bound: %lf %lf", distanceFromBound.width, distanceFromBound.height);
	if (debug) NSLog(((Shop*)[sender object]).shopName);
	ShopViewController* shopViewController = [[ShopViewController alloc] init] ;
	[shopViewController loadShop:aShop];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController: shopViewController];
	UIView *tmpView = [[[self viewControllers] objectAtIndex: 0] view];
	[popover presentPopoverFromRect:CGRectMake(distanceFromBound.width, distanceFromBound.height + 50, 1, 1) 
							 inView: [[[self viewControllers] objectAtIndex:1] view] 
		   permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
	[shopViewController release];
	popover.delegate = self;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [popoverController release];
}

-(void) shopListLoaded:(NSNotification*) notify{
	shopListLoaded = YES; // prone to race-condition
	shopList = notify.object;
	if (mallLoaded){
		[self addShopInShopListToMallMap];
	}
}

- (void) loadPointsWithMapId: (NSInteger) mId {
	APIController *api = [[APIController alloc] init];
	api.debugMode = YES;
	api.delegate = self;
	[api getAPI: [NSString stringWithFormat: @"/maps/%d/points.json", mId]];
}

- (void) loadAnnotationsWithMapId: (NSInteger) mId {
	APIController *api = [[APIController alloc] init];
	api.debugMode = YES;
	api.delegate = self;
	[api getAPI: [NSString stringWithFormat: @"/maps/%d/annotations.json", mId]];	
}

- (void) loadEdgesWithMapId: (NSInteger) mId {
	APIController *api = [[APIController alloc] init];
	api.debugMode = YES;
	api.delegate = self;
	[api getAPI: [NSString stringWithFormat: @"/maps/%d/edges.json", mId]];
}

- (void) loadMaps {
	Mall* theMall = [[self.viewControllers objectAtIndex:1] mall];
	//if (theMall.mapLoaded) return;
	if (debug) NSLog(@"%@", @"loadMaps");
	APIController *api = [[APIController alloc] init];
	api.debugMode = NO;
	api.delegate = self;
	numberMapLoaded = 0;
	NSInteger mId = theMall.mId;
	[api getAPI: [NSString stringWithFormat: @"/malls/%d/maps.json", mId]];
}

- (void) finishedLoadingMap {
	[self loadStairs];
}

-(void) addShopInShopListToMallMap{
	for (int i = 0; i<[shopList count]; i++) {
		Shop* aShop = [shopList objectAtIndex:i];
		if (debug) NSLog(@"creating link between: shop: %@ and annotation", aShop.shopName);
		Map* map = nil;
		for (int j = 0; j<[maps count]; j++) {
			map = [maps objectAtIndex:j];
			NSString* lev = map.level;
			if ([lev isEqual: aShop.level]) {
				map = [maps objectAtIndex:j];
				break;
			}
		}
		
		
		for (int j = 0; j<[map.pointList count]; j++) {
			
			if ([[map.pointList objectAtIndex:j] pId] == aShop.pId) {
				aShop.annotation = [Annotation annotationWithAnnotationType:kAnnoShop inlevel:map WithPosition:[[map.pointList objectAtIndex:j] position] title:aShop.shopName content:@"content"];
				if (debug) NSLog(@"creating link between: shop: %@ and annotation", aShop.shopName);
				break;
			}
		}
		
		[map addAnnotation:aShop.annotation];
	}
}

-(void) finishedLoading{	
	if (debug) NSLog(@"loaddddddddddddddd xongggggggggggggggggggg");
	if (shopListLoaded) {
		[self addShopInShopListToMallMap];
	}
	MallViewController* theMVC = [self.viewControllers objectAtIndex:1];
	BOOL fullyLoaded = NO;
	while (!fullyLoaded){
		fullyLoaded = YES;
		for (int i = 0; i<[maps count]; i++) {
			if ([[maps objectAtIndex:i] imageMap] == nil) {
				fullyLoaded = NO;
				break;
			}
		}
	}
	[theMVC loadMaps:maps andStairs:stairs withDefaultMap:[maps objectAtIndex:0]];
	mallLoaded = YES;
	[progress hide:YES];	
	loadtime = [NSDate timeIntervalSinceReferenceDate] - loadtime;
	NSLog(@"time loaded %lf", loadtime);
	if (debug) NSLog(@"loaddddddddddddddd xongggggggggggggggggggg");
}

- (void) serverRespond: (APIController *) api {
	
	if ([api.path rangeOfString: @"stairs.json"].location != NSNotFound) {		
		self.stairs = [NSMutableArray array];
		NSArray *result = (NSArray *) api.result;
		if (debug) NSLog(@"number of stairs: %d", [result count] );
		for (id obj in result) {
			Map* aMap1 = nil;
			Map* aMap2 = nil;
			MapPoint* point1 = nil;
			MapPoint* point2 = nil;
			NSDictionary *tmpStair = [obj valueForKey: @"stair"];
			NSInteger mId1 = [[tmpStair valueForKey: @"map_id"] intValue];
			NSInteger mId2 = [[tmpStair valueForKey: @"map_second_id"] intValue];
			for (int i = 0; i<[maps count]; i++) {
				Map* aMap = [maps objectAtIndex:i];
				if (aMap.mId == mId1)
				{
					aMap1 = aMap;
				}
				if (aMap.mId == mId2)
				{
					aMap2 = aMap;
				}
				if (aMap1 && aMap2) {
					break;
				}
			}	
			
			NSInteger p1 = [[tmpStair valueForKey: @"first_point_id"] intValue];
			NSInteger p2 = [[tmpStair valueForKey: @"second_point_id"] intValue];			
			if (debug) NSLog(@"map %d point %d map %d point %d", aMap1.mId, p1, aMap2.mId, p2);
			
			for (int i = 0; i<[aMap1.pointList count]; i++) {
				MapPoint* aPoint = [aMap1.pointList objectAtIndex:i];
				if (aPoint.pId == p1) {
					point1 = aPoint;
					if (debug) NSLog(@"cai dm day roi map1 %d", point1.pId);
					break;
				} 
			}
			
			for (int i = 0; i<[aMap2.pointList count]; i++) {
				MapPoint* aPoint = [aMap2.pointList objectAtIndex:i];
				if (aPoint.pId == p2) {
					point2 = aPoint;
 				if (debug) NSLog(@"cai dm day roi map2 %d", point2.pId);
					break;
				} 
			}
			
			Edge* anEdge = [[Edge alloc] initWithPoint1:point1 point2:point2];
			if (debug) NSLog(@"edge: %d %d", anEdge.pointA.pId, anEdge.pointB.pId);
			[stairs addObject:anEdge];
			if (debug) NSLog(@"%d", [stairs count]);
			[anEdge release];
			
		}
		[self finishedLoading];
		return;
	}	
	
	if ([api.path rangeOfString: @"maps.json"].location != NSNotFound) {
		
		NSArray *result = (NSArray *) api.result;
		mapsLoaded = YES;
		
		for(id obj in result) {
			
			NSDictionary *tmpMap = [obj valueForKey: @"map"];
			
			Map* aMap  = [[Map alloc] initWithMapId: [[tmpMap valueForKey: @"id"] intValue] 
										  withLevel: [tmpMap valueForKey: @"level"]
											withURL: [tmpMap valueForKey: @"url"]];

			if (maps == nil) {
				maps = [[NSMutableArray array] retain];
			}

			[maps addObject: aMap];
			[aMap release];
		}
		numWaiting = 0;
		[maps enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			numWaiting++;
			[self loadPointsWithMapId: ((Map *) obj).mId];
			
			
		}];
			
		
		
	}
	else if ([api.path rangeOfString: @"points.json"].location != NSNotFound) { 
		if (debug) NSLog([[api result] description]);
		numWaiting--;
		NSMutableArray *points = [NSMutableArray array];
		
		NSArray *result = (NSArray *) api.result;
		NSInteger mId = 0;
		
		for (id obj in result) {
			NSDictionary *tmpPoint = [obj valueForKey: @"point"];
			
			mId = [[tmpPoint valueForKey: @"map_id"] intValue];
			
			MapPoint* point = [[MapPoint alloc] initWithPosition: CGPointMake([[tmpPoint valueForKey: @"x"] intValue], 
																			  [[tmpPoint valueForKey: @"y"] intValue]) andPointId:[[tmpPoint valueForKey: @"id"] intValue]];
			
			[points addObject: point];
			[point release];
		}
		
		if (debug) NSLog(@"the points' map is %d", mId);
		if (mId != 0) {
			for (int i = 0; i<[maps count]; i++) {
				Map* aMap = [maps objectAtIndex:i];
				if (debug) NSLog(@"points' map is %d", aMap.mId);
				if (aMap.mId == mId)
				{
					aMap.pointList = points;
					break;
				}
			}
		}		
		pointsLoaded = YES;
		
		if (mId != 0) {
			numWaiting++;
			[self loadEdgesWithMapId: mId];
			if (debug) NSLog(@"mid %d", mId);
			numWaiting++;
			[self loadAnnotationsWithMapId: mId];
		}
		
	}
	else if ([api.path rangeOfString: @"edges.json"].location != NSNotFound) {
		numWaiting--;
		NSMutableArray *edges = [NSMutableArray array];
		NSArray *result = (NSArray *) api.result;
		NSInteger mId = 0;
		Map* aMap = nil;
		for (id obj in result) {
			NSDictionary *tmpEdge = [obj valueForKey: @"edge"];
			mId = [[tmpEdge valueForKey: @"map_id"] intValue];
			if (!aMap && mId != 0) {
				for (int i = 0; i<[maps count]; i++) {
					aMap = [maps objectAtIndex:i];
					if (aMap.mId == mId)
					{
						aMap = [maps objectAtIndex:i];
						break;
					}
				}
			}	
			
			NSInteger p1 = [[tmpEdge valueForKey: @"first_point_id"] intValue];
			NSInteger p2 = [[tmpEdge valueForKey: @"second_point_id"] intValue];
			id point1 = nil;
			id point2 = nil;
			
			for (int i = 0; i<[aMap.pointList count]; i++) {
				MapPoint* aPoint = [aMap.pointList objectAtIndex:i];
				if (aPoint.pId == p1) {
					point1 = aPoint;
				} 
				if (aPoint.pId == p2) {
					point2 = aPoint;
				}
				if (point1 && point2) {
					break;
				}
			}
			Edge* anEdge = [[Edge alloc] initWithPoint1:point1 point2:point2];
			[edges addObject:anEdge];
			[anEdge release];
		}
		aMap.edgeList = edges;
		
		edgesLoaded = YES;
	}
	
	else if ([api.path rangeOfString: @"annotations.json"].location != NSNotFound) {
		numWaiting--;
		NSMutableArray *annotations = [NSMutableArray array];
		NSArray *result = (NSArray *) api.result;
		NSInteger mId = 0 ;
		Map* aMap = nil;
		for (id obj in result) {
			NSDictionary *tmpAnno = [obj valueForKey: @"annotation"];
			mId = [[tmpAnno valueForKey: @"map_id"] intValue];
			if ((!aMap) && (mId != 0)) {
				for (int i = 0; i<[maps count]; i++) {
					aMap = [maps objectAtIndex:i];
					if (aMap.mId == mId)
					{
						aMap = [maps objectAtIndex:i];
						break;
					}
				}
			}	
			
			NSInteger p = [[tmpAnno valueForKey: @"point_id"] intValue];
			id point = nil;
			MapPoint* aPoint;
			for (int i = 0; i<[aMap.pointList count]; i++) {
				aPoint = [aMap.pointList objectAtIndex:i];
				if (aPoint.pId == p) {
					break;
				}
			}
			Annotation* anAnno = [Annotation annotationWithAnnotationType:kAnnoStair inlevel:aMap WithPosition:aPoint.position title:@"" content:@""];
			[annotations addObject:anAnno];
		}
		if (aMap.annotationList) {
			for (int i = 0; i<[annotations count]; i++) {
				[aMap addAnnotation:[annotations objectAtIndex:i]];
			}
		} else {
			aMap.annotationList = [NSMutableArray arrayWithArray:annotations];
		}

		annotationsLoaded = YES;
	}
	
	int numLoaded = 0;
	for (int i = 0; i<[maps count]; i++) {
		Map* aMap = [maps objectAtIndex:i];
		if (aMap.pointList && aMap.annotationList) {
			numLoaded++;
		}
	}
	
	if (numWaiting==0) {
		[self finishedLoadingMap];
	}
	

	if (debug) NSLog([[api result] description]);
}

- (void) loadStairs {
	if (debug) NSLog(@"%@", @"loadStairs");


	
	APIController *api = [[APIController alloc] init];
	api.debugMode = YES;
	api.delegate = self;
	Mall* theMall = [[self.viewControllers objectAtIndex:1] mall];
	NSInteger mId = theMall.mId;
	[api getAPI: [NSString stringWithFormat: @"/malls/%d/stairs.json", mId]];
	
	
}

-(void) ListViewWillAppear:(id)sender{
	//If a ShopListViewController will appear
	if ([[sender object] isKindOfClass:[ShopListViewController class]]) {
		//add the Root list button again
		UIToolbar *toolbar = ((MallViewController*)[self.viewControllers objectAtIndex:1]).toolbar;
		if (((UIBarButtonItem*)[toolbar.items objectAtIndex:0]).title == @"Root List") {
			UIBarButtonItem *barButtonItem = [toolbar.items objectAtIndex:0];	
			NSMutableArray *items = [[cityMapViewController.toolbar items] mutableCopy];
			[items removeObjectAtIndex:0];
			[items insertObject:barButtonItem atIndex:0];
			[cityMapViewController.toolbar setItems:items animated:YES];
			[items release];
			
		}
		self.viewControllers = [NSArray arrayWithObjects: masterViewController, cityMapViewController, nil];
		[self setDelegate:cityMapViewController];
	}
	
}
-(void) ShopViewWillAppear:(id)sender{
	//If a Shpview will appear
}



#pragma mark -
#pragma mark View lifecycle
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[super viewDidLoad];
	//FacebookController *fbController = [[FacebookController alloc] init];
	
	//[fbController performSelector: @selector(authorize) withObject:nil afterDelay:2];
	//[fbController authorize];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [[self.viewControllers objectAtIndex:1] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
-(void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"shop chosen" object:nil];		
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"mall chosen" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self  name:@"Listview will appear" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self  name:@"Shopview will appear"  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self  name:@"request did fail"  object:nil];
}

- (void) dealloc {
	[progress release];
	[maps release];
	[stairs release];
	[cityMapViewController release];
	[masterViewController release];
    [super dealloc];
}

@end
