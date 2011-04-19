//
//  APIController.m
//  MallExplorer
//
//  Created by Jason Dinh on 4/3/11.
//  Copyright 2011 NUS. All rights reserved.
//

#import "APIController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Constant.h"
#import "JSON.h"
#import "MallExplorerAppDelegate.h"
@implementation APIController
@synthesize delegate, debugMode, url, result, path;

- (id) initCopy: (APIController *) toBeCopied {
	self = [super init];
	if (self) {
		self.delegate = toBeCopied.delegate;
		self.debugMode = toBeCopied.debugMode;
		self.url = [[toBeCopied.url copy] autorelease];
		self.result = [[toBeCopied.result copy] autorelease]; //potential bug
		self.path = [[toBeCopied.path copy] autorelease];
	}
	return self;
}

- (void) getAPI: (NSString *) path {
	[self retain];
	//depend on path, try to query cache here
	self.path = path;
	
	if ([path isEqualToString: @"/malls.json"]) {
		if ([delegate respondsToSelector: @selector(cacheRespond:)]) {
			NSArray *respond = [self mapListCache];
			if ([respond count] > 0) {
				self.result = respond;	
				[delegate cacheRespond: self];
			}
		}
	}
	else if ([path rangeOfString: @"/shops.json"].location != NSNotFound) {
		NSArray *tmp = [path componentsSeparatedByString: @"/"];
		
		NSString *mallId = [tmp objectAtIndex: 2];
		if ([delegate respondsToSelector: @selector(cacheRespond:)]) {
			NSArray *respond = [self shopListCache: mallId];
			if ([respond count] > 0) {
				self.result = respond;	
				[delegate cacheRespond: self];
			}
		}
	}
	
	NSString *fullPath = [NSString stringWithFormat: @"%@%@", API_END_POINT, path];
	if (debugMode) {
		//NSLog(@"APIController: getAPI with path: %@, url: %@", path, fullPath);
	}
	NSURL *url = [NSURL URLWithString: fullPath];
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL: url];
	[request setDelegate: self];
	[request setDidFailSelector: @selector(APIFailed:)];
	[request setDidFinishSelector: @selector(APIFinished:)];
	[request setDidStartSelector: @selector(APIStarted:)];
	[request startAsynchronous];
}

- (id) shopListCache: (NSString *) mall_id {
	NSArray *fields = [NSArray arrayWithObjects: @"description", @"id", @"name", @"point_id", @"unit", nil];
	MallExplorerAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	
	NSError *error;
	
	NSFetchRequest *fetchRequest =  [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName: @"Shop" inManagedObjectContext: context];
	
	[fetchRequest setEntity: entity];
	
	[fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"mall_id == %@", mall_id]];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	NSMutableArray *results = [NSMutableArray array];
	
	for (NSManagedObject *info in fetchedObjects) {
		NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
		
		[fields enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id x, NSUInteger index, BOOL *stop){
		//	[tmp setObject:[info valueForKey: x] forKey: x];
		}];
		
		NSDictionary *tmpMap = [NSDictionary dictionaryWithObject: [info valueForKey: @"level"] forKey:@"level"];
		
		[tmp setObject: [NSDictionary dictionaryWithObject:tmpMap forKey:@"map"] forKey:@"map"];
		[tmp setObject: [info valueForKey: @"id"] forKey:@"id"];
		[tmp setObject: @"a" forKey:@"description"];
		[tmp setObject: [info valueForKey: @"name"] forKey:@"name"];
		[tmp setObject: [info valueForKey: @"point_id"] forKey:@"point_id"];
		[tmp setObject: [info valueForKey: @"unit"] forKey:@"unit"];
		[tmp setObject: [info valueForKey: @"mall_id"] forKey:@"mall_id"];
		NSDictionary *tmpDic = [NSDictionary dictionaryWithObject: tmp forKey: @"shop"];
		
		[results addObject: tmpDic];
	}
	
	[fetchRequest release];
	//
	//NSLog(@"shoplistlog %@", [results description]);
	return results;
	
}

