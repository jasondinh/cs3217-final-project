//
//  ShopOverviewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shop.h"

@interface ShopOverviewController : UIViewController {
	//OVERVIEW: this class implements the OVERVIEW tab of  ShopViewController
	
	
	//UILavbel and text view for display shop's information.
	IBOutlet UILabel* shopNameLabel;
	IBOutlet UILabel* operatingHoursLabel;
	IBOutlet UILabel* categoryLabel;
	IBOutlet UILabel* levelLabel;
	IBOutlet UILabel* unitLabel;
	IBOutlet UILabel* websiteLabel;
	IBOutlet UITextView * descriptionTextView;
}
@property (retain) IBOutlet UILabel* shopNameLabel;
@property (retain) IBOutlet UILabel* categoryLabel;
@property (retain) IBOutlet UILabel* operatingHoursLabel;
@property (retain) IBOutlet UILabel* levelLabel;
@property (retain) IBOutlet UILabel* unitLabel;
@property (retain) IBOutlet UILabel* websiteLabel;
@property (retain) IBOutlet UITextView * descriptionTextView;

-(id)initWithShop:(Shop*) aShop;
//REQUIRES:
//MODIFIES:self
//EFFECTS: return a ShopOverviewController with information
//			obtained from aShop


@end
