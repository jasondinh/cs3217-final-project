//
//  ListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// Owner: Dam Tuan Long
#import <UIKit/UIKit.h>
#import "APIController.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"

@interface ListViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate,UINavigationControllerDelegate
, APIDelegate,EGORefreshTableHeaderDelegate>{
	//OVERVIEW: this class is the parent of MallListViewController and ShopListViewController
	UISearchDisplayController *displayController;
	NSMutableArray *listOfItems;
	UISegmentedControl* typeOfList;
	
	//used for searching
	NSMutableArray *copyListOfItems;
	UISearchBar * searchBar;
    NSString		*savedSearchTerm;
    NSInteger		savedScopeButtonIndex;
    BOOL			searchWasActive;
	
	//loading display
	MBProgressHUD *progress;
	BOOL _reloading;
	EGORefreshTableHeaderView *_refreshHeaderView;

}

@property (retain) IBOutlet UISearchBar *searchBar;
@property (retain) IBOutlet UISegmentedControl* typeOfList;
@property (retain) IBOutlet UISearchDisplayController *displayController;
@property (retain) NSArray* listOfItems;
@property (retain) NSMutableArray* copyListOfItems;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property BOOL searchWasActive;
@property (retain) MBProgressHUD *progress;


-(void)loadData:(id)sender;
//REQUIRES:self != nil
//MODIFIES: listOfItem
//EFFECTS: override this method, used to load data for tableview

@end
