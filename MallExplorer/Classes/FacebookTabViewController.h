//
//  FacebookTabViewController.h
//  MallExplorer
//
//  Created by Dam Tuan Long on 4/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Shop;
@interface FacebookTabViewController : UIViewController {
	//OVERVIEW: this class implements the FACEBOOK tab of  ShopViewController

}

-(id) initWithShop:(Shop*) aShop;
//REQUIRES:
//MODIFIES:self
//EFFECTS: return a FacebookTabViewController with information
//			obtained from aShop

@end
