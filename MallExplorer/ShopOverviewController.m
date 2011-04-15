    //
//  ShopOverviewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopOverviewController.h"
#import "Shop.h"


@implementation ShopOverviewController
@synthesize shopNameLabel,operatingHoursLabel,unitLabel,websiteLabel,descriptionTextView,levelLabel,categoryLabel,theShop;


#pragma mark -
#pragma mark Initialization
-(id)initWithShop:(Shop *) aShop{
	//REQUIRES:
	//MODIFIES:self
	//EFFECTS: return a ShopOverviewController with information
	//			obtained from aShop
	self = [super init];
	if(self){

		self.theShop =aShop;
		//category
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
	//settings for self
	self.view.backgroundColor = [UIColor whiteColor];
	if (theShop.shopName != nil) shopNameLabel.text = theShop.shopName;
	if (theShop.level !=nil)    levelLabel.text = theShop.level;
	if (theShop.unitNumber != nil) unitLabel.text = theShop.unitNumber;
	if(theShop.description != [NSNull null]) descriptionTextView.text = theShop.description;

}



#pragma mark -
#pragma mark Memory management

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
}


- (void)dealloc {
	[theShop release];
	[shopNameLabel release];
	[operatingHoursLabel release];
	[unitLabel release];
	[websiteLabel release];
	[descriptionTextView release];
	[levelLabel release];
	[categoryLabel release];
	
    [super dealloc];
}


@end
