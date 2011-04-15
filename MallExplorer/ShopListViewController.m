    //
//  ShopListViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopListViewController.h"
#import "Shop.h"

@implementation ShopListViewController
@synthesize thisLevelList,shopList, mall,delegate;

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

-(void)loadData:(id)sender{
	
	APIController *api = [[APIController alloc] init];
	api.debugMode = YES;
	api.delegate = self;
	NSInteger mId = mall.mId;
	[api getAPI: [NSString stringWithFormat: @"/malls/%d/shops.json", mId]];
	

}

-(void) cacheRespond:(APIController *)apiController {
	
}

-(void)serverRespond:(APIController *)apiController{
	
	NSArray *shops = (NSArray *) apiController.result;
	NSMutableArray *tmpShops = [NSMutableArray array];
	[shops enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSDictionary *tmp = [obj valueForKey: @"shop"];
		Shop *shop = [[Shop alloc] initWithId: [[tmp valueForKey: @"id"] intValue] 
									 andLevel:[[[tmp valueForKey: @"map"] valueForKey: @"map"] valueForKey: @"level"] 
									  andUnit:[tmp valueForKey: @"unit"] 
								  andShopName:[tmp valueForKey: @"name"] 
							   andDescription:[tmp valueForKey: @"description"]];
		[tmpShops addObject: shop];
	}];
	
	self.shopList = [tmpShops mutableCopy];
	self.listOfItems = [[NSMutableArray alloc]init];
	for (Shop* aShop in shopList){
		[listOfItems addObject:aShop.shopName];
	}
	[self.tableView reloadData];
	[progress hide:YES];
	NSLog(@"ceom");
	if (_reloading){
		NSLog(@"ceom");
		[self doneLoadingTableViewData];
	}
}
- (void) requestDidStart: (APIController *) apiController {
	_reloading = YES;
	[progress show:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	listOfItems = [[NSMutableArray alloc] init];
	copyListOfItems = [[NSMutableArray alloc]init];
	self.navigationItem.title = mall.name;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

	//NSArray* segmentArray = [NSArray arrayWithObjects:@"List",@"This level",@"Favorite",nil];
	NSArray* segmentArray = [NSArray arrayWithObjects:@"ALl",@"This level",nil];
	typeOfList = [[UISegmentedControl alloc] initWithItems:segmentArray];
	[typeOfList sizeToFit];
	typeOfList.segmentedControlStyle = UISegmentedControlStyleBar;
	typeOfList.selectedSegmentIndex = 1;
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:typeOfList];
	// UIBarButtonItem* category = [[UIBarButtonItem alloc]initWithTitle:@"category" style:UIBarButtonItemStyleBordered target:self action:@selector(category:) ];
	[self setToolbarItems:[NSMutableArray arrayWithObjects:barButton,nil] animated:YES];
	//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorite:)];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopChosen:) name:@"shop chosen" object:nil];	
	
}
-(void)shopChosen:(id)sender{
	for (int i =0;i<[listOfItems count];i++){
		
		if ([listOfItems objectAtIndex:i] == ((Shop*)[sender object]).shopName) {
			[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] 
										animated:YES 
								  scrollPosition:UITableViewScrollPositionMiddle];			
		}
	}
	
}

-(void) populateNearbyList:(id)sender{
	//CLLocationCoordinate2D coordinate = self.cityMapViewController.mapView.userLocation.coordinate;
	[thisLevelList removeAllObjects];
	for (Shop* aShop in shopList) {
		//if () {
		//	
		//}
	}
}
-(void)category:(id)sender{
}
-(void)addToFavorite:(id)sender{
}
-(id)initWithMall:(Mall*)mall{
		self.mall = mall;

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

	for(Shop* aShop in shopList){
		if (aShop.shopName == selectedItem) 
			[[NSNotificationCenter defaultCenter] postNotificationName:@"shop chosen" 
																object:aShop];
	}	
	//cityMapViewController.detailItem = 
	//[NSString stringWithFormat:@"%@", 
	//[listOfMovies objectAtIndex:indexPath.row]];    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
	NSString *string = nil;
	if (self.tableView == self.searchDisplayController.searchResultsTableView)
	{
        string = [self.copyListOfItems objectAtIndex:indexPath.row];
    }
	else
	{
        string = [self.listOfItems objectAtIndex:indexPath.row];
    }
	
	for(Shop* aShop in shopList){
		if (aShop.shopName == string) 
			[[NSNotificationCenter defaultCenter] postNotificationName:@"shop enter" 
																object:aShop];
	}
	
}- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
	[mall release];
	[thisLevelList release];
	[shopList release];
    [super dealloc];
}


@end
