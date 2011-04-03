    //
//  ShopListViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopListViewController.h"


@implementation ShopListViewController
@synthesize favoriteList,shopList;

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
	
	listOfItems = [[NSMutableArray alloc] init];
	[listOfItems addObject:@"KFC"];
	[listOfItems addObject:@"Mac Donald"];
	[listOfItems addObject:@"KKK"];
	[listOfItems addObject:@"Triumph"];
	[listOfItems addObject:@"abc"];
	[listOfItems addObject:@"Lucky Chinatown"];
	[listOfItems addObject:@"Hougang Green Shopping Mall"];
	copyListOfItems = [[NSMutableArray alloc]init];
	self.navigationItem.title = @"Shops list";
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	searching = NO;
	letUserSelectRow = YES;
	NSArray* segmentArray = [NSArray arrayWithObjects:@"List",@"This level",@"Favorite",nil];
	typeOfList = [[UISegmentedControl alloc] initWithItems:segmentArray];
	[typeOfList sizeToFit];
	typeOfList.segmentedControlStyle = UISegmentedControlStyleBar;
	typeOfList.selectedSegmentIndex = 1;
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:typeOfList];
	UIBarButtonItem* category = [[UIBarButtonItem alloc]initWithTitle:@"category" style:UIBarButtonItemStyleBordered target:self action:@selector(category:) ];
	self.toolbarItems = [NSMutableArray arrayWithObjects:barButton,category,nil];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorite:)];

	
}
-(void)category:(id)sender{
}
-(void)addToFavorite:(id)sender{
}
-(id)initWithMall:(Mall *)mall{
	return self;
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
