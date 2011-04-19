//
//  CommentViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//	Owner : Dam Tuan Long
#import <UIKit/UIKit.h>
#import "APIController.h"

@class Shop;
@class MBProgressHUD;
@interface CommentViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, APIDelegate>{
	//OVERVIEW: this class implements the controller of COMMENTS tab in ShopViewController
	UITableView *commentTable;
	NSMutableArray* commentList;			//List of comments in the shop.
	IBOutlet UITextField* commentField;		//Text field for entering user's comments.
	Shop *shop;
	MBProgressHUD *progress;
}
@property (retain) IBOutlet UITableView* commentTable;
@property (retain) NSMutableArray* commentList;
@property (retain) IBOutlet UITextField* commentField;
@property (retain) IBOutlet Shop *shop;
@property (retain) MBProgressHUD *progress;


-(id)initWithShop:(Shop*)aShop;
//REQUIRES:
//MODIFIES:self
//EFFECTS: return a CommentViewController with commentList
//			obtained from aShop
@end
