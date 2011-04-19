    //
//  FacebookTabViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookTabViewController.h"
#import "Shop.h"
#import "FacebookController.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "MBProgressHUD.h"
@implementation FacebookTabViewController
@synthesize shop, fb, location, loadNewShops, tableView, locationList, tmpRow, progress;
#pragma mark -
#pragma mark Initialization

-(id)initWithShop:(Shop *) aShop{
	//REQUIRES: 
	//MODIFIES:self
	//EFFECTS: return a FacebookTabViewController with information
	//			obtained from aShop
	self = [super init];
	if(self){
		self.shop = aShop;
		fb = [[FacebookController alloc] init];
		loadNewShops = YES;
	}
	return self;
}



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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    [super viewDidLoad];
	progress = [[MBProgressHUD alloc] initWithView: self.view];
	
	
	//add a table view
	tableView  = [[UITableView alloc] initWithFrame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 44, self.view.frame.size.width, 617)];
	tableView.delegate = self;
	tableView.dataSource = self;
	//settings for self
	
	[self.view addSubview: tableView];
	[self.view addSubview: progress];
	
	
	self.view.backgroundColor = [UIColor whiteColor];
	NSLog(@"aaaaaaaaaaaaa");
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fbLoggedIn:) name: @"FBLoggedIn" object:fb];
	[fb authorize];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Set up the cell..
	
		
	NSDictionary *tmp = [locationList objectAtIndex: indexPath.row];
	cell.textLabel.text = [tmp valueForKey: @"name"];
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [locationList count];
}	

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"failed");
}


- (void) fbLoggedIn: (NSNotification *) notf {
	NSLog(@"%@", @"//load list of data");
	//load list of data
	CLLocationManager *locationManager=[[CLLocationManager alloc] init];
	locationManager.delegate=self;
	locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
	[locationManager startUpdatingLocation];
	[self loadShops];
	
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	CLLocationCoordinate2D location;
	location = newLocation.coordinate;
	NSLog(@"%f %f", location.longitude, location.latitude);
	if (loadNewShops) {
		
	}
}

- (void) loadShops {
	loadNewShops = NO;
	NSString *url = [NSString stringWithFormat: @"https://graph.facebook.com/search?type=place&center=%f,%f&distance=1000&access_token=%@", 1.2937125827502152, 103.77488136291504, fb.facebook.accessToken];

	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL: [NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
	
	[request setDelegate: self];
	[request setDidStartSelector: @selector(startedLoadedNearBy:)];
	[request setDidFinishSelector: @selector(finishedLoadedNearby:)];
	[request setDidFailSelector: @selector(failedLoadedNearby:)];
	[request startAsynchronous];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *tmp = [locationList objectAtIndex: tmpRow];
	NSString *name = [tmp valueForKey: @"shopName"];
	
	tmpRow = indexPath.row;
	NSString *message = [NSString stringWithFormat: @"Do you want to check in at %@?", name];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Check in" message: message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"yes", nil];
	[alert show];
	[tableView deselectRowAtIndexPath: indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSDictionary *tmp = [locationList objectAtIndex: tmpRow];
		
		NSString *longitude = [tmp valueForKey: @"lon"];
		NSString *latitude = [tmp valueForKey: @"lat"];
		NSString *place_id = [tmp valueForKey: @"place_id"];
		NSString *name = [tmp valueForKey: @"shopName"];
		NSString *message = @"lalala";
		
		[fb checkInatLongitude:longitude andLat:latitude andShopName: name andPlaceId: place_id];
	}
	
	
} 

- (void) startedLoadedNearBy: (ASIHTTPRequest *) request {
	[progress show:YES];
	NSLog(@"Started");
	
}

- (void) failedLoadedNearby: (ASIHTTPRequest *) request {
	[progress hide: YES];
	NSLog([[request error] description]);
}

- (void) finishedLoadedNearby: (ASIHTTPRequest *) request {
	[progress hide: YES];
	NSString *respone = [request responseString];
	NSArray  *result = [[respone JSONValue] valueForKey: @"data"];
	NSLog([result description]);
	NSMutableArray *tmpArray = [NSMutableArray array];
	for (NSDictionary *tmpDict in result) {
		
		NSDictionary *tmpPush = [NSDictionary dictionaryWithObjectsAndKeys: 
								 [tmpDict valueForKey: @"name"], @"name", 
								 shop.shopName, @"shopName",
								 [[tmpDict valueForKey: @"location"] valueForKey: @"longitude"], @"lon", 
								 [[tmpDict valueForKey: @"location"] valueForKey: @"latitude"], @"lat", 
								 [tmpDict valueForKey: @"id"], @"place_id", 
								 nil];
		[tmpArray addObject: tmpPush];
	}
	
	self.locationList = [NSArray arrayWithArray: tmpArray];
	[tableView reloadData];
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
	[progress release];
	[locationList release];
	[tableView release];
	[fb release];
	[shop release];
    [super dealloc];
}


@end
