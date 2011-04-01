//
//  MallExplorerAppDelegate.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MallExplorerViewController;

@interface MallExplorerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MallExplorerViewController* mallExplorer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MallExplorerViewController *viewController;

@end

