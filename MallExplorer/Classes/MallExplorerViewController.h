//
//  MallExplorerViewController.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Updated by Dam Tuan Long on 29 Mar 2011 :add city map
//
//	Owner : Dam Tuan Long
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MasterViewController.h"
#import "CityMapViewController.h"
#import "APIController.h"
#import "Mall.h"


@interface MallExplorerViewController : UISplitViewController<MKMapViewDelegate,CLLocationManagerDelegate,APIDelegate, UIPopoverControllerDelegate> {
	CityMapViewController* cityMapViewController;
	MasterViewController* masterViewController;
	
	MBProgressHUD* progress;
	Mall* currentLoadedMall;
	NSMutableArray *maps;
	NSMutableArray *stairs;
	NSArray* shopList;
	BOOL mallLoaded;
	BOOL shopListLoaded;
	BOOL mapsLoaded;
	BOOL stairsLoaded;
	BOOL pointsLoaded;
	BOOL edgesLoaded;
	BOOL annotationsLoaded;
	int numberMapLoaded;
	int numWaiting;
}

@property (retain) NSArray *maps;
@property (retain) NSArray *stairs;
@property (retain) MBProgressHUD* progress;

@property BOOL shopListLoaded;
@property BOOL mallLoaded;
@property BOOL mapsLoaded;
@property BOOL stairsLoaded;
@property BOOL pointsLoaded;
@property BOOL edgesLoaded;
@property BOOL annotationsLoaded;
@end

