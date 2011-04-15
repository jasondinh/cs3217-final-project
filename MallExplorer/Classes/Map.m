//
//  Map.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  Author: Tran Cong Hoang

#import "Map.h"
#import "ASIHTTPRequest.h"

@implementation Map

@synthesize annotationList;
@synthesize pointList;
@synthesize mapName;
@synthesize imageMap;
@synthesize pathOnMap;
@synthesize edgeList;
@synthesize defaultCenterPoint;
@synthesize mId, level;
const double toleranceRange = 10;

// number of maximum steps in binery search in B->C to refine a path A->B->C by a point in between B,C
BOOL canRefinePath;
const int maxNumstep = 100;

-(BOOL) isEqual:(id)o{
	if (![o isMemberOfClass:[Map class]]) {
		return NO;
	}
	Map* obj = (Map*) o;
	if (self.mId == obj.mId){
		return YES;
	} else return NO;
}

-(void) addAnnotation: (Annotation*) annotation{
	[annotationList addObject:annotation];
}

-(void) removeAnnotation:(Annotation*)annotation{
	[annotationList removeObject:annotation];
}

-(void) addPoint: (MapPoint*) aPoint{
	[pointList addObject:aPoint];
}

#pragma mark initializers
-(void) add:(int)number pointsToGraphInBetweenPoint:(MapPoint*) point1 andPoint: (MapPoint*)point2 isBidirectional:(BOOL) isBidi{
	if (!point1 || !point2) return;
	if (debug) NSLog(@"adding edge between %d %lf %lf %d %lf %lf", point1.index, point1.position.x, point1.position.y, point2.index, point2.position.x, point2.position.y);
	CGPoint vector = CGPointMake((point2.position.x-point1.position.x)/(number+1), (point2.position.y-point1.position.y)/(number+1));
	NSMutableArray* anArray = [[NSMutableArray alloc ] initWithObjects:point1, nil];
	for (int i = 1; i<=number; i++) {
		CGPoint point = CGPointMake(point1.position.x+vector.x*i, point1.position.y+vector.y*i);
		if (debug) NSLog(@"%lf %lf", point.x, point.y);
		MapPoint* mapPoint = [[MapPoint alloc] initWithPosition:point inLevel:self andIndex:0];
		mapPoint.index = [graph addNode:mapPoint];
		[anArray addObject:mapPoint];
		[mapPoint release];
	}
	[anArray addObject:point2];
	for (int i = 1; i<[anArray count]; i++) {
		MapPoint* p1 = [anArray objectAtIndex:i-1];
		MapPoint* p2 = [anArray objectAtIndex:i];
		[graph addEdgeBetweenNodeWithIndex:p1.index andNodeWithIndex:p2.index withWeight:[MapPoint getDistantBetweenPoint:p1 andPoint:p2]];
		if (isBidi) {
			[graph addEdgeBetweenNodeWithIndex:p2.index andNodeWithIndex:p1.index withWeight:[MapPoint getDistantBetweenPoint:p1 andPoint:p2]];			
		}
	}
	[anArray release];
}

-(void) buildGraph{
	graph = [[Graph alloc] init];
	if (debug) NSLog(@"point list with: %d", [pointList count]);
	if (debug) NSLog(@"edge list with: %d", [edgeList count]);
	for (int i = 0; i<[pointList count]; i++) {
		MapPoint* aNode = [pointList objectAtIndex:i];
		aNode.index = i;
		[graph addNode:aNode withIndex:i];
		if (debug) NSLog(@"%d", i);
	}
	double sum = 0;
	for (int i = 0; i<[edgeList count]; i++) {
		Edge* anEdge = [edgeList objectAtIndex: i];
		sum = sum+ [MapPoint getDistantBetweenPoint:anEdge.pointA andPoint:anEdge.pointB];
	}
	double averageEdgeLength = sum/ MAX_NODES;
	for (int i = 0; i<[edgeList count]; i++) {
		Edge* anEdge = [edgeList objectAtIndex: i];
		MapPoint* node1 = anEdge.pointA;
		MapPoint* node2 = anEdge.pointB;
		if (debug) NSLog(@"%d %d", node1.index, node2.index);
		double dist = [MapPoint getDistantBetweenPoint:node1 andPoint:node2];
		[self add:(int)(dist/averageEdgeLength)-1 pointsToGraphInBetweenPoint:node1 andPoint:node2 isBidirectional:anEdge.isBidirectional];			
	}
	canRefinePath = [self createBitmapFromImage];
	passAbleColor = [[self getPixelColorAtLocation:[[pointList objectAtIndex:0] position]] retain];
}

