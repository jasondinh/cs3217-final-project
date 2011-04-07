    //
//  MallViewController.m
//  MallExplorer
//
//  Created by bathanh-m on 3/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MallViewController.h"
#import "Graph.h"

@implementation MallViewController
//@synthesize coordinate;
@synthesize mall;
@synthesize toolbar;
@synthesize detailItem;
@synthesize popoverController;
@synthesize toogleTextButton;
@synthesize startFlagButton;
@synthesize goalFlagButton;
@synthesize pathFindingButton;
@synthesize titleLabel;
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.

    }
    return self;
}*/

-(Map*) createTestMap1{
	UIImage* image = [UIImage imageNamed:@"map.jpg"];
	NSMutableArray* pointList = [[NSMutableArray alloc] init];
	NSMutableArray* edgeList = [[NSMutableArray alloc] init];
	Map* aMap = [[Map alloc] init];
	MapPoint* point = [[MapPoint alloc] initWithPosition:CGPointMake(31.000000, 30.000000) inLevel:aMap andIndex:0];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(126.000000, 33.000000) inLevel:aMap andIndex:1];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(297.000000, 69.000000) inLevel:aMap andIndex:2];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(249.000000, 16.000000) inLevel:aMap andIndex:3];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(101.000000, 197.000000) inLevel:aMap andIndex:4];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(22.000000, 185.000000) inLevel:aMap andIndex:5];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(90.000000, 282.000000) inLevel:aMap andIndex:6];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(71.000000, 331.000000) inLevel:aMap andIndex:7];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(32.000000, 373.000000) inLevel:aMap andIndex:8];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(176.000000, 462.000000) inLevel:aMap andIndex:9];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(335.000000, 469.000000) inLevel:aMap andIndex:10];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(407.000000, 277.000000) inLevel:aMap andIndex:11];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(556.000000, 279.000000) inLevel:aMap andIndex:12];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(688.000000, 278.000000) inLevel:aMap andIndex:13];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(403.000000, 115.000000) inLevel:aMap andIndex:14];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(535.000000, 59.000000) inLevel:aMap andIndex:15];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(537.000000, 184.000000) inLevel:aMap andIndex:16];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(534.000000, 121.000000) inLevel:aMap andIndex:17];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(685.000000, 139.000000) inLevel:aMap andIndex:18];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(442.000000, 319.000000) inLevel:aMap andIndex:19];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(455.000000, 424.000000) inLevel:aMap andIndex:20];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(530.000000, 448.000000) inLevel:aMap andIndex:21];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(529.000000, 387.000000) inLevel:aMap andIndex:22];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(545.000000, 516.000000) inLevel:aMap andIndex:23];
	[pointList addObject:point];
	[point release];
	Edge* edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 0] point2:[pointList objectAtIndex: 1] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 0] andPoint:[pointList objectAtIndex: 1]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 1] point2:[pointList objectAtIndex: 3] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 1] andPoint:[pointList objectAtIndex: 3]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 3] point2:[pointList objectAtIndex: 2] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 3] andPoint:[pointList objectAtIndex: 2]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 2] point2:[pointList objectAtIndex: 1] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 2] andPoint:[pointList objectAtIndex: 1]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 1] point2:[pointList objectAtIndex: 4] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 1] andPoint:[pointList objectAtIndex: 4]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 4] point2:[pointList objectAtIndex: 5] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 4] andPoint:[pointList objectAtIndex: 5]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 4] point2:[pointList objectAtIndex: 6] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 4] andPoint:[pointList objectAtIndex: 6]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 6] point2:[pointList objectAtIndex: 7] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 6] andPoint:[pointList objectAtIndex: 7]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 7] point2:[pointList objectAtIndex: 8] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 7] andPoint:[pointList objectAtIndex: 8]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 8] point2:[pointList objectAtIndex: 9] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 8] andPoint:[pointList objectAtIndex: 9]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 9] point2:[pointList objectAtIndex: 10] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 9] andPoint:[pointList objectAtIndex: 10]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 4] point2:[pointList objectAtIndex: 11] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 4] andPoint:[pointList objectAtIndex: 11]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 11] point2:[pointList objectAtIndex: 14] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 11] andPoint:[pointList objectAtIndex: 14]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 14] point2:[pointList objectAtIndex: 17] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 14] andPoint:[pointList objectAtIndex: 17]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 17] point2:[pointList objectAtIndex: 15] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 17] andPoint:[pointList objectAtIndex: 15]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 17] point2:[pointList objectAtIndex: 16] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 17] andPoint:[pointList objectAtIndex: 16]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 17] point2:[pointList objectAtIndex: 18] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 17] andPoint:[pointList objectAtIndex: 18]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 14] point2:[pointList objectAtIndex: 15] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 14] andPoint:[pointList objectAtIndex: 15]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 14] point2:[pointList objectAtIndex: 16] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 14] andPoint:[pointList objectAtIndex: 16]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 16] point2:[pointList objectAtIndex: 18] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 16] andPoint:[pointList objectAtIndex: 18]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 11] point2:[pointList objectAtIndex: 19] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 11] andPoint:[pointList objectAtIndex: 19]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 19] point2:[pointList objectAtIndex: 20] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 19] andPoint:[pointList objectAtIndex: 20]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 20] point2:[pointList objectAtIndex: 21] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 20] andPoint:[pointList objectAtIndex: 21]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 21] point2:[pointList objectAtIndex: 22] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 21] andPoint:[pointList objectAtIndex: 22]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 21] point2:[pointList objectAtIndex: 23] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 21] andPoint:[pointList objectAtIndex: 23]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 11] point2:[pointList objectAtIndex: 12] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 11] andPoint:[pointList objectAtIndex: 12]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 12] point2:[pointList objectAtIndex: 13] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 12] andPoint:[pointList objectAtIndex: 13]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 12] point2:[pointList objectAtIndex: 19] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 12] andPoint:[pointList objectAtIndex: 19]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	CGPoint defaultPoint = CGPointMake(100, 100);
	[aMap loadDataWithMapName:@"Level 1" withMapImage:image annotationList:nil pointList:pointList edgeList:edgeList defaultCenterPoint:defaultPoint];
	return aMap;
	
}

