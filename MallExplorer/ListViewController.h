//
//  ListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListViewController : UITableViewController <UISearchBarDelegate,UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate
>{
	NSMutableArray *listOfItems;
	NSMutableArray *copyListOfItems;
	UISearchBar * searchBar;
	UISegmentedControl* typeOfList;
	BOOL searching;
	BOOL letUserSelectRow;
}
@property (retain) NSMutableArray* listOfItems;
@property (retain) IBOutlet UISearchBar *searchBar;
@property (retain) NSMutableArray* copyListOfItems;
@property (retain) IBOutlet UISegmentedControl* typeOfList;


- (void) searchTableView;
- (void) doneSearching_Clicked:(id) sender;

@end
