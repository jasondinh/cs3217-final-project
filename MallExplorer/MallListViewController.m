    //
//  MallListViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MallListViewController.h"
#import "APIController.h"
#import "MBProgressHUD.h"
#import "Mall.h"
#import "EGORefreshTableHeaderView.h"
#import "Constant.h"
@implementation MallListViewController
@synthesize nearbyList,mallList,cityMapViewController;

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
#pragma mark -
#pragma mark APIController


- (void)cacheRespond: (APIController *) apiController{
	NSArray *malls = (NSArray *) apiController.result;
	NSEnumerator *e = [malls objectEnumerator];
	NSDictionary *tmpMall;
	NSMutableArray *tmpMalls = [NSMutableArray array];
	while (tmpMall = [e nextObject]) {
		NSDictionary *tmp = [tmpMall valueForKey: @"mall"];
		Mall *mall = [[Mall alloc] initWithId: [[tmp valueForKey: @"id"] intValue]
									  andName:[tmp valueForKey: @"name"] 
								 andLongitude:[tmp valueForKey: @"longitude"] 
								  andLatitude:[tmp valueForKey: @"latitude"] 
								   andAddress:[tmp valueForKey: @"address"] 
									   andZip:[tmp valueForKey: @"zip"]];
		
		[tmpMalls addObject: mall];
		[mall release];

	}
	
	
	self.mallList = [tmpMalls mutableCopy];
	self.listOfItems = [[NSMutableArray alloc]init];
	for (Mall* aMall in mallList){
		[listOfItems addObject:aMall.name];
	}
	[self.tableView reloadData];
	[progress hide:YES];
	[tmpMall release];
	
	
}
- (void)serverRespond: (APIController *) apiController{

	NSArray *malls = (NSArray *) apiController.result;
	NSEnumerator *e = [malls objectEnumerator];
	NSDictionary *tmpMall;
	NSMutableArray *tmpMalls = [NSMutableArray array];
	while (tmpMall = [e nextObject]) {
		NSDictionary *tmp = [tmpMall valueForKey: @"mall"];
		Mall *mall = [[Mall alloc] initWithId: [[tmp valueForKey: @"id"] intValue]
									  andName:[tmp valueForKey: @"name"] 
								 andLongitude:[tmp valueForKey: @"longitude"] 
								  andLatitude:[tmp valueForKey: @"latitude"] 
								   andAddress:[tmp valueForKey: @"address"] 
									   andZip:[tmp valueForKey: @"zip"]];
		
		[tmpMalls addObject: mall];
		[mall release];
	}

	
	if ([listOfItems count] !=0) {
		NSMutableArray *reloadIndexPaths = [NSMutableArray array];
		NSMutableArray *removeIndexPaths = [NSMutableArray array];
		for (int i=[mallList count]-1; i>=0 ; i--) {
			BOOL has = NO;
			for (int x = 0; x < [tmpMalls count]; x++) {
				if ((((Mall*)[tmpMalls objectAtIndex:x]).mId == ((Mall*)[mallList objectAtIndex:i]).mId)) {
					has =YES;
					
					if (![((Mall*)[tmpMalls objectAtIndex:x]).name isEqualToString:((Mall*)[mallList objectAtIndex:i]).name]) {
						[mallList replaceObjectAtIndex: i withObject: [tmpMalls objectAtIndex: x]];
						[reloadIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
					}
				}
				
			}
			if (!has) {
				[mallList removeObjectAtIndex:i];
				[removeIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
			}
		}
		
		self.listOfItems = [[NSMutableArray alloc]init];
		for (Mall* aMall in mallList){
			[listOfItems addObject:aMall.name];
		}
	
		

		
		NSMutableArray *insertIndexPaths = [NSMutableArray array];
		for (int i=0; i< [tmpMalls count]; i++) {
			if (i >= [mallList count] || !(((Mall*)[tmpMalls objectAtIndex:i]).mId == ((Mall*)[mallList objectAtIndex:i]).mId)){
				[mallList insertObject:((Mall*)[tmpMalls objectAtIndex:i]) atIndex:i];
				[insertIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];

			}
		}
		self.listOfItems = [[NSMutableArray alloc]init];
		for (Mall* aMall in mallList){
			[listOfItems addObject:aMall.name];
		}
		[self.tableView beginUpdates];
		[self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationMiddle];
		[self.tableView deleteRowsAtIndexPaths:removeIndexPaths withRowAnimation:UITableViewRowAnimationRight];
		[self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
		[self.tableView endUpdates];
		
	} else {

		self.mallList = [tmpMalls mutableCopy];
		self.listOfItems = [[NSMutableArray alloc]init];
		for (Mall* aMall in mallList){
			[listOfItems addObject:aMall.name];
		}
		[self.tableView reloadData];	
	}
	[tmpMall release];
	[progress hide:YES];
	cityMapViewController.mallList = mallList;
	[cityMapViewController reloadView:nil];
	if (_reloading){
	[self doneLoadingTableViewData];
	}

}


- (void)requestFail: (APIController *) apiController{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"request did fail" object:self];
	
}
- (void) requestDidStart: (APIController *) apiController {
	_reloading = YES;
	[progress show:YES];
}




/*- (id) initWithMalls: (NSArray *) malls {
	self = [super init];
	
	if (self) {
		self.mallList = [malls mutableCopy];
		listOfItems = [[NSMutableArray alloc]init];
		for (Mall* aMall in malls){
			[listOfItems addObject:aMall.name];
		}
	}

	return self;
}*/
-(id)  initWithCityMap:(CityMapViewController*)cityMap{
	self = [super init];
	if (self) {
		cityMapViewController = cityMap;
		cityMap.mallList = mallList;
		[cityMap reloadView:nil];
	}
	return self;
}
-(void) loadData:(id)sender{

	progress = [[MBProgressHUD alloc] initWithView: self.view];
	[self.view addSubview: progress];
	[progress release];
	
	APIController *api = [[APIController alloc] init];
	api.debugMode = YES;
	api.delegate = self;
	[api getAPI: @"/malls.json"];
	typeOfList.selectedSegmentIndex =0;

}

-(void) populateNearbyList:(id)sender{
	CLLocationCoordinate2D coordinate = self.cityMapViewController.mapView.userLocation.coordinate;
	[nearbyList removeAllObjects];
	for (Mall* aMall in mallList) {
		if (fabs([aMall.latitude doubleValue]- coordinate.latitude)<NEARBY_LATITUDE &&
			fabs([aMall.longitude doubleValue] -coordinate.longitude) <NEARBY_LONGITUDE) {
			[nearbyList addObject:aMall];
		}
	}
}
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *product = nil;
	if (self.tableView == self.searchDisplayController.searchResultsTableView)
	{
        product = [self.copyListOfItems objectAtIndex:indexPath.row];
    }
	else
	{
        product = [self.listOfItems objectAtIndex:indexPath.row];
    }
	if (typeOfList.selectedSegmentIndex ==0) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"mall chosen" 
															object:[mallList objectAtIndex:indexPath.row]];

	} else if (typeOfList.selectedSegmentIndex ==1) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"mall chosen" 
															object:[nearbyList objectAtIndex:indexPath.row]];
		
	} else if (typeOfList.selectedSegmentIndex ==2) {
	}
}