-(Map*) createTestMap2{
	UIImage* image = [UIImage imageNamed:@"map1.jpg"];
	NSMutableArray* pointList = [[NSMutableArray alloc] init];
	NSMutableArray* edgeList = [[NSMutableArray alloc] init];
	Map* aMap = [[Map alloc] init];
	MapPoint* point = [[MapPoint alloc] initWithPosition:CGPointMake(31.000000, 30.000000) inLevel:aMap andIndex:0];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(126.000000, 33.000000) inLevel:aMap andIndex:1];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(297.000000, 69.000000) inLevel:aMap andIndex:2];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(249.000000, 16.000000) inLevel:aMap andIndex:3];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(101.000000, 197.000000) inLevel:aMap andIndex:4];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(22.000000, 185.000000) inLevel:aMap andIndex:5];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(90.000000, 282.000000) inLevel:aMap andIndex:6];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(71.000000, 331.000000) inLevel:aMap andIndex:7];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(32.000000, 373.000000) inLevel:aMap andIndex:8];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(176.000000, 462.000000) inLevel:aMap andIndex:9];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(335.000000, 469.000000) inLevel:aMap andIndex:10];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(407.000000, 277.000000) inLevel:aMap andIndex:11];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(556.000000, 279.000000) inLevel:aMap andIndex:12];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(688.000000, 278.000000) inLevel:aMap andIndex:13];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(403.000000, 115.000000) inLevel:aMap andIndex:14];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(535.000000, 59.000000) inLevel:aMap andIndex:15];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(537.000000, 184.000000) inLevel:aMap andIndex:16];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(534.000000, 121.000000) inLevel:aMap andIndex:17];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(685.000000, 139.000000) inLevel:aMap andIndex:18];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(442.000000, 319.000000) inLevel:aMap andIndex:19];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(455.000000, 424.000000) inLevel:aMap andIndex:20];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(530.000000, 448.000000) inLevel:aMap andIndex:21];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(529.000000, 387.000000) inLevel:aMap andIndex:22];
	[pointList addObject:point];
	[point release];
	point = [[MapPoint alloc] initWithPosition:CGPointMake(545.000000, 516.000000) inLevel:aMap andIndex:23];
	[pointList addObject:point];
	[point release];
	Edge* edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 0] point2:[pointList objectAtIndex: 1] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 0] andPoint:[pointList objectAtIndex: 1]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 1] point2:[pointList objectAtIndex: 3] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 1] andPoint:[pointList objectAtIndex: 3]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 3] point2:[pointList objectAtIndex: 2] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 3] andPoint:[pointList objectAtIndex: 2]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 2] point2:[pointList objectAtIndex: 1] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 2] andPoint:[pointList objectAtIndex: 1]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 1] point2:[pointList objectAtIndex: 4] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 1] andPoint:[pointList objectAtIndex: 4]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 4] point2:[pointList objectAtIndex: 5] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 4] andPoint:[pointList objectAtIndex: 5]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 4] point2:[pointList objectAtIndex: 6] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 4] andPoint:[pointList objectAtIndex: 6]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 6] point2:[pointList objectAtIndex: 7] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 6] andPoint:[pointList objectAtIndex: 7]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 7] point2:[pointList objectAtIndex: 8] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 7] andPoint:[pointList objectAtIndex: 8]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 8] point2:[pointList objectAtIndex: 9] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 8] andPoint:[pointList objectAtIndex: 9]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 9] point2:[pointList objectAtIndex: 10] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 9] andPoint:[pointList objectAtIndex: 10]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 4] point2:[pointList objectAtIndex: 11] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 4] andPoint:[pointList objectAtIndex: 11]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 11] point2:[pointList objectAtIndex: 14] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 11] andPoint:[pointList objectAtIndex: 14]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 14] point2:[pointList objectAtIndex: 17] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 14] andPoint:[pointList objectAtIndex: 17]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 17] point2:[pointList objectAtIndex: 15] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 17] andPoint:[pointList objectAtIndex: 15]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 17] point2:[pointList objectAtIndex: 16] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 17] andPoint:[pointList objectAtIndex: 16]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 17] point2:[pointList objectAtIndex: 18] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 17] andPoint:[pointList objectAtIndex: 18]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 14] point2:[pointList objectAtIndex: 15] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 14] andPoint:[pointList objectAtIndex: 15]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 14] point2:[pointList objectAtIndex: 16] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 14] andPoint:[pointList objectAtIndex: 16]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 16] point2:[pointList objectAtIndex: 18] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 16] andPoint:[pointList objectAtIndex: 18]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 11] point2:[pointList objectAtIndex: 19] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 11] andPoint:[pointList objectAtIndex: 19]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 19] point2:[pointList objectAtIndex: 20] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 19] andPoint:[pointList objectAtIndex: 20]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 20] point2:[pointList objectAtIndex: 21] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 20] andPoint:[pointList objectAtIndex: 21]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 21] point2:[pointList objectAtIndex: 22] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 21] andPoint:[pointList objectAtIndex: 22]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 21] point2:[pointList objectAtIndex: 23] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 21] andPoint:[pointList objectAtIndex: 23]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 11] point2:[pointList objectAtIndex: 12] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 11] andPoint:[pointList objectAtIndex: 12]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 12] point2:[pointList objectAtIndex: 13] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 12] andPoint:[pointList objectAtIndex: 13]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	edge = [[Edge alloc] initWithPoint1:[pointList objectAtIndex: 12] point2:[pointList objectAtIndex: 19] withLength:[MapPoint getDistantBetweenPoint:[pointList objectAtIndex: 12] andPoint:[pointList objectAtIndex: 19]] isBidirectional:YES withTravelType:kWalk];
	[edgeList addObject:edge];
	[edge release];
	CGPoint defaultPoint = CGPointMake(100, 100);
	[aMap loadDataWithMapName:@"Level 2" withMapImage:image annotationList:nil pointList:pointList edgeList:edgeList defaultCenterPoint:defaultPoint];
	return aMap;
	
}
-(NSArray*) createTestStair:(NSArray*) mList{
	Map* map1 = [mList objectAtIndex:0];
	Map* map2 = [mList objectAtIndex:1];
	Edge* anEdge = [[Edge alloc] initWithPoint1:[map1.pointList objectAtIndex:0] point2:[map2.pointList objectAtIndex:0] withLength:1 isBidirectional:YES withTravelType:kWalkStairCase];
	return [NSArray arrayWithObject:anEdge];
}

