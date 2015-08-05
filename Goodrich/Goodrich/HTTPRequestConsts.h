//
//  HTTPRequestConsts.h
//  Goodrich
//
//  Created by Zhixing Yang on 16/12/14.
//  Copyright (c) 2014 Visenze. All rights reserved.
//

#define REQUEST_DOMAIN @"http://goodrich.visenze.com"

#pragma mark - Auth

#define LOGIN @"/api/login"
#define RESET_PASSWORD @"/register/retrievePassword"

#pragma mark - Product

#define PRODUCT_INFO @"/api/product"
#define PRODUCT_DETAIL @"/api/product_detail"
#define FAVORITE @"/api/favorite"
#define PATTERN_STYLE_LIST @"/api/pattern_style_list"
#define REFINE_FIELD_LIST @"/api/refine_field_list"

#pragma mark - Search

#define SEARCH_HISTORY @"/api/search_history"
#define SHARE_HISTORY @"/api/share_history"
#define TEXT_SEARCH @"/api/textsearch"
#define SEARCH @"/api/search"
#define COLOR_SEARCH @"/api/colorsearch"
#define UPLOAD_SEARCH @"/api/uploadsearch"
#define SEARCH_VISENZE @"/search"

#define SEARCH_ACCOUNT  @"goodrich/"
#define APP_ACCOUNT  @"mobile/"
#define HTTP_PREFIX  @"https://"
#define S3_END_POINT  @"s3-ap-southeast-1.amazonaws.com/"
#define S3_UPLOADER_BUCKET  @"weardex-upload-production/"