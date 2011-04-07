    //
//  MallListViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MallListViewController.h"
#import "Mall.h"

@implementation MallListViewController
@synthesize favoriteList,mallList;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (id) initWithMalls: (NSArray *) malls {
	self = [super init];
	
	if (self) {
		self.mallList = [malls mutableCopy];
		listOfItems = [[NSMutableArray alloc]init];
		for (Mall* aMall in malls){
			
			[listOfItems addObject:aMall.name];
					}
	}
	
	return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (searching)
		return [copyListOfItems count];
	else {		
		return [listOfItems count];
	}
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
		
	[[NSNotificationCenter defaultCenter] postNotificationName:@"mall chosen" object:nil];
	//cityMapViewController.detailItem = 
	//[NSString stringWithFormat:@"%@", 
	//[listOfMovies objectAtIndex:indexPath.row]];    
}


//override
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//    NSLog(@"em da dc goi");
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Set up the cell..
	
	NSString *tmpMall = [listOfItems objectAtIndex: indexPath.row];
	
	
	cell.textLabel.text = tmpMall;
	
	//
//	if(searching)
//		cell.textLabel.text = [copyListOfItems objectAtIndex:indexPath.row];
//	else {
//		
//		//First get the dictionary object
//		
//		cell.textLabel.text = [listOfItems objectAtIndex:indexPath.row];;
//	}
	
	return cell;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	// Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	 copyListOfItems = [[NSMutableArray alloc]init];
	self.navigationItem.title = @"Mall list";
	 searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searching = NO;
	 letUserSelectRow = YES;
	
	 NSArray* segmentArray = [NSArray arrayWithObjects:@"List",@"Nearby",@"Favorite",nil];
	 typeOfList = [[UISegmentedControl alloc] initWithItems:segmentArray];
	 [typeOfList sizeToFit];
	 typeOfList.segmentedControlStyle = UISegmentedControlStyleBar;
	 typeOfList.selectedSegmentIndex = 1;
	 UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:typeOfList];
	 self.toolbarItems = [NSMutableArray arrayWithObject:barButton];
	 /*self.toolbarItems =[NSMutableArray arrayWithObject: [[[UIBarButtonItem alloc]
	 initWithBarButtonSystemItem:UIBarButtonSystemItemDone
	 target:self action:@selector(doneSearching_Clicked:)] autorelease] ];*/
	self.contentSizeForViewInPopover = CGSizeMake(320, 850);
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
	[mallList release];
	[favoriteList release];
    [super dealloc];
}


@end