-(void) loadMaps:(NSArray *)listMap andStairs:(NSArray *)stairs withDefaultMap:(Map*) defaultMap{
	
	Map* map1 = [self createTestMap1];
	Map* map2 = [self createTestMap2];
	defaultMap = map1;
	listMap = [NSArray arrayWithObjects:map1, map2, nil];
	NSArray* stair = [self createTestStair:listMap];
	stairs = stair;	
	
	[mall buildGraphWithMaps:listMap andStairs:stairs];
	listMapViewController = [[NSMutableArray alloc] initWithCapacity:[listMap count]];
	for (int i = 0; i<[listMap count]; i++) {
		MapViewController* aMVC = [[MapViewController alloc] initMallWithFrame:CGRectMake(MAP_ORIGIN_X, MAP_ORIGIN_Y, MAP_WIDTH, MAP_HEIGHT) andMap:[listMap objectAtIndex:i]];
		aMVC.view.frame = CGRectMake(MAP_ORIGIN_X, MAP_ORIGIN_Y, MAP_WIDTH, MAP_HEIGHT);
		[listMapViewController addObject:aMVC];
		if ([[listMap objectAtIndex:i] isEqual:defaultMap]) {
			mapViewController = aMVC;
		}
		[aMVC release];
	}
	self.titleLabel.text = defaultMap.mapName;
	[self.view addSubview: mapViewController.view];
	[self.view sendSubviewToBack:mapViewController.view];
	[self.view setNeedsDisplay];
//	[mapViewController 
}

