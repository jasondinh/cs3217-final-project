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
@implementation FacebookTabViewController
@synthesize shop, fb, location, loadNewShops, tableView, locationList;
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
	
	//add a table view
	tableView  = [[UITableView alloc] initWithFrame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 44, self.view.frame.size.width, self.view.frame.size.height)];
	tableView.delegate = self;
	tableView.dataSource = self;
	//settings for self
	
	[self.view addSubview: tableView];

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
		
		//NSString *url = 
		//load new shop
	}
}

- (void) loadShops {
	loadNewShops = NO;
	NSString *url = [NSString stringWithFormat: @"https://graph.facebook.com/search?type=place&center=%f,%f&distance=1000&access_token=%@", 1.2937125827502152, 103.77488136291504, fb.facebook.accessToken];
	//ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL: @"
	
	
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
	[locationList release];
	[tableView release];
	[fb release];
	[shop release];
    [super dealloc];
}


@end
