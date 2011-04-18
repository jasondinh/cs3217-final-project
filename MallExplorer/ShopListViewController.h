//
//  ShopListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Owner : Dam Tuan Long
#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "Mall.h"


@interface ShopListViewController : ListViewController {
	NSMutableArray* thisLevelList;
	NSMutableArray* shopList;
	Mall *mall;
	id delegate;
	BOOL shopLoaded;
}
@property BOOL shopLoaded;
@property (retain) 	id delegate;
@property (nonatomic,retain) Mall *mall;
@property (nonatomic,retain) NSMutableArray* thisLevelList;
@property (nonatomic,retain) NSMutableArray* shopList;
-(id)initWithMall:(Mall*)mall;
//REQUIRES:
//MODIFIES: self
//EFFECTS: return a ShopListViewController.



//-(void)addToFavorite:(id)sender;
@end
