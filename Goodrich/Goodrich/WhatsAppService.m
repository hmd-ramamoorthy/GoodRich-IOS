//
//  WhatsAppService.m
//  Goodrich
//
//  Created by Sai on 6/17/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "WhatsAppService.h"
#import "Product.h"
#import "EmailModel.h"
#import "NSString+NSString_UrlEncoding.h"

@implementation WhatsAppService

+ (void)sendWhatsAppMessageWithProducts:(NSArray *)products {
    // used for update models info
    EmailModel *model = [[EmailModel alloc] initWithProducts:products];
    [model.services retrieveDetailWithIds:model.productIds success:^(NSInteger statusCode, id response) {
        NSString *sendingMessage = [self allProductsProperties:model.products];
        NSLog(@"message is %@", [sendingMessage urlencode]);
        
        NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",[sendingMessage urlencode]]];
        if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
            [[UIApplication sharedApplication] openURL: whatsappURL];
        }

    } failure:^(NSInteger statusCode, id response) {
        ;
    }];    
}

+ (NSString *)allProductsProperties:(NSArray *)products {
    NSMutableArray *results = [NSMutableArray array];
    for (Product *p in products) {
        [results addObjectsFromArray:[self propertitiesFrom:p]];
    }
    
    return [results componentsJoinedByString:@"\n"];
}

+ (NSArray *)propertitiesFrom:(Product *)product {
    NSMutableArray *properties = [NSMutableArray array];
    // item name
    [properties addObject:[[product.details objectForKey:@"Category"] uppercaseString]];
    
    // item properties
    NSArray *sequenceKeys = [self detailSequenceKeysWithType:[product.details objectForKey:@"Category"]];
    for (NSString *key in sequenceKeys) {
        if (![product.details objectForKey:key]) continue; // if nil, no need to display
        
        [properties addObject:[NSString stringWithFormat:@"%@ : %@",key, [product.details objectForKey:key]]];
    }
    
    // item url
    [properties addObject:product.s3URL];
    
    // blank line
    [properties addObject:@"\n"];
    
    return properties;
}

+ (NSArray *)detailSequenceKeysWithType:(NSString *)type {
    if (!type) {
        return nil;
    }
    
    NSMutableArray *keys = [NSMutableArray array];
    
    if([type isEqualToString:@"wallcovering"]){
        [keys addObject:@"PatternNumber"];
        [keys addObject:@"Collection"];
        [keys addObject:@"ProductType"];
        [keys addObject:@"RollWidth"];
        [keys addObject:@"RollLength"];
        [keys addObject:@"Weight"];
        [keys addObject:@"Backing"];
        [keys addObject:@"PatternRepeat"];
        [keys addObject:@"FireRating"];
        [keys addObject:@"Supplier"];
        [keys addObject:@"Origin"];
        [keys addObject:@"PatternStyle"];
        [keys addObject:@"Category"];
    }else if([type isEqualToString:@"fabric"]){
        [keys addObject:@"Color"];
        [keys addObject:@"PatternNumber"];
        [keys addObject:@"Collection"];
        [keys addObject:@"Width"];
        [keys addObject:@"Composition"];
        [keys addObject:@"Abrasion"];
        [keys addObject:@"PatternRepeat"];
        [keys addObject:@"Remarks"];
        [keys addObject:@"Supplier"];
        [keys addObject:@"Usage"];
        [keys addObject:@"PatternStyle"];
        [keys addObject:@"ProductType"];
        [keys addObject:@"Category"];
    }else if([type isEqualToString:@"carpet"]){
        [keys addObject:@"PatternNumber"];
        [keys addObject:@"Collection"];
        [keys addObject:@"ProductType"];
        [keys addObject:@"Size/Width"];
        [keys addObject:@"PileWeight"];
        [keys addObject:@"DyeingMethod"];
        [keys addObject:@"Yarn"];
        [keys addObject:@"Backing"];
        [keys addObject:@"Construction"];
        [keys addObject:@"Supplier"];
        [keys addObject:@"PatternStyle"];
        [keys addObject:@"Category"];
    }else{
        [keys addObject:@"PatternNumber"];
        [keys addObject:@"Collection"];
        [keys addObject:@"ProductType"];
        [keys addObject:@"WoodSpecies"];
        [keys addObject:@"Size(Length-mm)"];
        [keys addObject:@"Size(Width-mm)"];
        [keys addObject:@"Size(sqm/UOM)"];
        [keys addObject:@"Size(Thickness-mm)"];
        [keys addObject:@"UOM"];
        [keys addObject:@"Supplier"];
        [keys addObject:@"CountryofOrigin"];
        [keys addObject:@"PatternStyle"];
        [keys addObject:@"Category"];
    }
    
    return keys;
}


@end
