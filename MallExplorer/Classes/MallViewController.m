    //
//  MallViewController.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import "MallViewController.h"
#import "Graph.h"

@implementation MallViewController
//@synthesize coordinate;
@synthesize mall;
@synthesize toolbar;
@synthesize detailItem;
@synthesize popoverController;
@synthesize toggleTextButton;
@synthesize startFlagButton;
@synthesize goalFlagButton;
@synthesize pathFindingButton;
@synthesize titleLabel;
@synthesize resetButton;
@synthesize levelListController;
@synthesize mapDataLoaded;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (debug) NSLog(@"Toolbar %d", [toolbar.items count ]);
}

-(void) display{
	listMapViewController = [[NSMutableArray alloc] initWithCapacity:[mall.mapList count]];
	for (int i = 0; i<[mall.mapList count]; i++) {
		MapViewController* aMVC = [[MapViewController alloc] initMallWithFrame:[MapViewController getSuitableFrame] andMap:[mall.mapList objectAtIndex:i]];
		aMVC.view.frame = [MapViewController getSuitableFrame];
		[listMapViewController addObject:aMVC];
		if ([[mall.mapList objectAtIndex:i] isEqual:mall.defaultMap]) {
			mapViewController = aMVC;
		}
		[aMVC release];
	}
	
	self.titleLabel.text = mall.defaultMap.mapName;
	[self.view addSubview: mapViewController.view];
	[self.view sendSubviewToBack:mapViewController.view];
	[self.view setNeedsDisplay];
	
}


-(void) loadMaps:(NSArray *)listMap andStairs:(NSArray *)stairs withDefaultMap:(Map*) defaultMap{
	if (!self.mapDataLoaded) {
		for (int i = 0; i<[listMap count]; i++) {
			Map* aMap = [listMap objectAtIndex:i];
			[aMap buildMap];
		}
		[mall buildGraphWithMaps:listMap andStairs:stairs];
		mapDataLoaded = TRUE;
	}
	mall.defaultMap = defaultMap;
	[self display];
//	[mapViewController 
}


#pragma mark viewDidLoad

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	displayAllTitleMode = YES;
	// mall = [[Mall alloc] initWithId:nil andName:nil andLongitude:nil andLatitude:nil andAddress:nil andZip:nil];
	UITapGestureRecognizer* tapGesture	 = [[UITapGestureRecognizer alloc]
											initWithTarget:self action:@selector(toggleDisplayCaptionMode:)];
	[tapGesture setNumberOfTapsRequired:1];
	[toggleTextButton addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	tapGesture	 = [[UITapGestureRecognizer alloc]
											initWithTarget:self action:@selector(pathFindingClicked)];
	[tapGesture setNumberOfTapsRequired:1];
	[pathFindingButton addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	tapGesture	 = [[UITapGestureRecognizer alloc]
					initWithTarget:self action:@selector(resetClicked)];
	[tapGesture setNumberOfTapsRequired:1];
	[resetButton addGestureRecognizer:tapGesture];
	[tapGesture release];
	UIPanGestureRecognizer* panGesture	 = [[UIPanGestureRecognizer alloc]
											initWithTarget:self action:@selector(startFlagMove:)];
	[startFlagButton addGestureRecognizer:panGesture];
	[panGesture release];

	panGesture	 = [[UIPanGestureRecognizer alloc]
											initWithTarget:self action:@selector(goalFlagMove:)];
	[goalFlagButton addGestureRecognizer:panGesture];
	[panGesture release];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startOrGoalMoved:) name:@"start or goal moved" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startOrGoalRemoved:) name:@"start or goal removed" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMap:) name:@"change map" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setGoalTo:) name:@"set goal point to shop" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStartTo:) name:@"set start point to shop" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopChosen:) name:@"this shop is chosen" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopReleased:) name:@"shop released" object:nil];
}

#pragma mark -
#pragma mark notification handling

-(void) shopReleased:(NSNotification*) notification{
	Annotation* anAnno = [notification.object annotation];
	[[self getViewControllerOfMap:anAnno.level] removeAnnotation: anAnno];
	[self.view setNeedsDisplay];
}


-(void) shopChosen:(NSNotification*) notification{
	Annotation* anAnno = [notification.object annotation];
	if ([anAnno.level isEqual:mapViewController.map]) {
		[mapViewController focusToAMapPosition:anAnno.position];
	} else {
		[self changeToMap:anAnno.level];
		[mapViewController focusToAMapPosition:anAnno.position];
	}

}

