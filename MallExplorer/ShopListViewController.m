    //
//  ShopListViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopListViewController.h"
#import "MallViewController.h"
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
	progress = [[MBProgressHUD alloc] initWithView: self.view];
	[self.view addSubview: progress];
	[progress release];
	
	APIController *api = [[APIController alloc] init];
	api.debugMode = NO;
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
	if (_reloading)
		[self doneLoadingTableViewData];
	self.typeOfList.selectedSegmentIndex = 0;
	
}
- (void) requestDidStart: (APIController *) apiController {
	_reloading = YES;
	[progress show:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	thisLevelList = [[NSMutableArray alloc]init];
	listOfItems = [[NSMutableArray alloc] init];
	copyListOfItems = [[NSMutableArray alloc]init];
	self.navigationItem.title = mall.name;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

	//NSArray* segmentArray = [NSArray arrayWithObjects:@"List",@"This level",@"Favorite",nil];
	NSArray* segmentArray = [NSArray arrayWithObjects:@"All",@"This level",nil];
	typeOfList = [[UISegmentedControl alloc] initWithItems:segmentArray];
	[typeOfList addTarget:self action:@selector(changeListType:) forControlEvents:UIControlEventValueChanged];
	[typeOfList sizeToFit];
	typeOfList.segmentedControlStyle = UISegmentedControlStyleBar;
	typeOfList.selectedSegmentIndex = 0;
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:typeOfList];
	

	// UIBarButtonItem* category = [[UIBarButtonItem alloc]initWithTitle:@"category" style:UIBarButtonItemStyleBordered target:self action:@selector(category:) ];
	[self setToolbarItems:[NSMutableArray arrayWithObjects:barButton,nil] animated:YES];
	//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorite:)];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopChosen:) name:@"shop chosen" object:nil];	
	
}

-(void)changeListType:(id)sender{
	
	if(typeOfList.selectedSegmentIndex==0){ // List
		[listOfItems removeAllObjects];
		for (Shop* aShop in shopList) {
			[listOfItems addObject:aShop.shopName];
		}
		[self.tableView reloadData];
	}
	else if (typeOfList.selectedSegmentIndex==1){ //This level
		
		[self populateLevelList:nil ];
		[listOfItems removeAllObjects];
		for (Shop* aShop in thisLevelList) {
			[listOfItems addObject:aShop.shopName];
		}
		[self.tableView reloadData];
	}
	else if (typeOfList.selectedSegmentIndex==2){//favorite
		
	}
	
}
-(void)shopChosen:(id)sender{
	if (!displayController.active)
	{

		
		for (int i =0;i<[listOfItems count];i++){
			if ([[listOfItems objectAtIndex:i] isEqualToString: ((Shop*)[sender object]).shopName]) {
				
				[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] 
											animated:YES 
									  scrollPosition:UITableViewScrollPositionMiddle];	
				
			}
		}
    }
	else
	{
		for (int i =0;i<[copyListOfItems count];i++){
			if ([[copyListOfItems objectAtIndex:i] isEqualToString:((Shop*)[sender object]).shopName]) {
				[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] 
											animated:YES 
									  scrollPosition:UITableViewScrollPositionMiddle];		
				
			}
		}
    }
	
	
}

-(void) populateLevelList:(id)sender{
	//CLLocationCoordinate2D coordinate = self.cityMapViewController.mapView.userLocation.coordinate;
	[thisLevelList removeAllObjects];
	NSArray *listOfString = [((MallViewController*)self.delegate).titleLabel.text componentsSeparatedByString: @" "	];
	
	NSString *_level = [listOfString lastObject];
	for (Shop* aShop in shopList) {
		if([aShop.level isEqualToString:_level])
			[thisLevelList addObject:aShop];		

	}

	
}
-(void)category:(id)sender{
}
-(void)addToFavorite:(id)sender{
}
-(id)initWithMall:(Mall*)_mall{
		self.mall = _mall;

	return self;
}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *string = nil;
	if (displayController.active)
	{
        string = [self.copyListOfItems objectAtIndex:indexPath.row];
    }
	else
	{
        string = [self.listOfItems objectAtIndex:indexPath.row];
    }
	
	for(Shop* aShop in shopList){
		if (aShop.shopName == string) 
			[[NSNotificationCenter defaultCenter] postNotificationName:@"shop chosen"
																object:aShop];
	}
	
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
