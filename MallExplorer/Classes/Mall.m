//
//  Mall.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Mall.h"

@implementation Mall
@synthesize name, longitude, latitude, address, mId, zip;

- (id) initWithId: (NSInteger) mId  
		  andName: (NSString *) n 
	 andLongitude: (NSString *) lon 
	  andLatitude: (NSString *) lat
	   andAddress: (NSString *)a
		   andZip: (NSInteger) z {
	
	self = [super init];
	
	if (self) {
		self.name = n;
		self.mId = mId;
		self.longitude = lon;
		self.latitude = lat;
		self.address = a;
		self.zip = zip;
	}
	return self;
}

- (void) dealloc  {
	[super dealloc];
}
@end
