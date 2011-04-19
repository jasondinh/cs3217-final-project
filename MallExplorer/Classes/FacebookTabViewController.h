//
//  FacebookTabViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Owner: Dam Tuan Long
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class FacebookController;
@class Shop;
@interface FacebookTabViewController : UIViewController {
	//OVERVIEW: this class implements the FACEBOOK tab of  ShopViewController
	Shop *shop;
	FacebookController *fb;
	CLLocationCoordinate2D location;
	BOOL loadNewShops;
	UITableView *tableView;
	NSArray *locationList;
}

-(id) initWithShop:(Shop*) aShop;
//REQUIRES:
//MODIFIES:self
//EFFECTS: return a FacebookTabViewController with information
//			obtained from aShop
@property (retain) UITableView *tableView;
@property 	BOOL loadNewShops;
@property CLLocationCoordinate2D location;
@property (retain) Shop *shop;
@property (retain) FacebookController *fb;
@property (retain) NSArray *locationList;

@end
