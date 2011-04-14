//
//  FacebookController.h
//  MallExplorer
//
//  Created by bathanh-m on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

@interface FacebookController : NSObject <FBSessionDelegate> {
	Facebook *facebook;
}

@property (retain) Facebook *facebook;

- (void) checkInatLongitude: (NSString *) lon andLat: (NSString *) lat andShopName: (NSString *) shopName;

@end