-(void) cityMapSelectedMall:(id)sender{
	for (int i =0;i<[listOfItems count];i++){
		
		if ([listOfItems objectAtIndex:i] == ((Mall*)[sender object]).name) {
			[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] 
										animated:YES 
								  scrollPosition:UITableViewScrollPositionMiddle];			
		}
	}
	

}
//override
/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//    NSLog(@"em da dc goi");
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Set up the cell..
	
	NSString *tmpMall = [listOfItems objectAtIndex: indexPath.row];
	
	
	cell.textLabel.text = tmpMall;
	
	//
//	if(searching)
//		cell.textLabel.text = [copyListOfItems objectAtIndex:indexPath.row];
//	else {
//		
//		//First get the dictionary object
//		
//		cell.textLabel.text = [listOfItems objectAtIndex:indexPath.row];;
//	}
	
	return cell;
}*/

#pragma mark -
#pragma mark View lifecycle




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	
	
	// Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	

	nearbyList = [[NSMutableArray alloc]init];
	 copyListOfItems = [[NSMutableArray alloc]init];
	 self.navigationItem.title = @"Mall list";
	 searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

	//self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData:)];
	
	// NSArray* segmentArray = [NSArray arrayWithObjects:@"List",@"Nearby",@"Favorite",nil];
	 NSArray* segmentArray = [NSArray arrayWithObjects:@"All",@"Nearby",nil];
	 typeOfList = [[UISegmentedControl alloc] initWithItems:segmentArray];
	 [typeOfList addTarget:self action:@selector(changeListType:) forControlEvents:UIControlEventValueChanged];
	 [typeOfList sizeToFit];
	 typeOfList.segmentedControlStyle = UISegmentedControlStyleBar;
	 typeOfList.selectedSegmentIndex = 0;
	 UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:typeOfList];
	 self.toolbarItems = [NSMutableArray arrayWithObject:barButton];
	 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityMapSelectedMall:) name:@"mall chosen in citymap" object:nil];	
	 [barButton release];

	}

-(void)changeListType:(id)sender{
	
	if(typeOfList.selectedSegmentIndex==0){ // List
		[listOfItems removeAllObjects];
		for (Mall* aMall in mallList) {
			[listOfItems addObject:aMall.name];
		}
		[self.tableView reloadData];
		}
	else if (typeOfList.selectedSegmentIndex==1){ //neabry
		
		[self populateNearbyList:nil ];
		[listOfItems removeAllObjects];
		for (Mall* aMall in nearbyList) {
			[listOfItems addObject:aMall.name];
		}
		[self.tableView reloadData];
	}
	else if (typeOfList.selectedSegmentIndex==2){//favorite
		
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

#pragma mark -
#pragma mark Memory management

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
	[cityMapViewController release];
	[mallList release];
	[nearbyList release];
    [super dealloc];
}


@end
