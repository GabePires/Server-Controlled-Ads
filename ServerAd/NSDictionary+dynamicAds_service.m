//
//  NSDictionary+dynamicAds_service.m
//  ServerAdsExample
//
//  Created by Pires on 5/19/15.
//  Copyright (c) 2015 PerpetualApps. All rights reserved.
//

#import "NSDictionary+dynamicAds_service.h"

@implementation NSDictionary (dynamicAds_service)

#warning depending on json file, change ad_data and such to needs
- (NSDictionary *)serverAd
{
    //everything inside root ad_data
    NSDictionary *dict = self[@"ad_data"];
    //everything inside iBooks
    NSArray *ar = dict[@"object1"];
    return ar[0];
}

//just showing that you can get other data besides the one in the above function
- (NSDictionary *)serverAd2
{
    NSDictionary *dict = self[@"ad_data"];
    NSArray *ar = dict[@"object2"];
    return ar[0];
}

//get the URL link to the app in the appstore
- (NSString *)adLinkURL
{
    NSArray *ar = self[@"ad_link"];
    NSDictionary *dict = ar[0];
    return dict[@"value"];
}

//get the advertisement image link
- (NSString *)adImageURL
{
    NSArray *ar = self[@"ad_image"];
    NSDictionary *dict = ar[0];
    return dict[@"value"];
}

@end
