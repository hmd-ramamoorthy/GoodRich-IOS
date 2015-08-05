//
//  Constants.h
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

typedef enum {
    LOG_OUT_REASON_NOT_AUTH = 1,
    LOG_OUT_REASON_USER_TRIGGERED = 2
} LOG_OUT_REASON;

typedef enum{
    SEARCH_TYPE_ID = 1,
    SEARCH_TYPE_IMAGE = 2,
    SEARCH_TYPE_COLOR = 3,
    SEARCH_TYPE_PATTERN = 4,
    SEARCH_TYPE_TEXT = 5
} SEARCH_TYPE;

typedef enum{
    BROWSING_ITEMS_TYPE_ALL = 1,
    BROWSING_ITEMS_TYPE_FAVOURITE = 2,
    BROWSING_ITEMS_TYPE_SIMILAR_ITEM = 3,
    
    BROWSING_ITEMS_TYPE_SEARCH_RESULT_COLOR = 4,
    BROWSING_ITEMS_TYPE_SEARCH_RESULT_TEXT = 5,
    BROWSING_ITEMS_TYPE_SEARCH_RESULT_PATTERN = 6,
    BROWSING_ITEMS_TYPE_SEARCH_RESULT_IMAGE = 7
    
}BROWSING_ITEMS_TYPE;

#define FULL_FRAME_OF_IMAGE CGRectMake(13920, 2210, 3928, 12) // Random number to represent the full frame.

#define APP_ACCESS_KEY @"10203445515668ba2006dbbc975b4ec4"

#define TOAST_MESSAGE_NETWORK_FAILURE @"Oops, something went wrong. Please check your network connection and retry."
#define TOAST_MESSAGE_DURATION 5
#define TOAST_MESSAGE_DURATION_SHORT 1
#define TOAST_MESSAGE_POSITION @"bottom"

#define CATEGORY_TITLE_VIEW_ALL @"View all"
#define CATEGORY_TITLE_WALLCOVERING @"Wallcovering"
#define CATEGORY_TITLE_CARPET @"Carpet"
#define CATEGORY_TITLE_FABRIC @"Fabric"
#define CATEGORY_TITLE_FLOORING @"Flooring"

#define CATEGORY_KEY_WALLCOVERING @"wallcovering"
#define CATEGORY_KEY_CARPET @"carpet"
#define CATEGORY_KEY_FABRIC @"fabric"
#define CATEGORY_KEY_FLOORING @"flooring"

static const float JPEG_IMAGE_COMPRESS_RATE = 1.0;

#define MAX_ITEM_PER_ROW 10
#define MAX_ITEM_PER_SCREEN 4

// For cropView:
#define CORNER_RED_LINE_WIDTH 8
#define CORNER_RED_LINE_LENGTH 32
#define BORDER_WIDTH 8

#define IMAGE_COUNT_LIMIT 500
#define SCORE_MIN_DEFAULT_COLOR 0.05
#define SCORE_MIN_DEFAULT_UPLOAD 0.7
#define SCORE_MIN_DEFAULT_UPLOAD_COLOR 0.5
