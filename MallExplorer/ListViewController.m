//
//  ListViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ListViewController.h"


@implementation ListViewController

@synthesize listOfItems,copyListOfItems,searchBar,typeOfList,searchWasActive,savedSearchTerm,savedScopeButtonIndex,displayController;
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
	//searchBar.scopeButtonTitles=[NSArray arrayWithObjects:@"All",@"adfas",nil];
	//searchBar.showsScopeBar =NO;
	searchBar.showsSearchResultsButton =NO;
	searchBar.barStyle = UIBarStyleDefault;
	searchBar.delegate = self;
	[searchBar sizeToFit];
	displayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	self.tableView.delegate =self;
	//self.searchDisplayController.searchBar =searchBar;
	self.displayController.delegate =self;
	self.displayController.searchResultsDataSource =self;
	self.displayController.searchResultsDelegate =self;
	self.navigationController.delegate =self;
	self.tableView.tableHeaderView = searchBar;	

	self.copyListOfItems = [NSMutableArray arrayWithCapacity:[self.listOfItems count]];
	if (self.savedSearchTerm) {
		[self.searchDisplayController setActive:self.searchWasActive];
		[self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
		[self.searchDisplayController.searchBar setText:savedSearchTerm];
		self.savedSearchTerm =nil;
	}
	[self.tableView reloadData];
	self.tableView.scrollEnabled =YES;
	
}

- (void) doneSearching_Clicked:(id)sender {
	
	searchBar.text = @"";
	[searchBar resignFirstResponder];
	
	self.navigationItem.rightBarButtonItem = nil;
	self.tableView.scrollEnabled = YES;
	
	[self.tableView reloadData];
}

- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{

	if (viewController != self) {
        self.navigationController.delegate = nil;
        if ([[navigationController viewControllers] containsObject:self]) {
            NSLog(@"FORWARD");
        } else {
            NSLog(@"BACKWARD");
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Listview will appear" object:self];

        }
    }
	
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController 
	   didShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
	
    [viewController viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
	    [super viewWillAppear:animated];
}

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

- (void)viewDidDisappear:(BOOL)animated {
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of
     the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.copyListOfItems count];
    }
	else
	{
        return [self.listOfItems count];
    }
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//    NSLog(@"em da dc goi");
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	NSString *product = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
		
	{
	
        product = [self.copyListOfItems objectAtIndex:indexPath.row];
    }
	else
	{
        product = [self.listOfItems objectAtIndex:indexPath.row];
    }
	
	cell.textLabel.text = product;
	return cell;
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
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */

	

	[self.copyListOfItems removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	for (NSString *product in listOfItems)
	{
		//if ([scope isEqualToString:@"All"] || [product.type isEqualToString:scope])
		{
			NSComparisonResult result = [product compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
            if (result == NSOrderedSame)
			{
				[self.copyListOfItems addObject:product];

            }
		}
	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    /*
     When a row is selected, set the detail view controller's detail item to 
     the item associated with the selected row.
     */
    //detailViewController.detailItem = 
    //    [NSString stringWithFormat:@"Row %d", indexPath.row];
	//UIViewController *detailsViewController = [[UIViewController alloc] init];
    
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	NSString *product = nil;
	if (self.tableView == self.searchDisplayController.searchResultsTableView)
	{
        product = [self.copyListOfItems objectAtIndex:indexPath.row];
    }
	else
	{
        product = [self.listOfItems objectAtIndex:indexPath.row];
    }
	//detailsViewController.title = product;
    
   // [[self navigationController] pushViewController:detailsViewController animated:YES];
    //[detailsViewController release];
	
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
	self.listOfItems = nil;
}


- (void)dealloc {
	[listOfItems release];
	[copyListOfItems release];
	[searchBar release];
	[typeOfList release];
    [super dealloc];
}


@end

