//
//  ServerAdTransparentBG.m
//  ServerAdsExample
//
//  Created by Pires on 5/19/15.
//  Copyright (c) 2015 perpetualApps. All rights reserved.
//

#import "ServerAdTransparentBG.h"

@implementation ServerAdTransparentBG

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
    }
    return self;
}

@end
