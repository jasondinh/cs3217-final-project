//
//  ShopViewController.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnoViewController.h"
#import "Shop.h"

@interface ShopViewController : UITabBarController<UINavigationControllerDelegate> {
	Annotation* annotation;
	Shop* theShop;
}
@property (retain) Shop* theShop;
@property (assign) Annotation* annotation;
-(id)initWithShop:(Shop*)aShop;
@end
