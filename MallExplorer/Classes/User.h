//
//  User.h
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject {

}

@end

//#import "Map.h"
//
//
//@implementation Map
//
//@synthesize annotationList;
//@synthesize pointList;
//@synthesize mapName;
//@synthesize imageMap;
//@synthesize pathOnMap;
//@synthesize edgeList;
//@synthesize defaultCenterPoint;
//const double toleranceRange = 10;
// number of maximum steps in binery search in B->C to refine a path A->B->C by a point in between B,C
//BOOL canRefinePath;
//const int maxNumstep = 1;
//
//-(BOOL) isEqual:(id)o{
//	if (![o isMemberOfClass:[Map class]]) {
//		return NO;
//	}
//	Map* obj = (Map*) o;
//	if ((mapName==nil && obj.mapName==nil) ||[mapName isEqualToString:obj.mapName]){
//		return YES;
//	} else return NO;
//}
//
//-(void) addAnnotation: (Annotation*) annotation{
//	[annotationList addObject:annotation];
//}
//
//-(void) removeAnnotation:(Annotation*)annotation{
//	[annotationList removeObject:annotation];
//}
//
//-(void) addPoint: (MapPoint*) aPoint{
//	[pointList addObject:aPoint];
//}
//
//#pragma mark initializers
//-(void) add:(int)number pointsToGraphInBetweenPoint:(MapPoint*) point1 andPoint: (MapPoint*)point2{
//	NSLog(@"adding edge between %d %lf %lf %d %lf %lf", point1.index, point1.position.x, point1.position.y, point2.index, point2.position.x, point2.position.y);
//	CGPoint vector = CGPointMake((point2.position.x-point1.position.x)/(number+1), (point2.position.y-point1.position.y)/(number+1));
//	NSMutableArray* anArray = [[NSMutableArray alloc ] initWithObjects:point1, nil];
//	for (int i = 1; i<=number; i++) {
//		CGPoint point = CGPointMake(point1.position.x+vector.x*i, point1.position.y+vector.y*i);
//		NSLog(@"%lf %lf", point.x, point.y);
//		MapPoint* mapPoint = [[MapPoint alloc] initWithPosition:point inLevel:self andIndex:0];
//		mapPoint.index = [graph addNode:mapPoint];
//		[anArray addObject:mapPoint];
//		[mapPoint release];
//	}
//	[anArray addObject:point2];
//	for (int i = 1; i<[anArray count]; i++) {
//		MapPoint* p1 = [anArray objectAtIndex:i-1];
//		MapPoint* p2 = [anArray objectAtIndex:i];
//		[graph addEdgeBetweenNodeWithIndex:p1.index andNodeWithIndex:p2.index withWeight:[MapPoint getDistantBetweenPoint:p1 andPoint:p2]];
//	}
//	[anArray release];
//}
//
//-(void) buildGraph{
//	graph = [[Graph alloc] init];
//	NSLog(@"point list with: %d", [pointList count]);
//	NSLog(@"edge list with: %d", [edgeList count]);
//	for (int i = 0; i<[pointList count]; i++) {
//		MapPoint* aNode = [pointList objectAtIndex:i];
//		[graph addNode:aNode withIndex:aNode.index];
//		NSLog(@"%d", aNode.index);
//	}
//	double sum = 0;
//	for (int i = 0; i<[edgeList count]; i++) {
//		Edge* anEdge = [edgeList objectAtIndex: i];
//		sum = sum+ [MapPoint getDistantBetweenPoint:anEdge.pointA andPoint:anEdge.pointB];
//	}
//	double averageEdgeLength = sum/ MAX_NODES;
//	for (int i = 0; i<[edgeList count]; i++) {
//		Edge* anEdge = [edgeList objectAtIndex: i];
//		MapPoint* node1 = anEdge.pointA;
//		MapPoint* node2 = anEdge.pointB;
//		NSLog(@"%d %d", node1.index, node2.index);
//		double dist = [MapPoint getDistantBetweenPoint:node1 andPoint:node2];
//		[self add:(int)(dist/averageEdgeLength)-1 pointsToGraphInBetweenPoint:node1 andPoint:node2];			
//		if (anEdge.isBidirectional) {
//			[self add: (int)(dist/averageEdgeLength)-1 pointsToGraphInBetweenPoint:node2 andPoint:node1];			
//		}
//	}
//	canRefinePath = [self createBitmapFromImage];
//	passAbleColor = [[self getPixelColorAtLocation:[[pointList objectAtIndex:0] position]] retain];
//}
//
//-(Map*) initWithAnObject:(id) object{
//	[self release];
//	self = [object retain];
//	[self buildGraph];
//	return self;
//}
//
//-(Map*) init{
//	self = [super init];
//	if (self) {
//		self.pathOnMap = [[NSMutableArray alloc] init];
//	}
//	return self;
//}
//
//-(void) loadDataWithMapName:(NSString*) mName withMapImage:(UIImage*) img annotationList:(NSArray*) annList pointList:(NSArray*) pList edgeList:(NSArray*) edgeList defaultCenterPoint:(CGPoint) dfCenterPoint{
//	//	self = [super init];
//	//	if (!self) return nil;
//	imageMap = img;
//	mapName = mName;
//	self.annotationList = [NSMutableArray arrayWithArray:annList];
//	self.pointList = [NSMutableArray arrayWithArray:pList] ;
//	self.edgeList = [NSArray arrayWithArray:edgeList];
//	self.defaultCenterPoint = dfCenterPoint;
//	// building graph of this map
//	[self buildGraph];
//	//return self;
//}
//
//#pragma mark -
//#pragma mark path finding
//
//-(NSArray*) findPathFrom:(MapPoint*) point1 to: (MapPoint*) point2{
//	return [graph getShortestPathFromNodeWithIndex:point1.index toNodeWithIndex:point2.index];
//}
//
//-(NSArray*) findPathFromStartPosition:(CGPoint)startPos ToGoalPosition:(CGPoint) goalPos{
//	MapPoint* startPoint = [[MapPoint alloc] initWithPosition:startPos inLevel:self  andIndex:0];
//	MapPoint* goalPoint = [[MapPoint alloc] initWithPosition:goalPos inLevel:self andIndex:0];
//	MapPoint* point1 = [self getClosestMapPointToPosition:startPos];
//	MapPoint* point2 = [self getClosestMapPointToPosition:goalPos];
//	
//	NSMutableArray* aPath = [[NSMutableArray alloc] initWithObjects:startPoint, nil];
//	[aPath addObjectsFromArray:[self findPathFrom:point1 to:point2]];
//	[aPath addObject:goalPoint];
//	return [self refineAPath:[aPath autorelease]];
//}
//
//-(MapPoint*) getClosestMapPointToPosition:(CGPoint) pos{
//	double minDist = INFINITY;
//	int minPos = 0;
//	for (int i = 0; i<[pointList count]; i++) {
//		double dis = [MapPoint getDistantBetweenPoint:[pointList objectAtIndex:i]  andCoordination:pos];
//		if (dis<minDist) {
//			minDist = dis;
//			minPos = i;
//		}
//	}
//	return [pointList objectAtIndex:minPos];
//}
//-(MapPoint*) getClosestMapPointToAnnotation:(Annotation*) anno{
//	return [self getClosestMapPointToPosition:anno.position];
//}
//
//- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
//	
//	CGContextRef    context = NULL;
//    CGColorSpaceRef colorSpace;
//    void *          bitmapData;
//    int             bitmapByteCount;
//    int             bitmapBytesPerRow;
//	
//    size_t pixelsWide = CGImageGetWidth(inImage);
//    size_t pixelsHigh = CGImageGetHeight(inImage);
//    bitmapBytesPerRow   = (pixelsWide * 4);
//    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
//	
//	
//    colorSpace = CGColorSpaceCreateDeviceRGB();
//    if (colorSpace == NULL)
//        return NULL;
//	
//    bitmapData = malloc( bitmapByteCount);
//    if (bitmapData == NULL) 
//        CGColorSpaceRelease( colorSpace );
//	
//    context = CGBitmapContextCreate (bitmapData,
//                                     pixelsWide,
//                                     pixelsHigh,
//                                     8,    
//                                     bitmapBytesPerRow,
//                                     colorSpace,
//                                     kCGImageAlphaPremultipliedFirst);
//    if (context == NULL)
//        free (bitmapData);
//	
//    CGColorSpaceRelease( colorSpace );
//	
//    return context;
//}
//
//
//-(BOOL) createBitmapFromImage{
//	if (imageData) { free(imageData); }
//	CGImageRef inImage = imageMap.CGImage;
//	// Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
//	CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
//	if (cgctx == NULL) { return NO; /* error */ }
//	
//    size_t w = CGImageGetWidth(inImage);
//	size_t h = CGImageGetHeight(inImage);
//	CGRect rect = {{0,0},{w,h}}; 
//	
//	// Draw the image to the bitmap context. Once we draw, the memory
//	// allocated for the context for rendering will then contain the
//	// raw image data in the specified color space.
//	CGContextDrawImage(cgctx, rect, inImage); 
//	
//	// Now we can get a pointer to the image data associated with the bitmap
//	// context.
//	imageData = CGBitmapContextGetData (cgctx);
//	CGContextRelease(cgctx);
//	if (imageData == NULL) {
//		return NO;
//	}
//	return YES;
//}
//
//- (UIColor*) getPixelColorAtLocation:(CGPoint)point {
//	size_t w = CGImageGetWidth(imageMap.CGImage);
//	if (imageData != NULL) {
//		//offset locates the pixel in the data from x,y.
//		//4 for 4 bytes of data per pixel, w is width of one row of data.
//		int offset = 4*((w*round(point.y))+round(point.x));
//		int alpha =  imageData[offset];
//		int red = imageData[offset+1];
//		int green = imageData[offset+2];
//		int blue = imageData[offset+3];
//		//NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
//		UIColor* color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
//		return color;
//	} else {
//		return nil;
//	}
//}
//
//-(double) getColorDifferenceBetween:(UIColor*) colorA and: (UIColor*) colorB{
//	const float* rbgA = CGColorGetComponents(colorA.CGColor);
//	const float* rbgB = CGColorGetComponents(colorB.CGColor);
//	double sum = 0;
//	for (int i = 0; i<3; i++) {
//		sum += (rbgA[i]-rbgB[i])*(rbgA[i]-rbgB[i]);
//	}
//	return	255*sqrt(sum);
//}
//
//
//-(BOOL) checkFreeAtPoint:(CGPoint) point{
//	return [self getColorDifferenceBetween:passAbleColor and:[self getPixelColorAtLocation:point]] <= toleranceRange;
//}
//
//-(BOOL) checkPositionInsideMap:(CGPoint) aPosition{
//	return (aPosition.x>=0 &&
//			aPosition.x<self.imageMap.size.width &&
//			aPosition.y>=0 && 
//			aPosition.y<self.imageMap.size.height);
//}
//
//-(BOOL) canTravelFrom:(CGPoint) startPos to:(CGPoint)endPos{
//	NSLog(@"checking the path between: %lf %lf %lf %lf", startPos.x, startPos.y, endPos.x, endPos.y);
//	CGPoint vector = {endPos.x - startPos.x, endPos.y - startPos.y};
//	int length = [MapPoint getDistantBetweenCoordination:startPos andCoordination:endPos];
//	for (int i = 1; i<length; i++) {
//		//NSLog(@"%d", i);
//		CGPoint	newPos = {startPos.x+ (vector.x/length*i), startPos.y+(vector.y/length*i)};
//		if (![self checkFreeAtPoint:newPos]) {
//			return NO;
//		}
//	}
//	return YES;
//}
//
//-(BOOL) refinePath:(NSMutableArray*) path from:(int)i to:(int)j {
//	MapPoint* aPoint = [path objectAtIndex:i];
//	MapPoint* aPoint1 = [path objectAtIndex:j];
//	MapPoint* aPoint2 = [path objectAtIndex:j+1];
//	NSLog(@"try to shorten the segment: %lf %lf %lf %lf %lf %lf", aPoint.position.x, aPoint.position.y,aPoint1.position.x, aPoint1.position.y,aPoint2.position.x, aPoint2.position.y);
//	
//	if (j+1>=[path count]) {
//		return NO;
//	}
//	if ([self canTravelFrom:[[path objectAtIndex:i] position] to: [[path objectAtIndex:j+1] position]] ) {
//		[path removeObjectAtIndex:j];
//		NSLog(@"removed");
//		return YES;
//	} else {
//		int numStep = 0;
//		MapPoint* left = [path objectAtIndex:j];
//		MapPoint* right = [path objectAtIndex:j+1];
//		CGPoint leftPoint = [left position];
//		CGPoint rightPoint = [right position];
//		CGPoint holdTemp;
//		BOOL hasChosen = NO;
//		while (numStep<maxNumstep){
//			if ([MapPoint getDistantBetweenCoordination:leftPoint andCoordination:rightPoint]<5)
//			{
//				if ([self canTravelFrom:[[path objectAtIndex:i] position] to:rightPoint]) {
//					MapPoint* aPoint = [[MapPoint alloc] initWithPosition:rightPoint inLevel:self andIndex:0];
//					[path replaceObjectAtIndex:j withObject:aPoint];
//					[aPoint release];
//					break;
//				} else if (leftPoint.x!=left.position.x || leftPoint.y!=left.position.y){
//					MapPoint* aPoint = [[MapPoint alloc] initWithPosition:rightPoint inLevel:self andIndex:0];
//					[path replaceObjectAtIndex:j withObject:aPoint];
//					[aPoint release];
//					break;
//				}
//			}
//			CGPoint mid = {(leftPoint.x+rightPoint.x)/2,(leftPoint.y+rightPoint.y)/2};
//			if ([self canTravelFrom:[[path objectAtIndex:i] position] to:mid]){
//				hasChosen = YES;
//				holdTemp = mid;
//				leftPoint = mid;
//			} else {
//				rightPoint = mid;
//			}
//			numStep++;
//		}
//		if (numStep == maxNumstep) {
//			if (hasChosen) {
//				MapPoint* aPoint = [[MapPoint alloc] initWithPosition:holdTemp inLevel:self andIndex:0];
//				[path replaceObjectAtIndex:j withObject:aPoint];
//				[aPoint release];
//			}
//		}
//	}
//	return NO;
//	
//}
//
//-(NSArray*) refineAPath:(NSArray*) aPath{
//	if (!canRefinePath) {
//		NSLog(@"cannot refine path");
//		return aPath;
//	}
//	NSLog(@"now refining the path: ");
//	for (int i = 0; i<[aPath count]; i++) {
//		MapPoint* aPoint = [aPath objectAtIndex:i];
//		NSLog(@"%lf %lf", aPoint.position.x, aPoint.position.y);
//	}
//	NSMutableArray* path = [NSMutableArray arrayWithArray:aPath];
//	int i = 0, j = 1;
//	while (j<[path count]-1) {
//		BOOL isShortened = [self refinePath:path from:i to:j];
//		if (!isShortened) {
//			i++;
//			j++;
//		}
//		NSLog(@"now the path is:");
//		for (int t = 0; t<[path count]; t++) {
//			MapPoint* aPoint = [path objectAtIndex:t];
//			NSLog(@"%lf %lf", aPoint.position.x, aPoint.position.y);
//		}
//	}
//	return path;
//}
//
//-(void) addPathOnMap:(NSArray*)aPath{
//	for (int i = 0; i<[aPath count]-1; i++) {
//		MapPoint* point1 = [aPath objectAtIndex:i];
//		MapPoint* point2 = [aPath objectAtIndex:i+1];
//		Edge* anEdge = [[Edge alloc] initWithPoint1:point1  point2:point2 withLength:[MapPoint getDistantBetweenPoint:point1 andPoint:point2] isBidirectional:YES withTravelType:kWalk];
//		[pathOnMap addObject:anEdge];
//	}
//}
//-(void) resetPathOnMap{
//	[pathOnMap removeAllObjects];
//}
//
//-(void) dealloc{
//	[edgeList release];
//	[imageMap release];
//	[pointList release];
//	[annotationList release];
//	[graph release];
//	if (pathOnMap) {
//		[pathOnMap release];	
//	}
//	[super dealloc];
//}
//@end
