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

@implementation MallListViewController
@synthesize favoriteList,mallList,cityMapViewController;

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
- (void) requestDidLoad: (APIController *) apiController {
	/*NSArray *malls = (NSArray *) apiController.result;
	NSEnumerator *e = [malls objectEnumerator];
	NSDictionary *tmpMall;
	NSMutableArray *tmpMalls = [NSMutableArray array];
	while (tmpMall = [e nextObject]) {
		NSDictionary *tmp = [tmpMall valueForKey: @"mall"];
		Mall *mall = [[Mall alloc] initWithId: [tmp valueForKey: @"id"] 
									  andName:[tmp valueForKey: @"name"] 
								 andLongitude:[tmp valueForKey: @"longitude"] 
								  andLatitude:[tmp valueForKey: @"latitude"] 
								   andAddress:[tmp valueForKey: @"address"] 
									   andZip:[tmp valueForKey: @"zip"]];
		
		[tmpMalls addObject: mall];
	}
	
	self.mallList = [tmpMalls mutableCopy];
	self.listOfItems = [[NSMutableArray alloc]init];
	for (Mall* aMall in mallList){
		[listOfItems addObject:aMall.name];
	}
	[self.tableView reloadData];
	[progress hide:YES];*/

	[self cacheRespond:apiController];
	
}

- (void)cacheRespond: (APIController *) apiController{
	NSLog(@"cache did respond");
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
	NSLog( @"mall list before: %d", [mallList count]);
	//[self serverRespond:apiController];
	//[self performSelector:@selector(serverRespond:) withObject:apiController afterDelay:1];
	
	
}
- (void)serverRespond: (APIController *) apiController{
	NSLog( @"mall list after: %d", [mallList count]);
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
	//	[tmpMalls removeAllObjects];
	//tmpMall = [[Mall alloc] initWithId:123 andName:@"test" andLongitude:@"123" andLatitude:@"231" andAddress:@"asdf" andZip:12];
//	[tmpMalls insertObject:tmpMall atIndex:1];
//	[tmpMalls removeObjectAtIndex:0];
//
//	[tmpMalls insertObject:tmpMall atIndex:2];
	
	if ([listOfItems count] !=0) {
		NSMutableArray *reloadIndexPaths = [NSMutableArray array];
		NSMutableArray *removeIndexPaths = [NSMutableArray array];
		for (int i=[mallList count]-1; i>=0 ; i--) {
			BOOL has = NO;
			for (int x = 0; x < [tmpMalls count]; x++) {
				NSLog(@"%d %d", ((Mall*)[tmpMalls objectAtIndex:x]).mId, ((Mall*)[mallList objectAtIndex:i]).mId);
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

//		[self.tableView beginUpdates];
//		
//		[self.tableView endUpdates];		
		

		
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
	//[self requestFail:apiController];

}


- (void)requestFail: (APIController *) apiController{

	[[NSNotificationCenter defaultCenter] postNotificationName:@"request did fail" object:self];
	
}
- (void) requestDidStart: (APIController *) apiController {
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

	[[NSNotificationCenter defaultCenter] postNotificationName:@"mall chosen" object:[mallList objectAtIndex:indexPath.row]];
  
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
	

	
	 copyListOfItems = [[NSMutableArray alloc]init];
	 self.navigationItem.title = @"Mall list";
	 searchBar.autocorrectionType = UITextAutocorrectionTypeNo;

	self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData:)];
	
	 NSArray* segmentArray = [NSArray arrayWithObjects:@"List",@"Nearby",@"Favorite",nil];
	 typeOfList = [[UISegmentedControl alloc] initWithItems:segmentArray];
	 [typeOfList sizeToFit];
	 typeOfList.segmentedControlStyle = UISegmentedControlStyleBar;
	 typeOfList.selectedSegmentIndex = 1;
	 UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:typeOfList];
	 self.toolbarItems = [NSMutableArray arrayWithObject:barButton];
	 
	[barButton release];
	 /*self.toolbarItems =[NSMutableArray arrayWithObject: [[[UIBarButtonItem alloc]
	 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
	 target:self action:@selector(doneSearching_Clicked:)] autorelease] ];*/

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
	[favoriteList release];
    [super dealloc];
}


@end
