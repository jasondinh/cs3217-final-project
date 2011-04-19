    //
//  ShopViewController.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Owner: Dam Tuan Long
#import "ShopViewController.h"
#import "ShopOverviewController.h"
#import "CommentViewController.h"
#import "FacebookTabViewController.h"
#import "Constant.h"

@implementation ShopViewController
@synthesize theShop;
@synthesize annotation;


#pragma mark -
#pragma mark Initialization

- (UIImage*)scale:(UIImage*)original ToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	//REQUIRES: original != nil
	//MODIFIES: none
	//EFFECTS: return the original but resized to 'size'
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), original.CGImage);
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return scaledImage;
}



-(id)loadShop:(Shop*)aShop{
	//REQUIRES: aShop != nil
	//MODIFIES: self
	//EFFECTS: return a ShopViewController with information
	//			obtained from aShop
		
	self.theShop = aShop;
	//settings self
	self.title = self.theShop.shopName;
	self.contentSizeForViewInPopover = CGSizeMake(POPOVER_WIDTH, POPOVER_HEIGHT);
	//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorite:)];
	[self.tabBar setBackgroundColor:[UIColor whiteColor]] ;
	
	CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 48);
	UIView *v = [[UIView alloc] initWithFrame:frame];
	[v setBackgroundColor:[UIColor whiteColor]];
	[v setAlpha:0.7];
	[[self tabBar] insertSubview:v atIndex:0];
	[v release];
	
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
	[self.view addSubview: toolbar];
	[toolbar release];
	
	UIBarButtonItem* FromHere = [[UIBarButtonItem alloc]initWithTitle:@"From here" 
																style:UIBarButtonItemStyleBordered 
															   target:self 
															   action:@selector(fromHere:)];
	UIBarButtonItem* GoHere = [[UIBarButtonItem alloc]initWithTitle:@"Go here" 
															  style:UIBarButtonItemStyleBordered 
															 target:self 
															 action:@selector(goHere:)];
	
	[toolbar setItems:[NSArray arrayWithObjects:FromHere,GoHere,nil]];
	//[self setToolbarItems:[NSArray arrayWithObjects:FromHere,GoHere,nil] animated:YES];
	//clean up
	[GoHere release];
	[FromHere release];
	
	
	
	//add 3 new controllers for 3 tabs
	
	ShopOverviewController *shopOverviewController = [[ShopOverviewController alloc] initWithShop:theShop] ;
	CommentViewController *commentController = [[CommentViewController alloc] initWithShop: theShop
												] ;
	FacebookTabViewController *facebookTabController = [[FacebookTabViewController alloc] initWithShop:theShop] ;
	[self setViewControllers:[NSArray arrayWithObjects:shopOverviewController,commentController,facebookTabController,nil]];
	
	//add icons and titles for 3 controllers
	shopOverviewController.title =@"OVERVIEW";
	commentController.title =@"COMMENTS";
	facebookTabController.title =@"FACEBOOK";
	CGSize tabBarIconSize = CGSizeMake(TAB_BAR_ICON_WIDTH, TAB_BAR_ICON_HEIGHT);
	shopOverviewController.tabBarItem.image = [self scale:[UIImage imageNamed:@"overview_tab_icon.png" ] 
												   ToSize:tabBarIconSize ];
	commentController.tabBarItem.image		= [self scale:[UIImage imageNamed:@"comments_tab_icon.png" ]
											   ToSize:tabBarIconSize ];
	facebookTabController.tabBarItem.image	= [self scale:[UIImage imageNamed:@"facebook_tab_icon.png" ] 
												  ToSize:tabBarIconSize ];
	
	//clean up
	[shopOverviewController release];
	[commentController release];
	[facebookTabController release];
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


-(void) addToFavorite:(id)sender{
	//
}

-(void) goHere:(id)sender{
	//REQUIRES: self=! nil, GoHere button is init-ed and pressed
	//MODIFIES:none
	//EFFECTS: raise notification for pressing GoHere button
	[[NSNotificationCenter defaultCenter] postNotificationName:@"set goal point to shop" object:self.theShop];
}

-(void) fromHere:(id)sender{
	//REQUIRES: self=! nil, FromHere button is init-ed and pressed
	//MODIFIES:none
	//EFFECTS: raise notification for pressing FromHere button
	[[NSNotificationCenter defaultCenter] postNotificationName:@"set start point to shop" object:self.theShop];
}

- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController 
					animated:(BOOL)animated
{
	//REQUIRES: self!=nil,navigationController!=nil,viewController!=nil
	//MODIFIES: none
	//EFFECTS: post nofication when backButton of navigationController is pressed
	if (viewController != self) {
        self.navigationController.delegate = nil;
        if ([[navigationController viewControllers] containsObject:self]) {
        } else {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Shopview will appear" object:self];
			viewController.navigationController.delegate = viewController;
        }
    }
	
    [viewController viewWillAppear:animated];
}





#pragma mark -
#pragma mark View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	//settings self
	self.title = theShop.shopName;
	/*self.contentSizeForViewInPopover = CGSizeMake(POPOVER_WIDTH, POPOVER_HEIGHT);
	//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorite:)];
	[self.tabBar setBackgroundColor:[UIColor whiteColor]] ;
	
	CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 48);
	UIView *v = [[UIView alloc] initWithFrame:frame];
	[v setBackgroundColor:[UIColor whiteColor]];
	[v setAlpha:0.7];
	[[self tabBar] insertSubview:v atIndex:0];
	[v release];
	
	UIBarButtonItem* FromHere = [[UIBarButtonItem alloc]initWithTitle:@"From here" 
																style:UIBarButtonItemStyleBordered 
															   target:self 
															   action:@selector(fromHere:)];
	UIBarButtonItem* GoHere = [[UIBarButtonItem alloc]initWithTitle:@"Go here" 
															  style:UIBarButtonItemStyleBordered 
															 target:self 
															 action:@selector(goHere:)];
	[self setToolbarItems:[NSArray arrayWithObjects:FromHere,GoHere,nil] animated:YES];
	//clean up
	[GoHere release];
	[FromHere release];
	
	
	
	//add 3 new controllers for 3 tabs
	ShopOverviewController *shopOverviewController = [[ShopOverviewController alloc] init] ;
	CommentViewController *commentController = [[CommentViewController alloc] initWithShop: theShop] ;
	FacebookTabViewController *facebookTabController = [[FacebookTabViewController alloc] init] ;
	[self setViewControllers:[NSArray arrayWithObjects:shopOverviewController,commentController,facebookTabController,nil]];
	
	//add icons and titles for 3 controllers
	shopOverviewController.title =@"OVERVIEW";
	commentController.title =@"COMMENTS";
	facebookTabController.title =@"FACEBOOK";
	CGSize tabBarIconSize = CGSizeMake(TAB_BAR_ICON_WIDTH, TAB_BAR_ICON_HEIGHT);
	shopOverviewController.tabBarItem.image = [self scale:[UIImage imageNamed:@"overview_tab_icon.png" ] 
												   ToSize:tabBarIconSize ];
	commentController.tabBarItem.image		= [self scale:[UIImage imageNamed:@"comments_tab_icon.png" ]
													ToSize:tabBarIconSize ];
	facebookTabController.tabBarItem.image	= [self scale:[UIImage imageNamed:@"facebook_tab_icon.png" ] 
													ToSize:tabBarIconSize ];
	
	//clean up
	[shopOverviewController release];
	[commentController release];
	[facebookTabController release];*/

	

	

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
	[theShop release];
	[annotation release];
    [super dealloc];
}


@end
