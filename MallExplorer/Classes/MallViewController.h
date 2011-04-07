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
#import "Mall.h"

//#define MAP_ORIGIN_X 0
//#define MAP_ORIGIN_Y 46
//#define MAP_WIDTH	 703
//#define MAP_HEIGHT	 703

@interface MallViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
	CLLocationCoordinate2D coordinate;
	NSArray* mapList;
	UIPopoverController* popoverController;
	UIPopoverController* levelListController;
	UIToolbar *toolbar;
	id detailItem;
//	IBOutlet MKMapView *mapView;
//	IBOutlet UISegmentedControl *mapType;
	UIImageView* toggleTextButton;
	UIImageView* startFlagButton;
	UIImageView* goalFlagButton;
	UIImageView* pathFindingButton;
	
	// list of map view controllers
	NSMutableArray* listMapViewController;
	// the current map view controller
	MapViewController* mapViewController;
	AnnoViewController* start;
	AnnoViewController* goal;
	UILabel* titleLabel;
	UIBarItem* selectLevel;
	Mall* mall;
}

@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIImageView* toogleTextButton;
@property (nonatomic, retain) IBOutlet UIImageView* startFlagButton;
@property (nonatomic, retain) IBOutlet UIImageView* goalFlagButton;
@property (nonatomic, retain) IBOutlet UIImageView*	pathFindingButton;
@property (nonatomic, retain) IBOutlet UIBarItem*	selectLevel;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) UIPopoverController* popoverController;
@property (nonatomic, retain, readonly) Mall* mall;
//@property (nonatomic,retain)IBOutlet MKMapView *mapView;
//@property (nonatomic,retain)IBOutlet UISegmentedControl* mapType;


- (NSString *)subtitle;
- (NSString *)title;
- (IBAction) buttonClicked:(UIButton*) sender;
- (IBAction) selectLevelClicked:(UIBarButtonItem*) sender;
-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate;

-(void) loadMaps:(NSArray*) listMap andStairs:(NSArray*) stairs withDefaultMap:(Map*) defaultMap;
@end
