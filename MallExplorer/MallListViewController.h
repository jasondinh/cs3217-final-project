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

@interface MallListViewController : ListViewController{

	CityMapViewController *cityMapViewController;
	NSMutableArray* favoriteList;
	NSMutableArray* mallList;
}
@property (retain) CityMapViewController* cityMapViewController;
@property (nonatomic,retain) NSMutableArray* favoriteList;
@property (nonatomic,retain) NSMutableArray* mallList;
//- (id)initWithMalls: (NSArray *) malls ;
-(id)  initWithCityMap:(CityMapViewController*)cityMap;
-(void) loadData:(id)sender;

@end