#pragma mark viewDidLoad

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	mall = [[Mall alloc] initWithId:nil andName:nil andLongitude:nil andLatitude:nil andAddress:nil andZip:nil];
	UITapGestureRecognizer* tapGesture	 = [[UITapGestureRecognizer alloc]
											initWithTarget:self action:@selector(toggleText:)];
	[tapGesture setNumberOfTapsRequired:1];
	[toogleTextButton addGestureRecognizer:tapGesture];
	
	tapGesture	 = [[UITapGestureRecognizer alloc]
											initWithTarget:self action:@selector(pathFindingClicked)];
	[tapGesture setNumberOfTapsRequired:1];
	[pathFindingButton addGestureRecognizer:tapGesture];

	UIPanGestureRecognizer* panGesture	 = [[UIPanGestureRecognizer alloc]
											initWithTarget:self action:@selector(startFlagMove:)];
	[startFlagButton addGestureRecognizer:panGesture];
	[panGesture release];

	panGesture	 = [[UIPanGestureRecognizer alloc]
											initWithTarget:self action:@selector(goalFlagMove:)];
	[goalFlagButton addGestureRecognizer:panGesture];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startOrGoalMoved:) name:@"start or goal moved" object:nil];

	[panGesture release];
	[tapGesture release];
}

#pragma mark -
#pragma mark event handling for toolbar button

-(void) moveButton:(UIImageView*) button 
	   withGesture: (UIGestureRecognizer*) gesture 
