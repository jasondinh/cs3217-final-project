//
//  ListViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"


@implementation ListViewController

@synthesize listOfItems,copyListOfItems,searchBar,typeOfList;
#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.frame.size.width, 0)];  
	searchBar.barStyle = UIBarStyleDefault;
	searchBar.delegate = self;
	[searchBar sizeToFit];

	self.tableView.tableHeaderView = searchBar;	
}

- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	letUserSelectRow = YES;
	searching = NO;
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	
	[self.tableView reloadData];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (searching)
		return 1;
	else
		return 1
		;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (searching)
		return [copyListOfItems count];
	else {
		
		//Number of rows it should expect should be based on the section

		return [listOfItems count];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//    NSLog(@"em da dc goi");
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Set up the cell...
	
	if(searching)
		cell.textLabel.text = [copyListOfItems objectAtIndex:indexPath.row];
	else {
		
		//First get the dictionary object

		cell.textLabel.text = [listOfItems objectAtIndex:indexPath.row];;
	}
	
	return cell;
}

//RootViewController.m
- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
	
	searching = YES;
	letUserSelectRow = YES;
	self.tableView.scrollEnabled = NO;
	
	//Add the done button.
	/*self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
											   target:self action:@selector(doneSearching_Clicked:)] autorelease];*/
}
//RootViewController.m
- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if(letUserSelectRow)
		return indexPath;
	else
		return nil;
}
//RootViewController.m
- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	
	//Remove all objects first.
	[copyListOfItems removeAllObjects];
	
	if([searchText length] > 0) {
		
		searching = YES;
		letUserSelectRow = YES;
		self.tableView.scrollEnabled = YES;
		[self searchTableView];
	}
	else {
		
		searching = NO;
		letUserSelectRow = NO;
		self.tableView.scrollEnabled = NO;
	}
	
	[self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	[self searchTableView];
}

- (void) searchTableView {
	NSString *searchText = searchBar.text;
	NSMutableArray *searchArray = [[NSMutableArray alloc] init];
	

	
	for (NSString *sTemp in listOfItems)
	{
		NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
		
		if (titleResultsRange.length > 0)
			[copyListOfItems addObject:sTemp];
	}
	[searchArray release];
	searchArray = nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    /*
     When a row is selected, set the detail view controller's detail item to 
     the item associated with the selected row.
     */
    //detailViewController.detailItem = 
    //    [NSString stringWithFormat:@"Row %d", indexPath.row];
	NSString *selectedItem = nil;
	NSString *searchingText = searchBar.text;
	if(searching && [searchingText length]!=0)
		selectedItem = [copyListOfItems objectAtIndex:indexPath.row];
	else {
		
		selectedItem = [listOfItems objectAtIndex:indexPath.row];
	}
	
	//Initialize the detail view controller and display it.
 
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"mall chosen" object:nil];
	//cityMapViewController.detailItem = 
	//[NSString stringWithFormat:@"%@", 
	//[listOfMovies objectAtIndex:indexPath.row]];    
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

