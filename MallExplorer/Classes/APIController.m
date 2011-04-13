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
	
	//depend on path, try to query cache here
	self.path = path;
	
	if ([path isEqualToString: @"/malls.json"]) {
		//if ([delegate respondsToSelector: @selector(cacheRespond:)]) {
			id respond = [self mapListCache];
		self.result = respond;
		if ([delegate respondsToSelector: @selector(cacheRespond:)]) {
			[delegate cacheRespond: self];
		}
		//NSLog([respond description]);
			//[delegate cacheRespond: return];
		//}
	}
	
	NSString *fullPath = [NSString stringWithFormat: @"%@%@", API_END_POINT, path];
	if (debugMode) {
		NSLog(@"APIController: getAPI with path: %@, url: %@", path, fullPath);
	}
	NSURL *url = [NSURL URLWithString: fullPath];
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL: url];
	[request setDelegate: self];
	[request setDidFailSelector: @selector(APIFailed:)];
	[request setDidFinishSelector: @selector(APIFinished:)];
	[request setDidStartSelector: @selector(APIStarted:)];
	[request startAsynchronous];
}


- (id) mapListCache {
	NSArray *fields = [NSArray arrayWithObjects: @"address", @"id", @"latitude", @"longitude", @"name", @"zip", nil];
	NSLog(@"a");
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
	
	//post API never hit cache
	
	NSString *fullPath = [NSString stringWithFormat: @"%@%@", API_END_POINT, path];
	
	if (debugMode) {
		NSLog(@"APIController: postAPI with path: %@ and data: %@", fullPath, [data description]);
	}
	
	NSURL *url = [NSURL URLWithString: fullPath];
	
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
	
	NSEnumerator *enumerator = [data keyEnumerator];
	NSString *key;
	
	while ((key = [enumerator nextObject])) {
		NSLog(@"%@ %@", [data objectForKey: key], key);
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
		NSLog(@"APIController: started to load");
	}
	
	self.url = [request url];
	
	if ([delegate respondsToSelector: @selector(requestDidStart:)]) {
		[delegate requestDidStart: self];
	}
}

- (void) APIFinished: (ASIHTTPRequest *) request {
	
	
	NSArray *fields = [NSArray arrayWithObjects: @"address", @"latitude", @"longitude", @"name", nil];
	//if cache existed => replace cache
	//it it doesn't, insert new cache
	
	if (debugMode) {
		NSLog(@"APIController: finished load with data: %@", [request responseString]);
	}
	
	NSString *resultString = [request responseString];
	
	id returnObject = [resultString JSONValue];
	
	//NSLog(@"%@", [returnObject description]);
	
	self.result = returnObject;
	
	if ([self.path isEqualToString: @"/malls.json"]) {
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
			
			
			//NSFetchRequest *fetchRequest =  [[NSFetchRequest alloc] init];
//			
//			NSEntityDescription *entity = [NSEntityDescription entityForName: @"Mall" inManagedObjectContext: context];
//			
//			[fetchRequest setEntity: entity];
//			
//			[fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"id == %@", [mall valueForKey: @"id"]]];
//			
//			//NSLog(@"anything %@", [mall valueForKey: @"id"]);
//			
//			NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//			
//			[fetchRequest release];
//			
//			BOOL exist;
//			
//			if ([fetchedObjects count] >0) {
//				exist = TRUE;
//			}
//			else {
//				exist = FALSE;
//			}
//			//if exist => replace
//			if (exist) {
//				NSLog(@"%@", @"EXIST");
//				
//				
//			}
//			//if none => insert new cache
//			else {

		}];
	}
	
	if ([delegate respondsToSelector: @selector(serverRespond:)]) {
		[delegate serverRespond: self];
	}
}

- (void) APIFailed: (ASIHTTPRequest *) request {
	
	if (debugMode) {
		NSLog(@"APIController: load failed");
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
	[result release];
	[path release];
	[url release];
	[super dealloc];
}



@end