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
	self.navigationItem.title = @"Shop list";
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

	NSArray* segmentArray = [NSArray arrayWithObjects:@"List",@"This level",@"Favorite",nil];
	typeOfList = [[UISegmentedControl alloc] initWithItems:segmentArray];
	[typeOfList sizeToFit];
	typeOfList.segmentedControlStyle = UISegmentedControlStyleBar;
	typeOfList.selectedSegmentIndex = 1;
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:typeOfList];
	UIBarButtonItem* category = [[UIBarButtonItem alloc]initWithTitle:@"category" style:UIBarButtonItemStyleBordered target:self action:@selector(category:) ];
	[self setToolbarItems:[NSMutableArray arrayWithObjects:barButton,category,nil] animated:YES];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorite:)];
	
}
-(void)category:(id)sender{
}
-(void)addToFavorite:(id)sender{
}
-(id)initWithMall:(Mall*)mall{
	self = [super init];
	if (self) {
		
	}
	return self;
}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    /*
     When a row is selected, set the detail view controller's detail item to 
     the item associated with the selected row.
     */
    //detailViewController.detailItem = 
    //    [NSString stringWithFormat:@"Row %d", indexPath.row];
	NSString *selectedItem = nil;
	NSString *searchingText = searchBar.text;
	if(searchWasActive &&
	   [searchingText length]!=0)
		selectedItem = [copyListOfItems objectAtIndex:indexPath.row];
	else {
		
		selectedItem = [listOfItems objectAtIndex:indexPath.row];
	}
	
	//Initialize the detail view controller and display it.
	
	Mall * chosenMall = [[[Mall alloc] init] autorelease];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"shop chosen" object:chosenMall];
	
	//cityMapViewController.detailItem = 
	//[NSString stringWithFormat:@"%@", 
	//[listOfMovies objectAtIndex:indexPath.row]];    
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
	[favoriteList release];
	[shopList release];
    [super dealloc];
}


@end
