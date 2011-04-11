    //
//  ShopViewController.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopOverviewController.h"
#import "CommentViewController.h"
#import "FacebookTabViewController.h"
#import "Constant.h"

@implementation ShopViewController
@synthesize theShop;
@synthesize annotation;
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
- (UIImage*)scale:(UIImage*)original ToSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), original.CGImage);
	
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}
- (void)viewDidLoad {
	[super viewDidLoad];
	ShopOverviewController *shopOverviewController = [[ShopOverviewController alloc] init] ;
	CommentViewController *commentController = [[CommentViewController alloc] init] ;
	FacebookTabViewController *facebookTabController = [[FacebookTabViewController alloc] init] ;


	CGSize tabBarIconSize = CGSizeMake(TAB_BAR_ICON_WIDTH, TAB_BAR_ICON_HEIGHT);
	shopOverviewController.tabBarItem.image = [self scale:[UIImage imageNamed:@"overview_tab_icon.png" ] 
												   ToSize:tabBarIconSize ];
	commentController.tabBarItem.image = [self scale:[UIImage imageNamed:@"comments_tab_icon.png" ]
											  ToSize:tabBarIconSize ];
	facebookTabController.tabBarItem.image = [self scale:[UIImage imageNamed:@"facebook_tab_icon.png" ] 
												  ToSize:tabBarIconSize ];
	[self setViewControllers:[NSArray arrayWithObjects:shopOverviewController,commentController,facebookTabController,nil]];
	[shopOverviewController release];
	[commentController release];
	[facebookTabController release];
	

	

	self.title = theShop.shopName;
	self.contentSizeForViewInPopover = CGSizeMake(POPOVER_WIDTH, POPOVER_HEIGHT);
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorite:)];
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
	[GoHere release];
	[FromHere release];
}

-(void) goHere:(id)sender{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"set goal point to shop" object:self.theShop];
}
-(void) fromHere:(id)sender{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"set start point to shop" object:self.theShop];
}
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController 
					animated:(BOOL)animated
{
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
-(id)initWithShop:(Shop*)aShop{
	self =[super init];
	if(self){
		theShop = aShop;
	}
	
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
	[theShop release];
    [super dealloc];
}


@end
