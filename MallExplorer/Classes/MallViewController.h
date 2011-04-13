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

@interface MallViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>{
	CLLocationCoordinate2D coordinate;
	UIPopoverController* popoverController;
	UIPopoverController* levelListController;
	UIToolbar *toolbar;
	id detailItem;
	UIImageView* toggleTextButton;
	UIImageView* startFlagButton;
	UIImageView* goalFlagButton;
	UIImageView* pathFindingButton;
	UIImageView* resetButton;
	UIBarButtonItem* reset;
	
	// list of map view controllers
	NSMutableArray* listMapViewController;
	// the current map view controller
	MapViewController* mapViewController;
	AnnoViewController* start;
	AnnoViewController* goal;
	UILabel* titleLabel;
	UIBarItem* selectLevel;
	BOOL displayAllTitleMode;
	Mall* mall;
}

@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;
@property (nonatomic, retain) IBOutlet UIImageView* toggleTextButton;
@property (nonatomic, retain) IBOutlet UIImageView* startFlagButton;
@property (nonatomic, retain) IBOutlet UIImageView* goalFlagButton;
@property (nonatomic, retain) IBOutlet UIImageView*	pathFindingButton;
@property (nonatomic, retain) IBOutlet UIImageView* resetButton;
@property (nonatomic, retain) IBOutlet UIBarItem*	selectLevel;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) UIPopoverController* popoverController;
@property (nonatomic, retain, readonly) Mall* mall;



- (NSString *)subtitle;
- (NSString *)title;
- (IBAction) buttonClicked:(UIButton*) sender;
- (IBAction) selectLevelClicked:(UIBarButtonItem*) sender;

// since the data for the mall object will be populated after the mall is chosen, this method is called after init, when the app needs to load maps to mall
-(void) loadMaps:(NSArray*) listMap andStairs:(NSArray*) stairs withDefaultMap:(Map*) defaultMap;
@end
