//
//  Mall.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Mall : NSObject {
	NSInteger mId;
	NSString *name;
	NSString *longitude;
	NSString *latitude;
	NSString *address;
	NSInteger zip;
}

@property (retain) NSString *name;
@property (retain) NSString *longitude;
@property (retain) NSString *latitude;
@property (retain) NSString *address;

@property NSInteger mId;
@property NSInteger zip;

- (id) initWithId: (NSInteger) mId  
		  andName: (NSString *) n 
	 andLongitude: (NSString *) lon 
	  andLatitude: (NSString *) lat
	   andAddress: (NSString *)a
		   andZip: (NSInteger) z;

@end
