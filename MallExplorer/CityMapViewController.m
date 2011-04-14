    //
//  CityMapViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CityMapViewController.h"
#import "MasterViewController.h"
#import "Mall.h"
#import "Constant.h"

@interface CityMapViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;

@end


@implementation CityMapViewController
@synthesize toolbar, popoverController, detailItem,mallList,backToCurrentLocation;
@synthesize mapView;
@synthesize mapType;





/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
		
        // Update the view.
		
        [self configureView];
    }
	
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }   
}
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
		self.mapView.delegate =self;
		fistTime = YES;
		shouldAutoFocus = YES;
    }
    return self;
}

-(void)reloadView:(id)sender{

	for (Mall* aMall in mallList){
	
		if (fabs([aMall.latitude doubleValue] - mapView.userLocation.coordinate.latitude) < NEARBY_LATITUDE &&
			fabs([aMall.longitude doubleValue] - mapView.userLocation.coordinate.longitude <NEARBY_LONGITUDE)) {
			[mapView addAnnotation:aMall];
		}
		if (shouldAutoFocus && fabs([aMall.latitude doubleValue] - mapView.userLocation.coordinate.latitude) < INSIDE_LATITUDE &&
			fabs([aMall.longitude doubleValue] - mapView.userLocation.coordinate.longitude <INSIDE_LONGITUDE) ) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"mall chosen" object:aMall];
			shouldAutoFocus = NO;
		}
	}
	

	//
}
-(IBAction)backToCurrentLocation:(id)sender{

			
			MKCoordinateRegion region;
			MKCoordinateSpan span;
			span.latitudeDelta = SPAN_LATITUDE;
			span.longitudeDelta = SPAN_LONGITUDE;
			region.span = span;
			region.center = mapView.userLocation.coordinate;
			[mapView setRegion:region animated:YES];

	
	
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{

	//for (Mall *aMall in mallList) {
		//if ([view isEqual:aMall]) {
	if ([view.annotation isKindOfClass:[Mall class]]) 
				[[NSNotificationCenter defaultCenter] postNotificationName:@"mall chosen in citymap" object:view.annotation];
		//}
	//}


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
	span.latitudeDelta = SPAN_LATITUDE;
	span.longitudeDelta = SPAN_LONGITUDE;
	region.span = span;
	region.center = location;
	[mapView setRegion:region animated:YES];
	[mapView setDelegate:self];
	mapView.showsUserLocation = YES;
	mapType.selectedSegmentIndex =0;

	
}
-(MKAnnotationView *)mapView:(MKMapView*)_mapView viewForAnnotion:(id)annotation{
	if (annotation == _mapView.userLocation)
		return nil;	
	else {
		MKPinAnnotationView* annView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"s"];
		annView.animatesDrop =YES;
		annView.canShowCallout =YES;
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

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	CLLocationCoordinate2D location;
	location = newLocation.coordinate;
	if (fistTime) {
		mapView.centerCoordinate =location;
		fistTime = NO;
	}
	[self reloadView:nil];	


}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
}



- (void)configureView {
    // Update the user interface for the detail item.
  
}
#pragma mark -
#pragma mark Split view support
- (void)splitViewController: (UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem 
	   forPopoverController: (UIPopoverController*)pc {

    barButtonItem.title = @"Root List";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

- (void)splitViewController: (UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	

    NSMutableArray *items = [[toolbar items] mutableCopy];
	//if (((UIBarButtonItem*)[items objectAtIndex:0]).title ==@"Root List" )
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
	
}
#pragma mark -
#pragma mark Rotation support
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
	self.popoverController = nil;
}


- (void)dealloc {
	[backToCurrentLocation release];
	[popoverController release];
	[toolbar release];
	[detailItem release];
	[mapView release];
	[mapType release];
	
	[super dealloc];
}


@end
