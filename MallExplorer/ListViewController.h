//
//  ListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIController.h"
@class MBProgressHUD;

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
