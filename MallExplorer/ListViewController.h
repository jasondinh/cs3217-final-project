//
//  ListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListViewController : UITableViewController <UISearchBarDelegate>{
	NSMutableArray* listOfItems;
	NSMutableArray*copyListOfItems;
	UISearchBar * searchBar;
	UISegmentedControl* typeOfList;
	BOOL searching;
	BOOL letUserSelectRow;
}
@property (nonatomic,retain) NSMutableArray* listOfItems;
@property (nonatomic,retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic,retain) NSMutableArray* copyListOfItems;
@property (nonatomic,retain) IBOutlet UISegmentedControl* typeOfList;

- (void) searchTableView;
- (void) doneSearching_Clicked:(id) sender;

@end