toMakeAnnotationType:(AnnotationType) annoType
		 WithTitle:(NSString*) title
		andContent:(NSString*) content
{
	CGPoint	translation = [(UIPanGestureRecognizer*) gesture translationInView:self.view];
	[(UIPanGestureRecognizer*)gesture setTranslation:CGPointZero inView:self.view];
	if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateChanged) {
		button.transform = CGAffineTransformTranslate(button.transform, translation.x, translation.y);
	}
	if (gesture.state == UIGestureRecognizerStateEnded) {
		double newX = button.frame.origin.x - mapViewController.view.frame.origin.x;
		double newY = button.frame.origin.y - mapViewController.view.frame.origin.y;
		NSLog(@"new x new y %lf %lf", newX, newY);
		// bring the button to the original position
		button.transform = CGAffineTransformIdentity;

		
		if (newX>= 0 && newY>=0)
		{
			//GameObject* aController = [[GameObject alloc] initWithType:objectType withShape:shapeType atX:newX+gamearea.contentOffset.x atY:newY+ gamearea.contentOffset.y  withWidth:size.width withHeight:size.height];
			UIScrollView* theScrollView = (UIScrollView*) mapViewController.view;
			double x = newX + button.frame.size.width/2  + theScrollView.contentOffset.x;
			double y = newY + button.frame.size.height/2 + theScrollView.contentOffset.y ;
			NSLog(@"new x new y %lf %lf", x, y);
			if (![mapViewController addAnnotationType:annoType ToScrollViewAtPosition:CGPointMake(x, y) withTitle:title withContent:content]) {
				button.transform = CGAffineTransformIdentity;
				return; // add to blocked position
			}
			if (annoType == kAnnoStart) {
				start = [mapViewController.annotationList lastObject];
			} else if (annoType == kAnnoGoal) {
				goal = [mapViewController.annotationList lastObject];
			} 
			[self startOrGoalMoved:nil];
			[button setUserInteractionEnabled:NO];
			button.alpha = 0.5;
		} 
	}
	
}

- (void)startFlagMove:(UIGestureRecognizer *)gesture{
	[self moveButton:startFlagButton withGesture:gesture toMakeAnnotationType: kAnnoStart WithTitle:@"Start" andContent:@"Your starting position"];
}

- (void)goalFlagMove:(UIGestureRecognizer *)gesture{
	[self moveButton:goalFlagButton withGesture:gesture toMakeAnnotationType: kAnnoGoal WithTitle:@"Goal" andContent:@"Your destination"];
}

-(void) startOrGoalMoved:(NSNotification*) notification{
	NSLog(@"start or goal moved");
	if (start && goal) {
		[self pathFinding];
	}
}
 
-(void) toggleText:(UIGestureRecognizer*) gesture{
	NSLog(@"toggle title");
	[mapViewController toggleDisplayText];
}

-(void) pathFinding{
	NSArray* levelConnectingPoint = [mall findPathFromStartAnnotation:start.annotation ToGoalAnnotaion:goal.annotation];
	// level connecting point is a series of map points that travel through several maps, to show a path between maps, from the start point to the goal point.
	for (int i = 0; i<[levelConnectingPoint count]-1; i++) {
		id p1 = [levelConnectingPoint objectAtIndex:i];
		id p2 = [levelConnectingPoint objectAtIndex:i+1];
		Map* lev1;
		Map* lev2;
		lev1 = [p1 level];
		lev2 = [p2 level];
		if (![lev1 isEqual:lev2]) {
			Annotation* departing = [[Annotation alloc] initAnnotationType:kAnnoConnector inlevel:lev1 WithPosition:[p1 position] title:[NSString stringWithFormat:@"to @", lev2.mapName] content:[NSString stringWithFormat:@"continue path to @", lev2.mapName]];
			[departing setIsDepartingConnector:YES];
			[departing setIsUp:[self checkLevel:lev1 isHigherThan:lev2]];
			[lev1 addAnnotation: departing];
			Annotation* arriving = [[Annotation alloc] initAnnotationType:kAnnoConnector inlevel:lev2 WithPosition:[p2 position] title:[NSString stringWithFormat:@"from @", lev1.mapName] content:[NSString stringWithFormat:@"continue path from @", lev1.mapName]];
			[departing setIsDepartingConnector:NO];
			[departing setIsUp:[self checkLevel:lev1 isHigherThan:lev2]];
			[lev2 addAnnotation: arriving];
		}
	}
	
	[mapViewController redisplayPath];
}

