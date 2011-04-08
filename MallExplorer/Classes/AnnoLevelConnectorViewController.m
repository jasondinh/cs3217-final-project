    //
//  AnnoLevelConnectorViewController.m
//  MallExplorer
//
//  Created by Tran Cong Hoang on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnnoLevelConnectorViewController.h"


@implementation AnnoLevelConnectorViewController

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

-(CGRect) getAnnoTitleRect{
	int length = self.annotation.title.length;
	double titleLength = length*LENGTH_PER_CHARACTER;
	double posX;
	if (self.view.frame.origin.x>400) {
		posX = self.view.frame.origin.x-titleLength;
	} else {
		posX = self.view.frame.origin.x+ANNOTATION_VIEW_WIDTH;
	}	
	return CGRectMake(posX, self.view.frame.origin.y+(self.view.frame.size.height-CAPTION_HEIGHT)/2, titleLength, CAPTION_HEIGHT);
}
	


-(AnnoLevelConnectorViewController*) initWithAnnotation:(AnnotationLevelConnector*)anno{
	self = [super init];
	if (!self) return nil;
	self.annotation = anno;
	BOOL isUp = [anno isUp];
	BOOL isDeparting = [anno isDepartingConnector];
	NSString* imageName;
	if (isUp && isDeparting) { // a departing connector to a higher level
		imageName = [NSString stringWithString:@"up_arrow.png"];
	} else if (!isUp && isDeparting) { // a departing connector to a lower level
		imageName = [NSString stringWithString:@"down_arrow.png"];
	}  else if (isUp && !isDeparting) { // an arriving connector from a lower level
		imageName = [NSString stringWithString:@"up_red_arrow.png"];
	}  else if (!isUp && !isDeparting) { // an arriving connector from a higher level
		imageName = [NSString stringWithString:@"down_red_arrow.png"];
	}	
	UIImage* image = [UIImage imageNamed:imageName];
	UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
	imageView.alpha = 0.6;
	imageView.frame = CGRectMake(0, 0, 30, 30);	
	self.view = [[UIView alloc] initWithFrame:imageView.frame];
	//self.view.backgroundColor = [UIColor redColor];
	[self.view addSubview: imageView];
	[image release];
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
