//
//  CityMapViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface CityMapViewController : UIViewController <UIPopoverControllerDelegate ,MKMapViewDelegate,CLLocationManagerDelegate,UISplitViewControllerDelegate>{
	UIPopoverController *popoverController;
	UIToolbar *toolbar;
	id detailItem;
	IBOutlet MKMapView *mapView;
	IBOutlet UISegmentedControl *mapType;
	

}

@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic,retain) id detailItem;

@property (nonatomic,retain)IBOutlet MKMapView *mapView;
@property (nonatomic,retain)IBOutlet UISegmentedControl* mapType;
- (IBAction)changeType:(id)sender;
@end
