//
//  MallListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityMapViewController;
@interface MasterViewController : UINavigationController<UITableViewDelegate, UITableViewDataSource> {
	
	CityMapViewController* cityMapViewController;
}

@property (nonatomic,retain) IBOutlet CityMapViewController* cityMapViewController;
//-(void)pushViewController:(UIViewController*) controller animated:(BOOL)animated;

@end

