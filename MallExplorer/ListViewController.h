//
//  ListViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListViewController : UITableViewController {
	NSMutableArray* list;

}
@property (nonatomic,retain) NSMutableArray* list;

@end
