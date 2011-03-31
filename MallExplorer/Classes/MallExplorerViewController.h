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
#import "MallListViewController.h"
#import "CityMapViewController.h"


@interface MallExplorerViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate> {
	IBOutlet MKMapView *mapView;
	IBOutlet UISegmentedControl *mapType;
	CityMapViewController* cityMapViewController;
	MallListViewController* mallListViewController;
	UISplitViewController * splitViewController;

}

@property (nonatomic,retain)IBOutlet MKMapView *mapView;
@property (nonatomic,retain)IBOutlet UISegmentedControl* mapType;
@property (nonatomic,retain) IBOutlet CityMapViewController* cityMapViewController;
@property (nonatomic,retain) IBOutlet MallListViewController* mallListViewController;
@property (nonatomic,retain) IBOutlet UISplitViewController* spiltViewController;
- (IBAction)changeType:(id)sender;
@end

