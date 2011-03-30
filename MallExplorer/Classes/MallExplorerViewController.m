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

#import <CoreLocation/CoreLocation.h>
@implementation MallExplorerViewController
@synthesize mapView;
@synthesize mapType;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	CLLocationCoordinate2D location;
	location = newLocation.coordinate;
	mapView.centerCoordinate =location;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	CLLocationManager *locationManager=[[CLLocationManager alloc] init];
	locationManager.delegate=self;
	locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
	
	[locationManager startUpdatingLocation];

	[mapView setMapType:MKMapTypeStandard];
	[mapView setScrollEnabled:YES];
	[mapView setZoomEnabled:YES];
	
	CLLocationCoordinate2D location;
	MKCoordinateRegion region;
	MKCoordinateSpan span;
	span.latitudeDelta = 0.02;
	span.longitudeDelta = 0.02;
	region.span = span;
	region.center = location;
	[mapView setRegion:region animated:YES];
	[mapView setDelegate:self];
	mapView.showsUserLocation = YES;
	mapType.selectedSegmentIndex =0;
	CLLocationCoordinate2D mallLocation;
	mallLocation.latitude = 1.302851; // Singapore!
	mallLocation.longitude = 103.85523;
	MallViewController* test = [[[MallViewController alloc]initWithCoordinate:mallLocation] autorelease];
	[mapView addAnnotation:test];
	
	
}
-(MKAnnotationView *)mapView:(MKMapView*)_mapView viewForAnnotion:(id)annotation{
	if (annotation == _mapView.userLocation)
		return nil;	
	else {
		MKPinAnnotationView* annView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"s"];
		annView.animatesDrop =YES;
		return annView;
	}

}

- (IBAction)changeType:(id)sender{

	if(mapType.selectedSegmentIndex==0){
		mapView.mapType=MKMapTypeStandard;
	}
	else if (mapType.selectedSegmentIndex==1){
		mapView.mapType=MKMapTypeSatellite;
	}
	else if (mapType.selectedSegmentIndex==2){
		mapView.mapType=MKMapTypeHybrid;
	}
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