-(Map*) initWithAnObject:(id) object{
	[self release];
	self = [object retain];
	[self buildGraph];
	return self;
}

-(Map*) init{
	self = [super init];
	if (self) {
		self.pathOnMap = [[NSMutableArray alloc] init];
		self.annotationList = [NSMutableArray array];
		self.pointList = [NSMutableArray array];
		self.edgeList = [NSMutableArray array];
	}
	return self;
}

-(Map*) initWithMapId:(NSInteger) mapid withLevel:(NSString *) lev withURL:(NSString*) url{
	self = [super init];
	if (self) {
		self.pathOnMap = [[NSMutableArray alloc] init];
		self.mId = mapid;
		self.level = lev;
		__block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
		[request setCompletionBlock:^{
			NSLog(@"%@", @"done loading image");
			imageMap = [[UIImage imageWithData: [request responseData]] retain];
			mapName = [[NSString stringWithFormat:@"Level %@", lev] retain];
		}];		
		[request startAsynchronous];
	}
	return self;

}

-(void) loadDataWithMapName:(NSString*) mName annotationList:(NSArray*) annList pointList:(NSArray*) pList edgeList:(NSArray*) edgeList{
	
	mapName = mName;
	self.annotationList = [NSMutableArray arrayWithArray:annList];
	self.pointList = [NSMutableArray arrayWithArray:pList] ;
	self.edgeList = [NSArray arrayWithArray:edgeList];
	self.defaultCenterPoint = CGPointMake(imageMap.size.width/2, imageMap.size.height/2);
	for (int i = 0; i<[annotationList count]; i++) {
		Annotation* anAnno = [annotationList objectAtIndex:i];
		anAnno.level = self;
	}
	
	for (int i = 0; i<[pointList count]; i++) {
		MapPoint* mapPoint = [pointList	objectAtIndex:i];
		mapPoint.level = self;
	}
	
	
	// building graph of this map
	[self buildGraph];
	//return self;
}



-(void) loadDataWithMapName:(NSString*) mName withMapImage:(UIImage*) img annotationList:(NSArray*) annList pointList:(NSArray*) pList edgeList:(NSArray*) edgeList defaultCenterPoint:(CGPoint) dfCenterPoint{

	imageMap = img;
	mapName = mName;
	self.annotationList = [NSMutableArray arrayWithArray:annList];
	self.pointList = [NSMutableArray arrayWithArray:pList] ;
	self.edgeList = [NSArray arrayWithArray:edgeList];
	self.defaultCenterPoint = dfCenterPoint;
	for (int i = 0; i<[annotationList count]; i++) {
		Annotation* anAnno = [annotationList objectAtIndex:i];
		anAnno.level = self;
	}

	for (int i = 0; i<[pointList count]; i++) {
		MapPoint* mapPoint = [pointList	objectAtIndex:i];
		mapPoint.level = self;
	}
	
	
	// building graph of this map
	[self buildGraph];
	//return self;
}

-(void) buildMap{
	for (int i = 0; i<[annotationList count]; i++) {
		Annotation* anAnno = [annotationList objectAtIndex:i];
		anAnno.level = self;
	}
	
	
	for (int i = 0; i<[pointList count]; i++) {
		MapPoint* mapPoint = [pointList	objectAtIndex:i];
		mapPoint.level = self;
	}
	
	
	// building graph of this map
	[self buildGraph];
	//return self;
}


#pragma mark -
#pragma mark path finding

-(NSArray*) findPathFrom:(MapPoint*) point1 to: (MapPoint*) point2{
	return [graph getShortestPathUsingAStarFromNodeWithIndex:point1.index toNodeWithIndex:point2.index usingEstimatingFunction:@selector(estimateDistanceTo:)];
}

