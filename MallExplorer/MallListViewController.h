//
//  MallListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"


@interface MallListViewController : ListViewController {
	NSMutableArray* favoriteList;
	NSMutableArray* mallList;
}

@property (nonatomic,retain) NSMutableArray* favoriteList;
@property (nonatomic,retain) NSMutableArray* mallList;
- (id) initWithMalls: (NSArray *) malls ;
@end