-(void) startOrGoalAdded:(Annotation*) annotation{
	if (annotation.level!= mapViewController.map) {
		[self changeToMap: annotation.level];
	}
	[mapViewController focusToAMapPosition:annotation.position];
	[self startOrGoalMoved:nil];
	resetButton.alpha = 1.0;
	resetButton.userInteractionEnabled = YES;
}

-(void) setStartTo:(NSNotification*) notification{
	Annotation* anAnno = [notification.object annotation];
	if (![anAnno.level isEqual:mapViewController.map]) {
		[self changeToMap:anAnno.level];
	} else {
		[mapViewController focusToAMapPosition:anAnno.position];
	}

	if (start!= nil) {
		MapViewController* aMVC = [self getViewControllerOfMap:start.annotation.level];
		[aMVC removeAllAnnotationOfType:kAnnoStart];
	}
	Annotation* startAnno = [Annotation annotationWithAnnotationType:kAnnoStart inlevel:anAnno.level WithPosition:anAnno.position title:@"Start" content:@"Your starting position"];
	[mapViewController addAnnotation:startAnno];
	start = [mapViewController.annotationList lastObject];
	[self startOrGoalAdded:startAnno];
}

-(void) setGoalTo:(NSNotification*) notification{
	Annotation* anAnno = [notification.object annotation];
	if (![anAnno.level isEqual:mapViewController.map]) {
		[self changeToMap:anAnno.level];
	}else {
		[mapViewController focusToAMapPosition:anAnno.position];
	}
	if (goal!= nil) {
		MapViewController* aMVC = [self getViewControllerOfMap:goal.annotation.level];
		[aMVC removeAllAnnotationOfType:kAnnoGoal];
	}
	Annotation* goalAnno = [Annotation annotationWithAnnotationType:kAnnoGoal inlevel:anAnno.level WithPosition:anAnno.position title:@"Goal" content:@"Your destination"];
	[mapViewController addAnnotation:goalAnno];
	goal = [mapViewController.annotationList lastObject];
	[self startOrGoalAdded:goalAnno];
}

-(void) changeToMap:(Map*)aMap{
	if (mapViewController.map!=aMap) {
		if ([self.mall.mapList indexOfObject:aMap]!=NSNotFound) {
			[self changeToMapViewController: [self getViewControllerOfMap:aMap]];					
		}
	}
}

-(void) changeToMapViewController:(MapViewController*) aMVC{
	[mapViewController.view removeFromSuperview];
	mapViewController = aMVC;
	[mapViewController redisplayPath];
	[UIView animateWithDuration:1 animations:^ {
		[self.view addSubview:mapViewController.view];
		[self.view sendSubviewToBack:mapViewController.view];
		self.titleLabel.text = mapViewController.map.mapName;
		[self.view setNeedsDisplay];
	}];
}

-(void) changeMap:(NSNotification*) notification{
	[self choseLevel: [notification.object mapName]];
}

#pragma mark -
#pragma mark event handling for toolbar button

-(void) moveButton:(UIImageView*) button 
	   withGesture: (UIGestureRecognizer*) gesture 
toMakeAnnotationType:(AnnotationType) annoType
		 WithTitle:(NSString*) title
		andContent:(NSString*) content
{
	CGPoint	translation = [(UIPanGestureRecognizer*) gesture translationInView:self.view];
	[(UIPanGestureRecognizer*)gesture setTranslation:CGPointZero inView:self.view];
	if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateChanged) {
		button.transform = CGAffineTransformTranslate(button.transform, translation.x, translation.y);
	}
	if (gesture.state == UIGestureRecognizerStateEnded) {
		double newX = button.frame.origin.x - mapViewController.view.frame.origin.x;
		double newY = button.frame.origin.y - mapViewController.view.frame.origin.y;

		// bring the button to the original position
		button.transform = CGAffineTransformIdentity;

		
		if (newX>= 0 && newY>=0)
		{
			if (annoType == kAnnoStart && start) {
				// simulate a reset
				[start annoRemoved:nil];
			} else if (annoType == kAnnoGoal && goal) {
				// simulate a reset
				[goal annoRemoved:nil];
			}
			//GameObject* aController = [[GameObject alloc] initWithType:objectType withShape:shapeType atX:newX+gamearea.contentOffset.x atY:newY+ gamearea.contentOffset.y  withWidth:size.width withHeight:size.height];
			UIScrollView* theScrollView = (UIScrollView*) mapViewController.view;
			double x = newX + button.frame.size.width/2  + theScrollView.contentOffset.x;
			double y = newY + button.frame.size.height/2 + theScrollView.contentOffset.y ;
			if (debug) NSLog(@"new x new y %lf %lf", x, y);
			if (![mapViewController addAnnotationType:annoType ToScrollViewAtPosition:CGPointMake(x, y) withTitle:title withContent:content]) {
				button.transform = CGAffineTransformIdentity;
				return; // add to blocked position
			}
			if (annoType == kAnnoStart) {
				start = [mapViewController.annotationList lastObject];
			} else if (annoType == kAnnoGoal) {
				goal = [mapViewController.annotationList lastObject];
			} 
			[self startOrGoalAdded:[[mapViewController.annotationList lastObject] annotation]];
		} 
	}
	
}

