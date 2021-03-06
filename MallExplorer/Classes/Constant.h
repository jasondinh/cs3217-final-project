//
//  Constant.h
//  MallExplorer
//
//  Created by Jason Dinh on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define debug NO

// Map constant
#define MAP_ORIGIN_X 3
#define MAP_ORIGIN_Y 50
#define MAP_WIDTH	697
#define MAP_HEIGHT	648

// Graph constant
#define MAX_NODES 200

// portrait
#define MAP_PORTRAIT_WIDTH	762
#define MAP_PORTRAIT_HEIGHT	905


// Annotation constants
#define ANNOTATION_VIEW_HEIGHT 30
#define ANNOTATION_VIEW_WIDTH 30

// Annotation title:
#define LENGTH_PER_CHARACTER 12.5
#define CAPTION_HEIGHT 18

// Line view constant:
#define DRAW_PATH_WIDTH 7
#define DRAW_DASH_LENGTH 15
#define DRAW_EMPTY_LENGTH 10
#define DRAW_STEP_LENGTH 5
#define MAX_PHASE_LINE 27

//API constant

//#define API_END_POINT @"http://cs3217.heroku.com"
#define API_END_POINT @"http://macmini.dyndns.biz:3000"
//#define API_END_POINT @"http://localhost:3000"

//UISplitView constants;
#define POPOVER_WIDTH 320
#define POPOVER_HEIGHT 850

//ShopView constants
#define TAB_BAR_ICON_WIDTH 30
#define TAB_BAR_ICON_HEIGHT 30

//travel time estimating
#define M_TRAVEL_PER_MINUTE 60
#define TIME_TRAVEL_PER_STAIR_IN_MINUTE 0.5 

//Constants for CityMapViewController
#define SPAN_LONGITUDE 0.02
#define SPAN_LATITUDE 0.02
#define NEARBY_LONGITUDE 0.2
#define NEARBY_LATITUDE 0.2
#define INSIDE_LONGITUDE 0.002
#define INSIDE_LATITUDE 0.002

#define FB_APP_ID @"100690146686000"
@protocol Constant


@end
