//
//  MallListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityMapViewController;
@class MBProgressHUD;
@interface MasterViewController : UINavigationController {
	MBProgressHUD *progress;
	CityMapViewController* cityMapViewController;
}
@property (retain) MBProgressHUD *progress;
@property (retain) IBOutlet CityMapViewController* cityMapViewController;
//-(void)pushViewController:(UIViewController*) controller animated:(BOOL)animated;


@end