- (void)startFlagMove:(UIGestureRecognizer *)gesture{
	[self moveButton:startFlagButton withGesture:gesture toMakeAnnotationType: kAnnoStart WithTitle:@"Start" andContent:@"Your starting position"];
}

- (void)goalFlagMove:(UIGestureRecognizer *)gesture{
	[self moveButton:goalFlagButton withGesture:gesture toMakeAnnotationType: kAnnoGoal WithTitle:@"Goal" andContent:@"Your destination"];
}

-(void) startOrGoalMoved:(NSNotification*) notification{
	if (start && goal) {
		[self startOrGoalRemoved:nil];
		[self pathFinding];
	}
}

-(void) startOrGoalRemoved:(NSNotification*) notification{
	NSNumber* type = notification.object;
	if	([type intValue] == kAnnoStart) {
		start = nil;
		startFlagButton.alpha = 1.0;
		startFlagButton.userInteractionEnabled = YES;		
	}
	if	([type intValue] == kAnnoGoal) {
		goal = nil;
		goalFlagButton.alpha = 1.0;
		goalFlagButton.userInteractionEnabled = YES;
	}
	
	if (!start && !goal) {
		resetButton.alpha = 0.5;
		resetButton.userInteractionEnabled = NO;
		
	}
	[mall resetPath];
	[mapViewController redisplayPath];
	for (int i = 0; i<[listMapViewController count]; i++) {
		[[listMapViewController objectAtIndex:i] removeAllAnnotationOfType:kAnnoConnector];
	}
}
 
-(void) toggleDisplayCaptionMode:(UIGestureRecognizer*) gesture{
	if (!displayAllTitleMode) {
		displayAllTitleMode = YES;
		for (int i = 0; i<[mapViewController.annotationList count]; i++) {
			[[mapViewController.annotationList objectAtIndex:i] titleButton].hidden = NO;
		}
	} else {
		displayAllTitleMode = NO;
		for (int i = 0; i<[mapViewController.annotationList count]; i++) {
			[[mapViewController.annotationList objectAtIndex:i] titleButton].hidden = YES;
		}
	}
}

-(MapViewController*) getViewControllerOfMap:(Map*) aMap{
	return [listMapViewController objectAtIndex:[mall.mapList indexOfObject:aMap]];
}

-(void) pathFinding{
	NSArray* levelConnectingPoint = [[mall findPathFromStartAnnotation:start.annotation ToGoalAnnotaion:goal.annotation] retain];
	// level connecting point is a series of map points that travel through several maps, to show a path between maps, from the start point to the goal point.
	for (int i = 0; i<[levelConnectingPoint count]-1; i++) {
		id p1 = [levelConnectingPoint objectAtIndex:i];
		id p2 = [levelConnectingPoint objectAtIndex:i+1];
		Map* lev1;
		Map* lev2;
		lev1 = [p1 level];
		lev2 = [p2 level];
		if (![lev1 isEqual:lev2]) {
			Annotation* departing = [Annotation annotationWithAnnotationType:kAnnoConnector inlevel:lev1 WithPosition:[p1 position] title:[NSString stringWithFormat:@"To %@", lev2.mapName] content:[NSString stringWithFormat:@"continue path to %@", lev2.mapName]];
			[departing setIsDepartingConnector:YES];
			[departing setIsUp:[self checkLevel:lev2 isHigherThan:lev1]];
			[departing setDestination: lev2];
			[[self getViewControllerOfMap: lev1] addAnnotation:[[departing retain] autorelease]];
			Annotation* arriving = [Annotation annotationWithAnnotationType:kAnnoConnector inlevel:lev2 WithPosition:[p2 position] title:[NSString stringWithFormat:@"From %@", lev1.mapName] content:[NSString stringWithFormat:@"continue path from %@", lev1.mapName]] ;
			[arriving setIsDepartingConnector:NO];
			[arriving setIsUp:[self checkLevel:lev2 isHigherThan:lev1]];
			[arriving setDestination: lev1];
			[[self getViewControllerOfMap: lev2] addAnnotation: [[arriving retain] autorelease]];
			if (start.titleButton.hidden == YES) [start annotationViewTapped:nil];
			if (goal.titleButton.hidden == YES) [goal annotationViewTapped:nil];
		}
	}	
	[levelConnectingPoint release];
	[mapViewController redisplayPath];
}