-(NSArray*) findPathFromStartPosition:(CGPoint)startPos ToGoalPosition:(CGPoint) goalPos{
	MapPoint* startPoint = [[MapPoint alloc] initWithPosition:startPos inLevel:self  andIndex:0];
	MapPoint* goalPoint = [[MapPoint alloc] initWithPosition:goalPos inLevel:self andIndex:0];
	MapPoint* point1 = [self getClosestMapPointToPosition:startPos];
	MapPoint* point2 = [self getClosestMapPointToPosition:goalPos];
	
	NSMutableArray* aPath = [[NSMutableArray alloc] initWithObjects:startPoint, nil];
	[aPath addObjectsFromArray:[self findPathFrom:point1 to:point2]];
	[aPath addObject:goalPoint];
	[startPoint release];
	[goalPoint release];
	return [self refineAPath:[aPath autorelease]];
}

-(MapPoint*) getClosestMapPointToPosition:(CGPoint) pos{
	double minDist = INFINITY;
	int minPos = 0;
	for (int i = 0; i<[pointList count]; i++) {
		double dis = [MapPoint getDistantBetweenPoint:[pointList objectAtIndex:i]  andCoordination:pos];
		if (dis<minDist) {
			minDist = dis;
			minPos = i;
		}
	}
	return [pointList objectAtIndex:minPos];
}
-(MapPoint*) getClosestMapPointToAnnotation:(Annotation*) anno{
	return [self getClosestMapPointToPosition:anno.position];
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
	
	CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
	
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
        return NULL;
	
    bitmapData = malloc( bitmapByteCount);
    if (bitmapData == NULL) 
        CGColorSpaceRelease( colorSpace );
	
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,    
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
        free (bitmapData);
	
    CGColorSpaceRelease( colorSpace );
	
    return context;
}


-(BOOL) createBitmapFromImage{
	if (imageData) { free(imageData); }
	CGImageRef inImage = imageMap.CGImage;
	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
	CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
	if (cgctx == NULL) { return NO; /* error */ }
	
    size_t w = CGImageGetWidth(inImage);
	size_t h = CGImageGetHeight(inImage);
	CGRect rect = {{0,0},{w,h}}; 
	
	// Draw the image to the bitmap context. Once we draw, the memory
	// allocated for the context for rendering will then contain the
	// raw image data in the specified color space.
	CGContextDrawImage(cgctx, rect, inImage); 
	
	// Now we can get a pointer to the image data associated with the bitmap
	// context.
	imageData = CGBitmapContextGetData (cgctx);
	CGContextRelease(cgctx);
	if (imageData == NULL) {
		return NO;
	}
	return YES;
}

- (UIColor*) getPixelColorAtLocation:(CGPoint)point {
	size_t w = CGImageGetWidth(imageMap.CGImage);
	if (imageData != NULL) {
		//offset locates the pixel in the data from x,y.
		//4 for 4 bytes of data per pixel, w is width of one row of data.
		int offset = 4*(w*((int)round(point.y))+(int)round(point.x));
		int alpha =  imageData[offset];
		int red = imageData[offset+1];
		int green = imageData[offset+2];
		int blue = imageData[offset+3];
		UIColor* color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
		return color;
	} else {
		return nil;
	}
}

-(double) getColorDifferenceBetween:(UIColor*) colorA and: (UIColor*) colorB{
	const float* rbgA = CGColorGetComponents(colorA.CGColor);
	const float* rbgB = CGColorGetComponents(colorB.CGColor);
	double sum = 0;
	for (int i = 0; i<3; i++) {
		sum += (rbgA[i]-rbgB[i])*(rbgA[i]-rbgB[i]);
	}
	return	255*sqrt(sum);
}


-(BOOL) checkFreeAtPoint:(CGPoint) point{
	return [self getColorDifferenceBetween:passAbleColor and:[self getPixelColorAtLocation:point]] <= toleranceRange;
}