-(void) pathFindingClicked{
	if (!start) {
		UIAlertView * message = [[UIAlertView alloc] initWithTitle: @"Please specific start position!!" message: @"Please choose starting position by dragging the green flag to the map" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[message show];
		[message release];
		return;
		
	} else
	if (!goal) {
		UIAlertView * message = [[UIAlertView alloc] initWithTitle: @"Please specific destination!!" message: @"Please choose destination by dragging the red flag to the map" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[message show];
		[message release];
		return;
	}
	[self pathFinding];
}

- (IBAction) selectLevelClicked:(UIBarButtonItem*) sender{
	UITableViewController* listTableController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    listTableController.clearsSelectionOnViewWillAppear = NO;
	listTableController.contentSizeForViewInPopover = CGSizeMake(200.0, 300.0);
	listTableController.tableView.delegate = self;
	listTableController.tableView.dataSource = self;
	levelListController = [[UIPopoverController alloc] initWithContentViewController:listTableController];
	[levelListController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	[listTableController release];
}


-(void) choseLevel: (NSString*) chosenLevel{
	for (int i = 0; i<[listMapViewController count]; i++) {
		MapViewController* aMVC = [listMapViewController objectAtIndex:i];
		if ([aMVC.map.mapName isEqualToString:chosenLevel]) {
			[mapViewController.view removeFromSuperview];
			mapViewController = aMVC;
			[mapViewController redisplayPath];
			[self.view addSubview:mapViewController.view];
			[self.view sendSubviewToBack:mapViewController.view];
			self.titleLabel.text = mapViewController.map.mapName;
			[self.view setNeedsDisplay];
			break;
		}
	}
}

-(BOOL) checkLevel:(Map*) lev1 isHigherThan:(Map*) lev2{
	int index1 = [mall.mapList indexOfObject:lev1];
	int index2 = [mall.mapList indexOfObject:lev2];
	return index1>index2;
}

#pragma mark -
#pragma mark level list popover support methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
	[popoverController release];	
}

#pragma mark -
#pragma mark level list table view datasource - delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tbView numberOfRowsInSection:(NSInteger)section {
	return [mall.mapList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tbView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"normalCell";
	UITableViewCell *cell = [tbView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
	    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.textLabel.text = [NSString  stringWithString:[[mall.mapList objectAtIndex:[indexPath row]] mapName]];
    return cell;
}

- (void)tableView:(UITableView *)tbView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // open a alert with an OK and cancel button
    NSString* chosenLevel = [NSString stringWithString:[[mall.mapList objectAtIndex:[indexPath row]] mapName]];
	[self choseLevel: chosenLevel];
	[levelListController dismissPopoverAnimated:YES];
}


#pragma mark -


- (NSString *)subtitle{
	return @"Put some text here";
}
- (NSString *)title{
	return @"Parked Location";
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	if(self = [super init]){
		coordinate=c;
		NSLog(@"%f,%f",c.latitude,c.longitude);
	}
	return self;
}


#pragma mark -
#pragma mark Split view support
- (void)splitViewController: (UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController 
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem 
	   forPopoverController: (UIPopoverController*)pc {
	
    barButtonItem.title = @"Root List";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

- (void)splitViewController: (UISplitViewController*)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


-(void) buttonClicked:(UIButton *)sender{
	
}

@end