- (id) mapListCache {
	NSArray *fields = [NSArray arrayWithObjects: @"address", @"id", @"latitude", @"longitude", @"name", @"zip", nil];
	MallExplorerAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
		
	NSError *error;
	
	NSFetchRequest *fetchRequest =  [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName: @"Mall" inManagedObjectContext: context];
	
	[fetchRequest setEntity: entity];
	
	//[fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"id == %d", 1]];
	
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	NSMutableArray *results = [NSMutableArray array];
	for (NSManagedObject *info in fetchedObjects) {
		NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
		
		[fields enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id x, NSUInteger index, BOOL *stop){
			[tmp setObject:[info valueForKey: x] forKey: x];
		}];
		NSDictionary *tmpDic = [NSDictionary dictionaryWithObject: tmp forKey: @"mall"];
		
		[results addObject: tmpDic];
	}
	
	[fetchRequest release];
	return results;
}


- (void) postAPI: (NSString *) path withData: (NSDictionary *) data {
	[self retain];
	//post API never hit cache
	
	NSString *fullPath = [NSString stringWithFormat: @"%@%@", API_END_POINT, path];
	
	if (debugMode) {
		//NSLog(@"APIController: postAPI with path: %@ and data: %@", fullPath, [data description]);
	}
	
	NSURL *url = [NSURL URLWithString: fullPath];
	
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	
	NSEnumerator *enumerator = [data keyEnumerator];
	NSString *key;
	
	while ((key = [enumerator nextObject])) {
		//NSLog(@"%@ %@", [data objectForKey: key], key);
		[request addPostValue: [data objectForKey: key] forKey: key];
	}
	
	[request setDelegate: self];
	[request setDidFailSelector: @selector(APIFailed:)];
	[request setDidFinishSelector: @selector(APIFinished:)];
	[request setDidStartSelector: @selector(APIStarted:)];
	[request startAsynchronous];
	
}

- (void) APIStarted: (ASIHTTPRequest *) request {
	if (debugMode) {
		//NSLog(@"APIController: started to load");
	}
	
	self.url = [request url];
	
	if ([delegate respondsToSelector: @selector(requestDidStart:)]) {
		[delegate requestDidStart: self];
	}
}

