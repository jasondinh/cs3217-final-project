    //
//  MallListViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MallListViewController.h"


@implementation MallListViewController
@synthesize favoriteList,mallList;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	listOfItems = [[NSMutableArray alloc] init];
	 [listOfItems addObject:@"Vivocity"];
	 [listOfItems addObject:@"OG Orchard"];
	 [listOfItems addObject:@"Woodlands Point"];
	 [listOfItems addObject:@"Tanglin Shopping Centre"];
	 [listOfItems addObject:@"Orchard Plaza"];
	 [listOfItems addObject:@"Lucky Chinatown"];
	 [listOfItems addObject:@"Hougang Green Shopping Mall"];
	 copyListOfItems = [[NSMutableArray alloc]init];
	self.navigationItem.title = @"Malls list";
	 searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searching = NO;
	 letUserSelectRow = YES;
	((UINavigationController*)self.parentViewController).toolbarHidden = YES;

	 NSArray* segmentArray = [NSArray arrayWithObjects:@"List",@"Nearby",@"Favorite",nil];
	 typeOfList = [[UISegmentedControl alloc] initWithItems:segmentArray];
	 [typeOfList sizeToFit];
	 typeOfList.segmentedControlStyle = UISegmentedControlStyleBar;
	 typeOfList.selectedSegmentIndex = 1;
	 UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:typeOfList];
	 self.toolbarItems = [NSMutableArray arrayWithObject:barButton];
	 /*self.toolbarItems =[NSMutableArray arrayWithObject: [[[UIBarButtonItem alloc]
	 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
	 target:self action:@selector(doneSearching_Clicked:)] autorelease] ];*/
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
