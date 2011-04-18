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


@interface MallExplorerViewController : UISplitViewController<MKMapViewDelegate,CLLocationManagerDelegate,APIDelegate> {
	CityMapViewController* cityMapViewController;
	MasterViewController* masterViewController;
	
	NSMutableArray *maps;
	NSMutableArray *stairs;
	
	NSArray* shopList;
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

@property BOOL mapsLoaded;
@property BOOL stairsLoaded;
@property BOOL pointsLoaded;
@property BOOL edgesLoaded;
@property BOOL annotationsLoaded;
@end

