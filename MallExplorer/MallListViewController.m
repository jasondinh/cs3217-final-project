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
#pragma mark -
#pragma mark APIController
- (void) requestDidLoad: (APIController *) apiController {
	NSArray *malls = (NSArray *) apiController.result;
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
	[progress hide:YES];

	//[self cacheRespond:apiController];
	
}
- (void)cacheRespond: (APIController *) apiController{
	/*NSLog(@"cache did respond");
	NSArray *malls = (NSArray *) apiController.result;
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
	[progress hide:YES];
	*/
	[self serverRespond:apiController];
	
	
	
}
- (void)serverRespond: (APIController *) apiController{
	NSLog(@"server did respond");
	if (progress.hidden == YES) {
		NSLog(@"cahde did respond");
	} else {
		NSLog(@"cache did not respond");
	}
	[progress hide:YES];
	[self requestFail:apiController];

}


- (void)requestFail: (APIController *) apiController{
	/*NSLog(@"request did fail");
	//UIViewController* fail = [[UIViewController alloc] init];
	UILabel* failLabel = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)]autorelease];
	failLabel.text =@"connect server failed";
	failLabel.textAlignment = UITextAlignmentCenter;
	UIButton *reload = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
    reload.frame = CGRectMake(50,40, 200, 44); // position in the parent view and set the size of the button
    [reload setTitle:@"RELOAD" forState:UIControlStateNormal];
	[reload addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:failLabel];
	[self.view addSubview:reload];*/
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
-(id)  init{
	self = [super init];
	if (self) {
		//[self loadData];
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

	[[NSNotificationCenter defaultCenter] postNotificationName:@"mall chosen" object:nil];
  
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
	[mallList release];
	[favoriteList release];
    [super dealloc];
}


@end
