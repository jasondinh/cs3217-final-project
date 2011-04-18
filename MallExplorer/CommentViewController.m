//
//  CommentViewController.m
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Owner : Dam Tuan Long
#import "CommentViewController.h"
#import "Shop.h"


@implementation CommentViewController
@synthesize commentList,commentField;


#pragma mark -
#pragma mark Initialization

-(id)initWithShop:(Shop *)shop{
	//REQUIRES:
	//MODIFIES:self
	//EFFECTS: return a CommentViewController with commentList
	//			obtained from aShop
	
	self= [super init];
	if(self){
		self.commentList = [shop.commentList mutableCopy];
	}
	return self;
}


 -(void)textFieldDidBeginEditing:(UITextField *)textField{

 }
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	[commentList insertObject:commentField.text atIndex:0];
	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]  withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView endUpdates];
	commentField.text = @"";
	[theTextField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
	return YES;
}
#pragma mark - UIViewController delegate methods

- (void) keyboardWillShow:(NSNotification *)notif{
    // The keyboard will be shown. If the user is editing the comments, adjust the display so that the
    // comments field will not be covered by the keyboard.
	NSLog(@"keyboard will show");
}

- (void) keyboardWillHide:(NSNotification *)notif{
    // The keyboard will be hidden.
    // view should be shifted donw to its real position.
    NSLog(@"keyboard will hide");
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//settings for self
	commentList = [[NSMutableArray alloc] init];
	self.view.backgroundColor = [UIColor whiteColor];
	//setting the textfield for entering comments.
	commentField  = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width , 50)];
	self.tableView.tableHeaderView = commentField;
	commentField.borderStyle = UITextBorderStyleRoundedRect;
	commentField.placeholder = @"Your comment";
	[commentField setDelegate:self];
	commentField.clearButtonMode = UITextFieldViewModeWhileEditing;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillShow:) 
                                                  name:UIKeyboardWillShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillHide:) 
                                                  name:UIKeyboardWillHideNotification object:self.view.window];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [commentList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

    }
    cell.textLabel.text = [commentList objectAtIndex:indexPath.row];
	//cell.textLabel.text = (NSString*)[commentList objectAtIndex:indexPath.row];
    // Configure the cell...
    
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
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
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
	self.commentField = nil;
}


- (void)dealloc {
	[commentList release];
	[commentField release];
    [super dealloc];
}


@end