-(BOOL) checkPositionInsideMap:(CGPoint) aPosition{
	return (aPosition.x>=0 &&
			aPosition.x<self.imageMap.size.width &&
			aPosition.y>=0 && 
			aPosition.y<self.imageMap.size.height);
}

-(BOOL) canTravelFrom:(CGPoint) startPos to:(CGPoint)endPos{
	if (debug) NSLog(@"checking the path between: %lf %lf %lf %lf", startPos.x, startPos.y, endPos.x, endPos.y);
	CGPoint vector = {endPos.x - startPos.x, endPos.y - startPos.y};
	int length = [MapPoint getDistantBetweenCoordination:startPos andCoordination:endPos];
	for (int i = 1; i<length; i++) {
		//if (debug) NSLog(@"%d", i);
		CGPoint	newPos = {startPos.x+ (vector.x/length*i), startPos.y+(vector.y/length*i)};
		if (![self checkFreeAtPoint:newPos]) {
			return NO;
		}
	}
	return YES;
}

-(int) refinePath:(NSArray*) path from:(int)i to:(int)j {
	CGPoint aPoint = [[path objectAtIndex:i] position];
	CGPoint aPoint1 = [[path objectAtIndex:j] position];
	if (debug) NSLog(@"try to shorten the segment: %lf %lf %lf %lf", aPoint.x, aPoint.y,aPoint1.x, aPoint1.y);
	if ([self canTravelFrom:aPoint to:aPoint1]) {
		return j;
	}
	int numStep = 0;
	int l = i+1;
	int r = j;
	BOOL hasChosen = NO;
	int holdResult = i;
	while (numStep<maxNumstep){
		int result;
		if (l>=r-1)
		{
			if ([self canTravelFrom:aPoint to:[[path objectAtIndex:r] position]]) {
				result = r;
			} else {
				result = l;
			}
			return result;
			
		}
		int mid = (l+r)/2;
		if ([self canTravelFrom:aPoint to: [[path objectAtIndex: mid] position]]){
			hasChosen = YES;
			holdResult = mid;
			l = mid;
		} else {
			r = mid-1;
		}
		numStep++;
	}
	if (numStep == maxNumstep) {
		if (hasChosen) {
			return holdResult;
			
		}
	} else {
		return i+1;
	}


}

-(NSArray*) refineAPath:(NSArray*) aPath{
	NSMutableArray* path = [NSMutableArray arrayWithArray:aPath];
	if (canRefinePath){
		if (debug) NSLog(@"now refining the path: ");
		for (int i = 0; i<[aPath count]; i++) {
			MapPoint* aPoint = [aPath objectAtIndex:i];
			if (debug) NSLog(@"%lf %lf", aPoint.position.x, aPoint.position.y);
		}
		int i = 0;
		while (i<[path count]-1) {
			int m = [self refinePath:path from:i to:[path count] -1];
			for (int t = m-1; t>=i+1; t--) {
				[path removeObjectAtIndex:t];
			}
			i++;
			if (debug) NSLog(@"now the path is:");
			for (int t = 0; t<[path count]; t++) {
				MapPoint* aPoint = [path objectAtIndex:t];
				if (debug) NSLog(@"%lf %lf", aPoint.position.x, aPoint.position.y);
			}
		}
	}
	return path;
}

-(void) addPathOnMap:(NSArray*)aPath{
	for (int i = 0; i<[aPath count]-1; i++) {
		MapPoint* point1 = [aPath objectAtIndex:i];
		MapPoint* point2 = [aPath objectAtIndex:i+1];
		Edge* anEdge = [[Edge alloc] initWithPoint1:point1  point2:point2 withLength:[MapPoint getDistantBetweenPoint:point1 andPoint:point2] isBidirectional:YES withTravelType:kWalk];
		[pathOnMap addObject:anEdge];
		[anEdge release];
	}
}
-(void) resetPathOnMap{
	[pathOnMap removeAllObjects];
}
				
-(void) dealloc{
	[edgeList release];
	[imageMap release];
	[pointList release];
	[annotationList release];
	[graph release];
	if (pathOnMap) {
		[pathOnMap release];	
	}
	[super dealloc];
}
@end
