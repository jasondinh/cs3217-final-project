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
	NSString* shopName;
	NSString* operationHours;
	NSString* address;
	NSString* tel;
	NSString* website;
	NSString* description;
	
	IBOutlet UILabel* shopNameLabel;
	IBOutlet UILabel* operatingHoursLabel;
	IBOutlet UILabel* categoryLabel;
	IBOutlet UILabel* addressLabel;
	IBOutlet UILabel* telLabel;
	IBOutlet UILabel* websiteLabel;
	IBOutlet UITextView * descriptionTextView;
}
@property (retain) IBOutlet UILabel* shopNameLabel;
@property (retain) IBOutlet UILabel* categoryLabel;
@property (retain) IBOutlet UILabel* operatingHoursLabel;
@property (retain) IBOutlet UILabel* addressLabel;
@property (retain) IBOutlet UILabel* telLabel;
@property (retain) IBOutlet UILabel* websiteLabel;
@property (retain) IBOutlet UITextView * descriptionTextView;

-(id)initWithShop:(Shop*) aShop;


@end
