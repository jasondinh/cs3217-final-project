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
@synthesize maps, stairs, mapsLoaded, stairsLoaded, pointsLoaded, edgesLoaded, annotationsLoaded;

BOOL chosen,shopchosen;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		// Custom initialization
		cityMapViewController = [[[CityMapViewController alloc] initWithNibName:@"CityMapViewController" bundle:nil] retain];
		masterViewController= [[MasterViewController alloc] initWithCityMap:cityMapViewController];
		//masterViewController.cityMapViewController = 

		self.viewControllers = [NSArray arrayWithObjects: masterViewController, cityMapViewController, nil];
		[self setDelegate:cityMapViewController];
		
		//add observer for notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopChosen:) name:@"shop chosen" object:nil];		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mallChosen:) name:@"mall chosen" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ListViewWillAppear:) name:@"Listview will appear" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShopViewWillAppear:) name:@"Shopview will appear"  object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDidFail:) name:@"request did fail"  object:nil];
    }
    return self;
}

#pragma mark -
#pragma mark Nofications
-(void) requestDidFail:(id)sender{
/*	NSLog(@"REQUEST FAILED");
	RequesFailViewController * requestFail = [[RequesFailViewController alloc]init];
	[masterViewController pushViewController:requestFail animated:YES];*/
}

-(void) shopChosen:(id)sender{
		Shop* aShop = [[Shop alloc]init];
		ShopViewController* shopViewController = [[ShopViewController alloc] initWithShop:aShop] ;
	[aShop release];
		[masterViewController pushViewController:shopViewController animated:YES];
		masterViewController.delegate = shopViewController;
	
}


-(void) mallChosen:(NSNotification*) notification{
	
	id object = notification.object;
	if ([masterViewController.topViewController isKindOfClass:[MallListViewController class]]) {		
		Mall* aMall = object;
		ShopListViewController* shopListViewController = [[ShopListViewController alloc] initWithMall:aMall] ;
		[aMall release];
		masterViewController.delegate = shopListViewController;
		[masterViewController pushViewController:shopListViewController animated:YES];
		[shopListViewController loadData:nil];
		MallViewController* aMVC = [[MallViewController alloc] initWithNibName:@"MallViewController" bundle:nil];
		
		aMVC.mall = aMall;
		// load maps from something into a list of map =.=
		// load stairs from something into a list of stair =.=
		// set default map to something =.=
		// [aMVC loadMaps: andStairs: withDefaultMap:]

		
				
		
		self.viewControllers = [NSArray arrayWithObjects:masterViewController, aMVC, nil];
		
		[self loadMaps];
		
		[aMVC loadMaps:nil andStairs:nil withDefaultMap:nil];
		
		
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
	NSLog(@"%@", @"loadMaps");
	APIController *api = [[APIController alloc] init];
	api.debugMode = NO;
	api.delegate = self;
	Mall* theMall = [[self.viewControllers objectAtIndex:1] mall];
	numberMapLoaded = 0;
	NSInteger mId = theMall.mId;
	[api getAPI: [NSString stringWithFormat: @"/malls/%d/maps.json", mId]];
}

- (void) finishedLoadingMap {
	for	(int i = 0; i<[maps count]; i++)
	{
		[[maps objectAtIndex:i] buildMap];
	}
	[self loadStairs];
}

-(void) finishedLoading{	
	MallViewController* theMVC = [self.viewControllers objectAtIndex:1];
	[theMVC loadMaps:maps andStairs:stairs withDefaultMap:[maps objectAtIndex:0]];
}

- (void) serverRespond: (APIController *) api {
	if ([api.path rangeOfString: @"stairs.json"].location != NSNotFound) {		
		self.stairs = [NSMutableArray array];
		NSArray *result = (NSArray *) api.result;
		Map* aMap1 = nil;
		Map* aMap2 = nil;
		id point1 = nil;
		id point2 = nil;
		for (id obj in result) {
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
			
			NSInteger p1 = [[tmpStair valueForKey: @"annotation_first_id"] intValue];
			NSInteger p2 = [[tmpStair valueForKey: @"annotation_second_id"] intValue];			
			for (int i = 0; i<[aMap1.pointList count]; i++) {
				MapPoint* aPoint = [aMap1.pointList objectAtIndex:i];
				if (aPoint.pId == p1) {
					point1 = aPoint;
					break;
				} 
			}
			for (int i = 0; i<[aMap2.pointList count]; i++) {
				MapPoint* aPoint = [aMap2.pointList objectAtIndex:i];
				if (aPoint.pId == p2) {
					point2 = aPoint;
					break;
				} 
			}
			Edge* anEdge = [[Edge alloc] initWithPoint1:point1 point2:point2];
			[stairs addObject:anEdge];
		}
		[self finishedLoading];
		return;
	}	
	
	if ([api.path rangeOfString: @"maps.json"].location != NSNotFound) {
		
		NSArray *result = (NSArray *) api.result;
		mapsLoaded = YES;
		
		[result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			
			NSDictionary *tmpMap = [obj valueForKey: @"map"];
			
			Map* aMap  = [[Map alloc] initWithMapId: [[tmpMap valueForKey: @"id"] intValue] 
										  withLevel: [[tmpMap valueForKey: @"level"] intValue] 
											withURL: [tmpMap valueForKey: @"url"]];

			if (maps == nil) {
				maps = [[NSMutableArray array] retain];
			}
			
			[maps addObject: aMap];
		}];
		numWaiting = 0;
		[maps enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			numWaiting++;
			[self loadPointsWithMapId: ((Map *) obj).mId];
			
			
		}];
			
		
		
	}
	else if ([api.path rangeOfString: @"points.json"].location != NSNotFound) { 
		numWaiting--;
		NSMutableArray *points = [NSMutableArray array];
		
		NSArray *result = (NSArray *) api.result;
		NSInteger mId;
		
		for (id obj in result) {
			NSDictionary *tmpPoint = [obj valueForKey: @"point"];
			
			mId = [[tmpPoint valueForKey: @"map_id"] intValue];
			
			MapPoint* point = [[MapPoint alloc] initWithPosition: CGPointMake([[tmpPoint valueForKey: @"x"] intValue], 
																			  [[tmpPoint valueForKey: @"y"] intValue]) andPointId:[[tmpPoint valueForKey: @"id"] intValue]];
			
			[points addObject: point];
		}
		
		
		if (mId != 0) {
			for (int i = 0; i<[maps count]; i++) {
				Map* aMap = [maps objectAtIndex:i];
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
			numWaiting++;
			[self loadAnnotationsWithMapId: mId];
		}
		
	}
	else if ([api.path rangeOfString: @"edges.json"].location != NSNotFound) {
		numWaiting--;
		NSMutableArray *edges = [NSMutableArray array];
		NSArray *result = (NSArray *) api.result;
		NSInteger mId;
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
		}
		aMap.edgeList = edges;
		
		edgesLoaded = YES;
	}
	
	else if ([api.path rangeOfString: @"annotations.json"].location != NSNotFound) {
		numWaiting--;
		NSMutableArray *annotations = [NSMutableArray array];
		NSArray *result = (NSArray *) api.result;
		NSInteger mId;
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
					point = aPoint;
					break;
				}
			}
			Annotation* anAnno = [Annotation annotationWithAnnotationType:kAnnoShop inlevel:aMap WithPosition:aPoint.position title:@"" content:@""];
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
	

	NSLog([[api result] description]);
}

- (void) loadStairs {
	NSLog(@"%@", @"loadStairs");
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
	[maps release];
	[stairs release];
	[cityMapViewController release];
	[masterViewController release];
    [super dealloc];
}

@end
