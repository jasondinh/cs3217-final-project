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
		masterViewController= [[MasterViewController alloc] init];
		
//		MallViewController* aMVC = [[MallViewController alloc] initWithNibName:@"MallViewController" bundle:nil];
//		self.viewControllers = [NSArray arrayWithObjects:masterViewController, aMVC, nil];
//		[self setDelegate: aMVC];
		cityMapViewController = [[[CityMapViewController alloc] initWithNibName:@"CityMapViewController" bundle:nil] retain];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mallChosen:) name:@"mall chosen" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ListViewWillAppear:) name:@"Listview will appear" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopChosen:) name:@"shop chosen" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShopViewWillAppear:) name:@"Shopview will appear"  object:nil];
		self.viewControllers = [NSArray arrayWithObjects: masterViewController, cityMapViewController, nil];
		[self setDelegate:cityMapViewController];
    }
    return self;
}
-(void) ShopViewWillAppear:(id)sender{
}
-(void) shopChosen:(id)sender{
	
	//if (!shopchosen) {
	//	shopchosen = !shopchosen;
		Shop* aShop = [[Shop alloc]init];
		
	ShopViewController* shopViewController = [[ShopViewController alloc] init ];//WithShop:aShop] ;
		[masterViewController pushViewController:shopViewController animated:YES];
		
	
		//MallViewController* aMVC = [[MallViewController alloc] initWithNibName:@"MallViewController" bundle:nil];
		//self.viewControllers = [NSArray arrayWithObjects:masterViewController, aMVC, nil];
		//[self setDelegate: aMVC];
		//[aMVC loadMaps:nil andStairs:nil withDefaultMap:nil];
		
	//} 
	
}
-(void) ListViewWillAppear:(id)sender{

	if ([[sender object] isKindOfClass:[ShopListViewController class]]) {
		//cityMapViewController = [[[CityMapViewController alloc] initWithNibName:@"CityMapViewController" bundle:nil] retain];
		UIToolbar *toolbar = ((MallViewController*)[self.viewControllers objectAtIndex:1]).toolbar;
		if (((UIBarButtonItem*)[toolbar.items objectAtIndex:0]).title == @"Root List") {
			NSLog(@"comehere");
			NSLog(@"toolbar %d", [[cityMapViewController toolbar].items count ]);
			UIBarButtonItem *barButtonItem = [toolbar.items objectAtIndex:0];	
			NSMutableArray *items = [[cityMapViewController.toolbar items] mutableCopy];
			[items removeObjectAtIndex:0];
			[items insertObject:barButtonItem atIndex:0];
			[cityMapViewController.toolbar setItems:items animated:YES];
			[items release];
			//self.popoverController = pc;
			NSLog(@"toolbar %d", [[cityMapViewController toolbar].items count ]);}
		self.viewControllers = [NSArray arrayWithObjects: masterViewController, cityMapViewController, nil];
		[self setDelegate:cityMapViewController];
	}
	
}


-(void) mallChosen:(id) object{
	//if (!chosen) {
	//	chosen = !chosen;
		Mall* aMall = [[Mall alloc]init];

		ShopListViewController* shopListViewController = [[ShopListViewController alloc] initWithMall:aMall] ;
	[aMall release];
		[masterViewController pushViewController:shopListViewController animated:YES];
		MallViewController* aMVC = [[MallViewController alloc] initWithNibName:@"MallViewController" bundle:nil];
		self.viewControllers = [NSArray arrayWithObjects:masterViewController, aMVC, nil];
		[self setDelegate: aMVC];
		[aMVC loadMaps:nil andStairs:nil withDefaultMap:nil];
		if (((UIBarButtonItem*)[[cityMapViewController toolbar].items objectAtIndex:0]).title == @"Root List") {
			NSLog(@"comehere");
		UIBarButtonItem *barButtonItem = [[cityMapViewController toolbar].items objectAtIndex:0];	
		NSMutableArray *items = [[aMVC.toolbar items] mutableCopy];
		[items insertObject:barButtonItem atIndex:0];
		[aMVC.toolbar setItems:items animated:YES];
		[items release];
		//self.popoverController = pc;
		NSLog(@"toolbar %d", [[aMVC toolbar].items count ]);}


	//} 

	
}


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
    return YES;
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
    [super dealloc];
}

@end
