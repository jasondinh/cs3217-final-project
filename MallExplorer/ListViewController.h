//
//  ListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIController.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"

@interface ListViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate,UINavigationControllerDelegate
, APIDelegate>{
	UISearchDisplayController *displayController;
	NSMutableArray *listOfItems;
	NSMutableArray *copyListOfItems;
	
	UISearchBar * searchBar;
	UISegmentedControl* typeOfList;
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
	
	MBProgressHUD *progress;
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
	EGORefreshTableHeaderView *_refreshHeaderView;

}
@property (retain) NSArray* listOfItems;
@property (retain) IBOutlet UISearchBar *searchBar;
@property (retain) IBOutlet UISegmentedControl* typeOfList;
@property (retain) IBOutlet UISearchDisplayController *displayController;
@property (retain) NSMutableArray* copyListOfItems;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property BOOL searchWasActive;
@property (retain) MBProgressHUD *progress;


@end
