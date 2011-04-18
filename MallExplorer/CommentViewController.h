//
//  CommentViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Owner : Dam Tuan Long
#import <UIKit/UIKit.h>


@class Shop;
@interface CommentViewController : UITableViewController {
	//OVERVIEW: this class implements the controller of COMMENTS tab in ShopViewController
	
	NSMutableArray* commentList;			//List of comments in the shop.
	IBOutlet UITextField* commentField;		//Text field for entering user's comments.
}
@property (retain) NSMutableArray* commentList;
@property (retain) IBOutlet UITextField* commentField;


-(id)initWithShop:(Shop*)aShop;
//REQUIRES:
//MODIFIES:self
//EFFECTS: return a CommentViewController with commentList
//			obtained from aShop
@end
