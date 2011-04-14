//
//  ShopListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "Mall.h"


@interface ShopListViewController : ListViewController {
	NSMutableArray* thisLevelList;
	NSMutableArray* shopList;
	Mall *mall;
}
@property (nonatomic,retain) Mall *mall;
@property (nonatomic,retain) NSMutableArray* thisLevelList;
@property (nonatomic,retain) NSMutableArray* shopList;
-(id)initWithMall:(Mall*)mall;
-(void)addToFavorite:(id)sender;
@end
