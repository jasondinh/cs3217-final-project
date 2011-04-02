//
//  MallViewController.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "AnnoViewController.h"

@interface MallViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate>{
	CLLocationCoordinate2D coordinate;
	NSArray* mapList;
	UIPopoverController *popoverController;
	UIToolbar *toolbar;
	id detailItem;
//	IBOutlet MKMapView *mapView;
//	IBOutlet UISegmentedControl *mapType;
	UIImageView* toggleTextButton;
	UIImageView* startFlagButton;
	UIImageView* goalFlagButton;
	UIImageView* pathFindingButton;
	MapViewController* mapViewController;
}

@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIImageView* toogleTextButton;
@property (nonatomic, retain) IBOutlet UIImageView* startFlagButton;
@property (nonatomic, retain) IBOutlet UIImageView* goalFlagButton;
@property (nonatomic, retain) IBOutlet UIImageView*	pathFindingButton;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) UIPopoverController* popoverController;
//@property (nonatomic,retain)IBOutlet MKMapView *mapView;
//@property (nonatomic,retain)IBOutlet UISegmentedControl* mapType;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;
- (NSString *)subtitle;
- (NSString *)title;
- (IBAction) buttonClicked:(UIButton*) sender;

@end
