    //
//  CityMapViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Owner: Dam Tuan Long
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
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mallChosen:) name:@"mall chosen" object:nil];

	
}
-(void)mallChosen:(id)sender{
	for (id<MKAnnotation> currentAnnotation in mapView.annotations) {       
		if (currentAnnotation!=mapView.userLocation && ((Mall*)currentAnnotation).mId  == ((Mall*)[sender object]).mId) {
		
			[mapView setCenterCoordinate:currentAnnotation.coordinate animated:YES];
			[mapView selectAnnotation:currentAnnotation animated:YES];
		}
	}
	
	
}

#pragma mark -
#pragma mark Mapview and Location support

-(void)reloadView:(id)sender{
	for (id<MKAnnotation> currentAnnotation in mapView.annotations) {			
		BOOL has = NO;
		for (Mall* aMall in mallList){
			if ([currentAnnotation isMemberOfClass:[Mall class]] && ((Mall*)currentAnnotation).mId ==aMall.mId) {
				has = YES;
			}
		}
		if (!has && currentAnnotation != mapView.userLocation) 
			[mapView removeAnnotation:currentAnnotation];
	}
	for (Mall* aMall in mallList){
		BOOL has = NO;
		for (id<MKAnnotation> currentAnnotation in mapView.annotations) {       
			if ([currentAnnotation isMemberOfClass:[Mall class]] && ((Mall*)currentAnnotation).mId ==aMall.mId) {
				has = YES;
			}
		}
		if (!has) 
			[mapView addAnnotation:aMall];
		if (shouldAutoFocus && fabs([aMall.latitude doubleValue] - mapView.userLocation.coordinate.latitude) < INSIDE_LATITUDE &&
			fabs([aMall.longitude doubleValue] - mapView.userLocation.coordinate.longitude <INSIDE_LONGITUDE) ) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"mall enter" object:aMall];
			shouldAutoFocus = NO;
		}
	}
	
	
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
	if ([view.annotation isKindOfClass:[Mall class]]) 
		[[NSNotificationCenter defaultCenter] postNotificationName:@"mall chosen" object:view.annotation];
	
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if (annotation == self.mapView.userLocation) {
		return nil;
	}
    // Boilerplate pin annotation code
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"map"];
    if (pin == nil) {
        pin = [[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"map"] autorelease];
    } else {
        pin.annotation = annotation;
    }
    pin.pinColor = MKPinAnnotationColorRed;
    pin.canShowCallout = YES;
    pin.animatesDrop = NO;
	

    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	

    NSInteger annotationValue = [self.mapView.annotations indexOfObject:annotation];

    detailButton.tag = annotationValue;
	
    // tell the button what to do when it gets touched
    [detailButton addTarget:self action:@selector(rightCalloutAccessoryViewSelected:) 
		   forControlEvents:UIControlEventTouchUpInside];
	
    pin.rightCalloutAccessoryView = detailButton;
    return pin;
}

-(void) rightCalloutAccessoryViewSelected:(id)sender{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"mall enter" 
														object:[mapView.annotations objectAtIndex:((UIButton*)sender).tag]];
}

- (IBAction)changeType:(id)sender{
	
	if(mapType.selectedSegmentIndex==0){// normal map
		mapView.mapType=MKMapTypeStandard;
	}
	else if (mapType.selectedSegmentIndex==1){// satellite
		mapView.mapType=MKMapTypeSatellite;
	}
	else if (mapType.selectedSegmentIndex==2){//hybrid
		
		
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

-(void) viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"mall enter"  object:nil];
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
