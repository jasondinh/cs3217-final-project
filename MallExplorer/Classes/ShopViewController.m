    //
//  ShopViewController.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopViewController.h"


@implementation ShopViewController

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
			self.navigationController.delegate =self;
	UIViewController *temp1 = [[UIViewController alloc] init] ;
	UIViewController *temp2 = [[UIViewController alloc] init] ;
	UIViewController *temp3 = [[UIViewController alloc] init] ;
	temp1.title = @"Overview";
	temp2.title = @"Comment";
	temp3.title =@"Rating";
	[self setViewControllers:[NSArray arrayWithObjects:temp1,temp2,temp3,nil]];
	NSLog(@"tabbar %d", [self.viewControllers count]);
	

	
	self.title =@"a shop";
	self.contentSizeForViewInPopover = CGSizeMake(320, 850);
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorite:)];
	//[self.tabBar setBackgroundColor:[UIColor whiteColor]] ;
	
	
	
	CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 48);
	UIView *v = [[UIView alloc] initWithFrame:frame];
	
	
	
	[v setBackgroundColor:[UIColor whiteColor]];
	[v setAlpha:0.7];
	[[self tabBar] insertSubview:v atIndex:0];
	[v release];


	
}
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
	NSLog(@"show");
	if (viewController != self) {
        self.navigationController.delegate = nil;
        if ([[navigationController viewControllers] containsObject:self]) {
            NSLog(@"FORWARD");
        } else {
            NSLog(@"BACKWARD");
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Shopview will appear" object:self];
			viewController.navigationController.delegate =viewController;
			
        }
    }
	
    [viewController viewWillAppear:animated];
}
-(id)initWithShop:(Shop*)aShop{
	//self =[super init];
	//if(self){
		

		
	//}
	return self;
}

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
    [super dealloc];
}


@end
