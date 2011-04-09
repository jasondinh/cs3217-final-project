//
//  CommentViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shop.h"


@interface CommentViewController : UITableViewController {
	NSMutableArray* commentList;
	IBOutlet UITextField* commentField;
	

}
@property (retain) NSMutableArray* commentList;
@property (retain) IBOutlet UITextField* commentField;
-(id)initWithShop:(Shop*)shop;

@end
