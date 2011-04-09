//
//  MallListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "APIController.h"
@class MBProgressHUD;
@interface MallListViewController : ListViewController <APIDelegate>{
	MBProgressHUD *progress;
	
	NSMutableArray* favoriteList;
	NSMutableArray* mallList;
}
@property (retain) MBProgressHUD *progress;
@property (nonatomic,retain) NSMutableArray* favoriteList;
@property (nonatomic,retain) NSMutableArray* mallList;
//- (id)initWithMalls: (NSArray *) malls ;
-(id) init;
-(void) loadData;

@end
