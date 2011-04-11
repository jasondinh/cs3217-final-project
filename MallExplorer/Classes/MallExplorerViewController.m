//
//  MallExplorerViewController.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Updated by Dam Tuan Long on 29 Mar 2011 : add city map
#import "MallExplorerViewController.h"
#import "MallViewController.h"
#import "MallListViewController.h"
#import "MapViewController.h"
#import "ShopListViewController.h"
#import "RequesFailViewController.h"
#import "ShopViewController.h"
#import "Shop.h"
#import "Mall.h"

#import <CoreLocation/CoreLocation.h>
@implementation MallExplorerViewController
BOOL chosen,shopchosen;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		// Custom initialization
		cityMapViewController = [[[CityMapViewController alloc] initWithNibName:@"CityMapViewController" bundle:nil] retain];
		masterViewController= [[MasterViewController alloc] initWithCityMap:cityMapViewController];
		//masterViewController.cityMapViewController = 

		self.viewControllers = [NSArray arrayWithObjects: masterViewController, cityMapViewController, nil];
		[self setDelegate:cityMapViewController];
		
		//add observer for notifications
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopChosen:) name:@"shop chosen" object:nil];		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mallChosen:) name:@"mall chosen" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ListViewWillAppear:) name:@"Listview will appear" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShopViewWillAppear:) name:@"Shopview will appear"  object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDidFail:) name:@"request did fail"  object:nil];
    }
    return self;
}

#pragma mark -
#pragma mark Nofications
-(void) requestDidFail:(id)sender{
/*	NSLog(@"REQUEST FAILED");
	RequesFailViewController * requestFail = [[RequesFailViewController alloc]init];
	[masterViewController pushViewController:requestFail animated:YES];*/
}

-(void) shopChosen:(id)sender{
		Shop* aShop = [[Shop alloc]init];
		ShopViewController* shopViewController = [[ShopViewController alloc] initWithShop:aShop] ;
		[masterViewController pushViewController:shopViewController animated:YES];
		masterViewController.delegate = shopViewController;
	
}


-(void) mallChosen:(id) object{
		Mall* aMall = [[Mall alloc]init];
		ShopListViewController* shopListViewController = [[ShopListViewController alloc] initWithMall:aMall] ;
		[aMall release];
		masterViewController.delegate = shopListViewController;
		[masterViewController pushViewController:shopListViewController animated:YES];
		MallViewController* aMVC = [[MallViewController alloc] initWithNibName:@"MallViewController" bundle:nil];
		self.viewControllers = [NSArray arrayWithObjects:masterViewController, aMVC, nil];
		[self setDelegate: aMVC];
		[aMVC loadMaps:nil andStairs:nil withDefaultMap:nil];
		if (((UIBarButtonItem*)[[cityMapViewController toolbar].items objectAtIndex:0]).title == @"Root List") {
			UIBarButtonItem *barButtonItem = [[cityMapViewController toolbar].items objectAtIndex:0];	
			NSMutableArray *items = [[aMVC.toolbar items] mutableCopy];
			[items insertObject:barButtonItem atIndex:0];
			[aMVC.toolbar setItems:items animated:YES];
			[items release];
		}

}

-(void) ListViewWillAppear:(id)sender{
	//If a ShopListViewController will appear
	if ([[sender object] isKindOfClass:[ShopListViewController class]]) {
		//add the Root list button again
		UIToolbar *toolbar = ((MallViewController*)[self.viewControllers objectAtIndex:1]).toolbar;
		if (((UIBarButtonItem*)[toolbar.items objectAtIndex:0]).title == @"Root List") {
			UIBarButtonItem *barButtonItem = [toolbar.items objectAtIndex:0];	
			NSMutableArray *items = [[cityMapViewController.toolbar items] mutableCopy];
			[items removeObjectAtIndex:0];
			[items insertObject:barButtonItem atIndex:0];
			[cityMapViewController.toolbar setItems:items animated:YES];
			[items release];
			
		}
		self.viewControllers = [NSArray arrayWithObjects: masterViewController, cityMapViewController, nil];
		[self setDelegate:cityMapViewController];
	}
	
}
-(void) ShopViewWillAppear:(id)sender{
	//If a Shpview will appear
}



#pragma mark -
#pragma mark View lifecycle
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [[self.viewControllers objectAtIndex:1] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[cityMapViewController release];
	[masterViewController release];
    [super dealloc];
}

@end
