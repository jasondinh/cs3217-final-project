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


@interface MallExplorerViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate> {
	IBOutlet MKMapView *mapView;
	IBOutlet UISegmentedControl *mapType;

}

@property (nonatomic,retain)IBOutlet MKMapView *mapView;
@property (nonatomic,retain)IBOutlet UISegmentedControl* mapType;

- (IBAction)changeType:(id)sender;
@end

