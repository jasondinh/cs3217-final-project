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
#import "MapViewController.h"

#import <CoreLocation/CoreLocation.h>
@implementation MallExplorerViewController


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		// Custom initialization
		masterViewController= [[MasterViewController alloc] init];
		cityMapViewController = [[CityMapViewController alloc] initWithNibName:@"CityMapViewController" bundle:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mallChosen:) name:@"mall chosen" object:nil];
		self.viewControllers = [NSArray arrayWithObjects: masterViewController, cityMapViewController, nil];
		[self setDelegate:cityMapViewController];
		//	
    }
    return self;
}

-(void) mallChosen:(id) object{
	MapViewController* aMVC = [[MapViewController alloc] initMall];
	self.viewControllers = [NSArray arrayWithObjects:masterViewController, aMVC, nil];
	
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