- (void) APIFinished: (ASIHTTPRequest *) request {
	[self release];
	
	
	//if cache existed => replace cache
	//it it doesn't, insert new cache
	
	if (debugMode) {
		//NSLog(@"APIController: finished load with data: %@", [request responseString]);
	}
	
	NSString *resultString = [request responseString];
	
	id returnObject = [resultString JSONValue];
	
	//NSLog(@"%@", [returnObject description]);
	
	self.result = returnObject;
	
	if ([self.path isEqualToString: @"/malls.json"]) {
		NSArray *fields = [NSArray arrayWithObjects: @"address", @"latitude", @"longitude", @"name", nil];
		NSArray *tmp = (NSArray *) returnObject;
		
		MallExplorerAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
		NSManagedObjectContext *context = [appDelegate managedObjectContext];
		NSError *error;
		
		//delete all
		
		NSFetchRequest * allMalls = [[NSFetchRequest alloc] init];
		[allMalls setEntity:[NSEntityDescription entityForName:@"Mall" inManagedObjectContext:context]];
		[allMalls setIncludesPropertyValues:NO]; //only fetch the managedObjectID
		
		NSArray * malls = [context executeFetchRequest:allMalls error:&error];
		[allMalls release];
		//error handling goes here
		for (NSManagedObject * mall in malls) {
			[context deleteObject:mall];
		}
		
		[tmp enumerateObjectsWithOptions: NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			
			NSDictionary *mall = (NSDictionary *) obj;
			
			mall = [mall valueForKey: @"mall"];
			
			//add new
			
			NSManagedObject *tmpMall = [NSEntityDescription 
										insertNewObjectForEntityForName: @"Mall"
										inManagedObjectContext: context];
			
			[fields enumerateObjectsWithOptions: NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				[tmpMall setValue: [mall valueForKey: obj] forKey:obj];
			}];
			
			[tmpMall setValue: [NSString stringWithFormat: @"%@", [mall valueForKey: @"id"]] forKey: @"id"];
			[tmpMall setValue: [NSString stringWithFormat: @"%@", [mall valueForKey: @"zip"]] forKey: @"zip"];
			
			if (![context save: &error]) {
				NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
			}
		}];
	}
	
	else if ([path rangeOfString: @"/shops.json"].location != NSNotFound) {
		/*
		MallExplorerAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
		NSManagedObjectContext *context = [appDelegate managedObjectContext];
		
		NSManagedObject *shop = [NSEntityDescription 
								 insertNewObjectForEntityForName: @"Shop"
								 inManagedObjectContext: context];
		
		[shop setValue: @"2" forKey:@"id"];
		[shop setValue: @"City Hall" forKey: @"name"];
		[shop setValue: @"Whatever" forKey: @"description"];
		[shop setValue: @"10" forKey: @"mall_id"];
		[shop setValue: @"10" forKey: @"point_id"];
		[shop setValue: @"12345" forKey: @"unit"];
		[shop setValue: @"12345" forKey: @"level"];
		
		
		NSError *error;
		if (![context save: &error]) {
			NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
		}
		 */
		
		
		
		/*NSError *error;
		NSFetchRequest *fetchRequest =  [[NSFetchRequest alloc] init];
		 MallExplorerAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
		 NSManagedObjectContext *context = [appDelegate managedObjectContext];
		NSEntityDescription *entity = [NSEntityDescription entityForName: @"Shop" inManagedObjectContext: context];
		
		[fetchRequest setEntity: entity];
		
		[fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"mall_id == %d", 10]];
		
		NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
		
		for (NSManagedObject *info in fetchedObjects) {
			NSLog(@"id : %d", [[info valueForKey: @"id"] intValue]);
			NSLog(@"name: %@", [info valueForKey: @"name"]);
		}
		[fetchRequest release];
		*/
		
		
		
		NSArray *fields = [NSArray arrayWithObjects: @"description", @"name", @"unit", nil];
		NSArray *tmpArry = [path componentsSeparatedByString: @"/"];
		
		NSString *mallId = [tmpArry objectAtIndex: 2];
		
		
		NSArray *tmp = (NSArray *) returnObject;
		
		MallExplorerAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
		NSManagedObjectContext *context = [appDelegate managedObjectContext];
		NSError *error;
		
		//delete all
		
		NSFetchRequest * allShops = [[NSFetchRequest alloc] init];
		[allShops setEntity:[NSEntityDescription entityForName:@"Shop" inManagedObjectContext:context]];
		[allShops setIncludesPropertyValues:NO]; //only fetch the managedObjectID
		
		[allShops setPredicate: [NSPredicate predicateWithFormat: @"mall_id == %@", mallId]];
		
		NSArray * shops = [context executeFetchRequest:allShops error:&error];
		[allShops release];
		//error handling goes here
		for (NSManagedObject * shop in shops) {
			[context deleteObject:shop];
		}
		
		[tmp enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			
			NSDictionary *shop = (NSDictionary *) obj;
			
			shop = [shop valueForKey: @"shop"];
			
			//add new
			
			NSManagedObject *tmpShop = [NSEntityDescription 
										insertNewObjectForEntityForName: @"Shop"
										inManagedObjectContext: context];
			
			[fields enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
				id value = [shop valueForKey: obj];
				if ([obj isEqualToString: @"description"]) {
					value = @"a";
				}
				[tmpShop setValue: value forKey:obj];
			}];
			[tmpShop setValue: mallId forKey: @"mall_id"];
			[tmpShop setValue: [NSString stringWithFormat: @"%@", [shop valueForKey: @"point_id"]] forKey: @"point_id"];
			[tmpShop setValue: [NSString stringWithFormat: @"%@", [shop valueForKey: @"id"]] forKey: @"id"];
			[tmpShop setValue: [[[shop valueForKey: @"map"] valueForKey: @"map"] valueForKey: @"level"] forKey: @"level"];
			if (![context save: &error]) {
				NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
			}
		}];
	}
	
	if ([delegate respondsToSelector: @selector(serverRespond:)]) {
		[delegate serverRespond: self];
	}
}

- (void) APIFailed: (ASIHTTPRequest *) request {
	[self release];
	//recall
	
	
	
	if (debugMode) {
		NSLog(@"APIController: load failed at %@", request.originalURL);
	}
	if ([delegate respondsToSelector: @selector(requestFail:)]) {
		[delegate requestFail: self];
	}
}

- (id)copyWithZone:(NSZone *)zone {
	APIController *api = [[APIController alloc] initCopy: self];
	return [api autorelease];
}


- (void) dealloc {
	[delegate release];
	[result release];
	[path release];
	[url release];
	[super dealloc];
}



@end