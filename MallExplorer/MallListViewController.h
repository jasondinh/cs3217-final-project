//
//  MallListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "CityMapViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface MallListViewController : ListViewController <EGORefreshTableHeaderDelegate>{

	CityMapViewController *cityMapViewController;
	NSMutableArray* nearbyList;
	NSMutableArray* mallList;

	

}
@property (retain) CityMapViewController* cityMapViewController;
@property (nonatomic,retain) NSMutableArray* nearbyList;
@property (nonatomic,retain) NSMutableArray* mallList;
//- (id)initWithMalls: (NSArray *) malls ;
-(id)  initWithCityMap:(CityMapViewController*)cityMap;
-(void) loadData:(id)sender;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;


@end
