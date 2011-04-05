//
//  Map.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Map.h"


@implementation Map

@synthesize annotationList;
@synthesize pointList;

@synthesize imageMap;

const double toleranceRange = 10;
// number of maximum steps in binery search in B->C to refine a path A->B->C by a point in between B,C
BOOL canRefinePath;
const int maxNumstep = 10;

-(void) addAnnotation: (Annotation*) annotation{
	[annotationList addObject:annotation];
}
-(void) addPoint: (MapPoint*) aPoint{
	[pointList addObject:aPoint];
}
-(Map*) initWithMapImage:(UIImage*) img annotationList:(NSArray*) annList pointList:(NSArray*) pList edgeList:(NSArray*) edgeList{
	self = [super init];
	if (!self) return nil;
	self.imageMap = img;
	self.annotationList = [[NSMutableArray arrayWithArray:annList] retain];
	self.pointList = [[NSMutableArray arrayWithArray:pList] retain];

	// building graph
	graph = [[Graph alloc] init];
	NSLog(@"point list with: %d", [pointList count]);
	NSLog(@"edge list with: %d", [edgeList count]);
	for (int i = 0; i<[pointList count]; i++) {
		MapPoint* aNode = [pointList objectAtIndex:i];
		[graph addNode:aNode withIndex:aNode.index];
		NSLog(@"%d", aNode.index);
	}
	for (int i = 0; i<[edgeList count]; i++) {
		Edge* anEdge = [edgeList objectAtIndex: i];
		MapPoint* node1 = anEdge.pointA;
		MapPoint* node2 = anEdge.pointB;
		NSLog(@"%d %d", node1.index, node2.index);
		[graph addEdgeBetweenNodeWithIndex:node1.index andNodeWithIndex:node2.index withWeight:anEdge.weight];
		if (anEdge.isBidirectional) {
			[graph addEdgeBetweenNodeWithIndex:node2.index andNodeWithIndex:node1.index withWeight:anEdge.weight];
		}
	}
	canRefinePath = [self createBitmapFromImage];
	passAbleColor = [[self getPixelColorAtLocation:[[pointList objectAtIndex:0] position]] retain];
	return self;
}

-(NSArray*) findPathFrom:(MapPoint*) point1 to: (MapPoint*) point2{
	return [graph getShortestPathFromNodeWithIndex:point1.index toNodeWithIndex:point2.index];
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
		int offset = 4*((w*round(point.y))+round(point.x));
		int alpha =  imageData[offset];
		int red = imageData[offset+1];
		int green = imageData[offset+2];
		int blue = imageData[offset+3];
		//NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
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
	NSLog(@"checking the path between: %lf %lf %lf %lf", startPos.x, startPos.y, endPos.x, endPos.y);
	CGPoint vector = {endPos.x - startPos.x, endPos.y - startPos.y};
	int length = [MapPoint getDistantBetweenCoordination:startPos andCoordination:endPos];
	for (int i = 1; i<length; i++) {
		//NSLog(@"%d", i);
		CGPoint	newPos = {startPos.x+ (vector.x/length*i), startPos.y+(vector.y/length*i)};
		if (![self checkFreeAtPoint:newPos]) {
			return NO;
		}
	}
	return YES;
}

-(BOOL) refinePath:(NSMutableArray*) path from:(int)i to:(int)j {
	MapPoint* aPoint = [path objectAtIndex:i];
	MapPoint* aPoint1 = [path objectAtIndex:j];
	MapPoint* aPoint2 = [path objectAtIndex:j+1];
	NSLog(@"try to shorten the segment: %lf %lf %lf %lf %lf %lf", aPoint.position.x, aPoint.position.y,aPoint1.position.x, aPoint1.position.y,aPoint2.position.x, aPoint2.position.y);

	if (j+1>=[path count]) {
		return NO;
	}
	if ([self canTravelFrom:[[path objectAtIndex:i] position] to: [[path objectAtIndex:j+1] position]] ) {
		[path removeObjectAtIndex:j];
		NSLog(@"removed");
		return YES;
	} else {
		int numStep = 0;
		MapPoint* left = [path objectAtIndex:j];
		MapPoint* right = [path objectAtIndex:j+1];
		CGPoint leftPoint = [left position];
		CGPoint rightPoint = [right position];
		CGPoint holdTemp;
		BOOL hasChosen = NO;
		while (numStep<maxNumstep){
			if ([MapPoint getDistantBetweenCoordination:leftPoint andCoordination:rightPoint]<5)
			{
				if ([self canTravelFrom:[[path objectAtIndex:i] position] to:rightPoint]) {
					MapPoint* aPoint = [[MapPoint alloc] initWithPosition:rightPoint andIndex:0];
					[path replaceObjectAtIndex:j withObject:aPoint];
					[aPoint release];
					break;
				} else if (leftPoint.x!=left.position.x || leftPoint.y!=left.position.y){
					MapPoint* aPoint = [[MapPoint alloc] initWithPosition:rightPoint andIndex:0];
					[path replaceObjectAtIndex:j withObject:aPoint];
					[aPoint release];
					break;
				}
			}
			CGPoint mid = {(leftPoint.x+rightPoint.x)/2,(leftPoint.y+rightPoint.y)/2};
			if ([self canTravelFrom:[[path objectAtIndex:i] position] to:mid]){
				hasChosen = YES;
				holdTemp = mid;
				leftPoint = mid;
			} else {
				rightPoint = mid;
			}
			numStep++;
		}
		if (numStep == maxNumstep) {
			if (hasChosen) {
				MapPoint* aPoint = [[MapPoint alloc] initWithPosition:holdTemp andIndex:0];
				[path replaceObjectAtIndex:j withObject:aPoint];
				[aPoint release];
			}
		}
	}
	return NO;

}

-(NSArray*) refineAPath:(NSArray*) aPath{
	if (!canRefinePath) {
		NSLog(@"cannot refine path");
		return aPath;
	}
	NSLog(@"now refining the path: ");
	for (int i = 0; i<[aPath count]; i++) {
		MapPoint* aPoint = [aPath objectAtIndex:i];
		NSLog(@"%lf %lf", aPoint.position.x, aPoint.position.y);
	}
	NSMutableArray* path = [NSMutableArray arrayWithArray:aPath];
	int i = 0, j = 1;
	while (j<[path count]-1) {
		BOOL isShortened = [self refinePath:path from:i to:j];
		if (!isShortened) {
			i++;
			j++;
		}
		NSLog(@"now the path is:");
		for (int t = 0; t<[path count]; t++) {
			MapPoint* aPoint = [path objectAtIndex:t];
			NSLog(@"%lf %lf", aPoint.position.x, aPoint.position.y);
		}
	}
	return path;
}
				
-(void) dealloc{
	[imageMap release];
	[pointList release];
	[annotationList release];
	[graph release];
	[super dealloc];
}
@end
