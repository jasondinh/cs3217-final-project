    //
//  ShopListViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Owner : Dam Tuan Long
#import "ShopListViewController.h"
#import "MallViewController.h"
#import "Shop.h"
#import "Annotation.h"
@implementation ShopListViewController
@synthesize thisLevelList,shopList, mall,delegate, shopLoaded;

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
	NSArray *shops = (NSArray *) apiController.result;
	NSMutableArray *tmpShops = [NSMutableArray array];
	[shops enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSDictionary *tmp = [obj valueForKey: @"shop"];
		Shop *shop = [[Shop alloc] initWithId: [[tmp valueForKey: @"id"] intValue] 
									 andLevel:[[[tmp valueForKey: @"map"] valueForKey: @"map"] valueForKey: @"level"] 
									  andUnit:[tmp valueForKey: @"unit"] 
								  andShopName:[tmp valueForKey: @"name"] 
							   andDescription:[tmp valueForKey: @"description"]];
		NSInteger pid = [[tmp valueForKey: @"point_id"] intValue];
		shop.pId = pid;
		[tmpShops addObject: shop];
		[shop release];
	}];
	//NSLog([apiController.result description]);
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
	self.shopLoaded = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"shop list loaded" object:shopList];
}

-(void)serverRespond:(APIController *)apiController{
	
	NSArray *malls = (NSArray *) apiController.result;
	NSEnumerator *e = [malls objectEnumerator];
	NSDictionary *tmpMall;
	NSMutableArray *tmpMalls = [NSMutableArray array];
	while (tmpMall = [e nextObject]) {
		NSDictionary *tmp = [tmpMall valueForKey: @"shop"];
		
		Shop *mall = [[Shop alloc] initWithId: [[tmp valueForKey: @"id"] intValue] 
									 andLevel:[[[tmp valueForKey: @"map"] valueForKey: @"map"] valueForKey: @"level"] 
									  andUnit:[tmp valueForKey: @"unit"] 
								  andShopName:[tmp valueForKey: @"name"] 
							   andDescription:[tmp valueForKey: @"description"]];
		
		[tmpMalls addObject: mall];
		[mall release];
	}
	
	
	if ([listOfItems count] !=0) {// Cache did respond
		NSMutableArray *reloadIndexPaths = [NSMutableArray array];
		NSMutableArray *removeIndexPaths = [NSMutableArray array];
		for (int i=[shopList count]-1; i>=0 ; i--) {// remove rows
			BOOL has = NO;
			for (int x = 0; x < [tmpMalls count]; x++) {
				if ((((Shop*)[tmpMalls objectAtIndex:x]).sId == ((Shop*)[shopList objectAtIndex:i]).sId)) {
					has =YES;
					
					if (![((Shop*)[tmpMalls objectAtIndex:x]).shopName isEqualToString:((Shop*)[shopList objectAtIndex:i]).shopName]) {
						[shopList replaceObjectAtIndex: i withObject: [tmpMalls objectAtIndex: x]];
						[reloadIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
					}
				}
				
			}
			if (!has) {
				[shopList removeObjectAtIndex:i];
				[removeIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
			}
		}
		
		self.listOfItems = [[NSMutableArray alloc]init];
		for (Shop* aMall in shopList){
			[listOfItems addObject:aMall.shopName];
		}
		
		
		
		
		NSMutableArray *insertIndexPaths = [NSMutableArray array];
		for (int i=0; i< [tmpMalls count]; i++) {//insert rows
			if (i >= [shopList count] || !(((Shop*)[tmpMalls objectAtIndex:i]).sId == ((Shop*)[shopList objectAtIndex:i]).sId)){
				[shopList insertObject:((Shop*)[tmpMalls objectAtIndex:i]) atIndex:i];
				[insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
				
			}
		}
		self.listOfItems = [[NSMutableArray alloc]init];
		for (Shop* aMall in shopList){
			[listOfItems addObject:aMall.shopName];
		}
		//update table
		[self.tableView beginUpdates];
		[self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationMiddle];
		[self.tableView deleteRowsAtIndexPaths:removeIndexPaths withRowAnimation:UITableViewRowAnimationRight];
		[self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
		[self.tableView endUpdates];
		
	} else { // cache did not respond
		
		self.shopList = [tmpMalls mutableCopy];
		self.listOfItems = [[NSMutableArray alloc]init];
		for (Shop* aMall in shopList){
			[listOfItems addObject:aMall.shopName];
		}
		[self.tableView reloadData];	
	}
	[tmpMall release];
	[progress hide:YES];
	//cityMapViewController.shopList = shopList;
	//[cityMapViewController reloadView:nil];
	if (_reloading){
		[self doneLoadingTableViewData];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"shop list loaded" object:shopList];
	[apiController release];
	
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
	[barButton release];
	shopLoaded = NO;
	
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
	
//	[[NSNotificationCenter defaultCenter] postNotificationName:@"shop chosen" object:sender];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"this shop is chosen" object:[sender object]];
	
	
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
	//REQUIRES:
	//MODIFIES: self
	//EFFECTS: return a ShopListViewController.
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
			[[NSNotificationCenter defaultCenter] postNotificationName:@"shop enter"
																object:aShop];
	}
	
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *kCellID = @"cellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	NSString *string = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        string = [self.copyListOfItems objectAtIndex:indexPath.row];
    }
	else
	{
        string = [self.listOfItems objectAtIndex:indexPath.row];
    }
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.textLabel.text = string;
	return cell;
}
/*- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
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
	
}*/
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
	[mall release];
	[thisLevelList release];
	[shopList release];
    [super dealloc];
}


@end
