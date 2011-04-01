//
//  MallExplorerViewController.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Updated by Dam Tuan Long on 29 Mar 2011 :add city map
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MasterViewController.h"
#import "CityMapViewController.h"


@interface MallExplorerViewController : UISplitViewController<MKMapViewDelegate,CLLocationManagerDelegate> {
	UIViewController* cityMapViewController;
	UIViewController* masterViewController;

}

@end

