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
//	self.navigationController.delegate = self;
	ShopOverviewController *temp1 = [[ShopOverviewController alloc] init] ;
	CommentViewController *temp2 = [[CommentViewController alloc] init] ;
	UIViewController *temp3 = [[UIViewController alloc] init] ;
	temp1.title = @"OVERVIEW";
	temp2.title = @"COMMENTS";
	temp3.title = @"FACEBOOK";
	temp1.view.backgroundColor = [UIColor whiteColor];	
	temp2.view.backgroundColor = [UIColor whiteColor];	
	temp3.view.backgroundColor = [UIColor whiteColor];	
	temp1.tabBarItem.image = [self scale:[UIImage imageNamed:@"overview_tab_icon.png" ] ToSize:CGSizeMake(26, 26) ];
	temp2.tabBarItem.image = [self scale:[UIImage imageNamed:@"comments_tab_icon.png" ] ToSize:CGSizeMake(26, 26) ];
	temp3.tabBarItem.image = [self scale:[UIImage imageNamed:@"facebook_tab_icon.png" ] ToSize:CGSizeMake(30, 26) ];
	[self setViewControllers:[NSArray arrayWithObjects:temp1,temp2,temp3,nil]];
	[temp1 release];
	[temp2 release];
	[temp3 release];
	
/*	//UITextField *comment = [[UITextField alloc]init];
	
	UITextField * textFieldRounded = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
	UITableViewController * tableview = [[UITableViewController alloc]init];
	[temp2.view addSubview:tableview.view];
	tableview.view.autoresizingMask = 	UIViewAutoresizingFlexibleBottomMargin;
	textFieldRounded.borderStyle = UITextBorderStyleRoundedRect;
	textFieldRounded.textColor = [UIColor blackColor]; //text color
	textFieldRounded.font = [UIFont systemFontOfSize:17.0];  //font size
	textFieldRounded.placeholder = @"<Your comment>";  //place holder
	textFieldRounded.backgroundColor = [UIColor whiteColor]; //background color
	textFieldRounded.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	
	textFieldRounded.keyboardType = UIKeyboardTypeDefault;  // type of the keyboard
	textFieldRounded.returnKeyType = UIReturnKeyDone;  // type of the return key
	
	textFieldRounded.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	textFieldRounded.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
	
	//textFieldRounded.inputView = 
	//self.view.contentMode = UIViewContentModeScaleToFill;
	[temp2.view addSubview:textFieldRounded];*/
	self.title =@"a shop";
	self.contentSizeForViewInPopover = CGSizeMake(320, 850);
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToFavorite:)];
	[self.tabBar setBackgroundColor:[UIColor whiteColor]] ;
	
	CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 48);
	UIView *v = [[UIView alloc] initWithFrame:frame];
	
	[v setBackgroundColor:[UIColor whiteColor]];
	[v setAlpha:0.7];
	[[self tabBar] insertSubview:v atIndex:0];
	[v release];

	UIBarButtonItem* PostComment = [[UIBarButtonItem alloc]initWithTitle:@"Post Comment" 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(postComment:)];
	UIBarButtonItem* FromHere = [[UIBarButtonItem alloc]initWithTitle:@"From here" 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(fromHere:)];
	UIBarButtonItem* GoHere = [[UIBarButtonItem alloc]initWithTitle:@"Go here" 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(goHere:)];
	[self setToolbarItems:[NSArray arrayWithObjects:PostComment,FromHere,GoHere,nil] animated:YES];
	[PostComment release];
	[GoHere release];
	[FromHere release];
}
-(void) postComment:(id)sender{
}
-(void) goHere:(id)sender{
}
-(void) fromHere:(id)sender{
}
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController 
					animated:(BOOL)animated
{
	NSLog(@"show");
	if (viewController != self) {
        self.navigationController.delegate = nil;
        if ([[navigationController viewControllers] containsObject:self]) {
            NSLog(@"FORWARD");
        } else {
            NSLog(@"BACKWARD");
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