-(void) resetClicked{
	if (start) {
		// simulate a double click
		[start annoRemoved:nil];
	}
	if (goal) {
		// simulate a double click
		[goal annoRemoved:nil];
	}
	
}

-(void) pathFindingClicked{
	if (!start) {
		UIAlertView * message = [[UIAlertView alloc] initWithTitle: @"Please specific start position!!" message: @"Please choose starting position by dragging the green flag to the map" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[message show];
		[message release];
		return;
		
	} else
	if (!goal) {
		UIAlertView * message = [[UIAlertView alloc] initWithTitle: @"Please specific destination!!" message: @"Please choose destination by dragging the red flag to the map" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[message show];
		[message release];
		return;
	}
	[self pathFinding];
}

- (IBAction) selectLevelClicked:(UIBarButtonItem*) sender{
	UITableViewController* listTableController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    listTableController.clearsSelectionOnViewWillAppear = NO;
	listTableController.contentSizeForViewInPopover = CGSizeMake(200.0, [mall.mapList count]*50+10);
	listTableController.tableView.delegate = self;
	listTableController.tableView.dataSource = self;
	levelListController = [[UIPopoverController alloc] initWithContentViewController:listTableController];
	[levelListController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[listTableController release];
}


-(BOOL) checkLevel:(Map*) lev1 isHigherThan:(Map*) lev2{
	int index1 = [mall.mapList indexOfObject:lev1];
	int index2 = [mall.mapList indexOfObject:lev2];
	return index1>index2;
}

#pragma mark -
#pragma mark level list popover support methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
	[popoverController release];	
}

#pragma mark -
#pragma mark shop view popover support

-(CGSize) getDistanceFromBoundForObjectAtMapPosition: (CGPoint) aPos{
	return [mapViewController getDistanceFromBoundForObjectAtMapPosition:aPos];
	
}

#pragma mark -
#pragma mark level list table view datasource - delegate methods

-(void) choseLevel: (NSString*) chosenLevel{
	for (int i = 0; i<[listMapViewController count]; i++) {
		MapViewController* aMVC = [listMapViewController objectAtIndex:i];
		if ([aMVC.map.mapName isEqualToString:chosenLevel]) {
			[self changeToMapViewController: aMVC];
			break;
		}
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tbView numberOfRowsInSection:(NSInteger)section {
	return [mall.mapList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tbView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"normalCell";
	UITableViewCell *cell = [tbView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
	    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.textLabel.text = [NSString  stringWithString:[[mall.mapList objectAtIndex:[indexPath row]] mapName]];
    return cell;
}

- (void)tableView:(UITableView *)tbView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // open a alert with an OK and cancel button
    NSString* chosenLevel = [NSString stringWithString:[[mall.mapList objectAtIndex:[indexPath row]] mapName]];
	[self choseLevel: chosenLevel];
	[levelListController dismissPopoverAnimated:YES];
}

#pragma mark -
#pragma mark Split view support
- (void)splitViewController: (UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem 
	   forPopoverController: (UIPopoverController*)pc {
	
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Overriden to allow any orientation.
	CGFloat newWidth, newHeight;
	switch ([UIDevice currentDevice].orientation) {
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:			
			newWidth = MAP_WIDTH;
			newHeight = MAP_HEIGHT;
			break;
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:
			newWidth = MAP_PORTRAIT_WIDTH;
			newHeight = MAP_PORTRAIT_HEIGHT;		
			break;
		default:
			return NO;
			break;
	}
	mapViewController.view.frame = CGRectMake(mapViewController.view.frame.origin.x, mapViewController.view.frame.origin.y, newWidth, newHeight);
	
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
	[mall release];
	[toolbar release];
	[detailItem release];
	[popoverController release];
	[toggleTextButton release];
	[startFlagButton release];
	[goalFlagButton release];
	[pathFindingButton release];
	[titleLabel  release];
	[resetButton release];
	[selectLevel release];
	[levelListController release];
    [super dealloc];
}


-(void) buttonClicked:(UIButton *)sender{
	
}

@end
