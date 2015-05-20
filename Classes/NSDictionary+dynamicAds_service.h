//
//  NSDictionary+dynamicAds_service.h
//  ServerAdsExample
//
//  Created by Pires on 5/11/15.
//  Copyright (c) 2015 PerpetualApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (dynamicAds_service)

- (NSDictionary *)serverAd;
- (NSDictionary *)serverAd2;
- (NSString *)adLinkURL;
- (NSString *)adImageURL;

@end
