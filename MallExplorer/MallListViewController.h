//
//  MallListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Owner: Dam Tuan Long
#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "CityMapViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface MallListViewController : ListViewController <EGORefreshTableHeaderDelegate>{
	//Overview: this class is a subclass of ListViewController , to display list of malls
	CityMapViewController *cityMapViewController;
	NSMutableArray* nearbyList;
	NSMutableArray* mallList;
}
@property (retain) CityMapViewController* cityMapViewController;
@property (nonatomic,retain) NSMutableArray* nearbyList;
@property (nonatomic,retain) NSMutableArray* mallList;


-(id)  initWithCityMap:(CityMapViewController*)cityMap;
//REQUIRES:
//MODIFIES: self
//EFFECTS: return a MallListViewController with cityMapViewController = cityMap


//- (void)reloadTableViewDataSource;
//- (void)doneLoadingTableViewData;


@end
