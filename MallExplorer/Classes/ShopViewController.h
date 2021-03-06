//
//  ShopViewController.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Owner : Dam Tuan Long
#import <UIKit/UIKit.h>
#import "AnnoViewController.h"
#import "Shop.h"

@interface ShopViewController : UITabBarController<UINavigationControllerDelegate> {
	//OVERVIEW: a UITabBar controller that manage 3 tabs: OVERVIEW, COMMENTS,FACEBOOK
	//			provides information of a shop.
	
	
	Annotation* annotation;
	Shop* theShop;
}
@property (retain) Shop* theShop;
@property (retain) Annotation* annotation;
-(id)loadShop:(Shop*)aShop;
//REQUIRES:
//MODIFIES:self
//EFFECTS: return a ShopViewController with information
//			obtained from aShop
@end
