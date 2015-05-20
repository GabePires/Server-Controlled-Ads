//
//  ViewController.m
//  ServerAdsExample
//
//  Created by Pires on 5/19/15.
//  Copyright (c) 2015 PerpetualApps. All rights reserved.
//

#import "ViewController.h"

//server ad class
#import "ServerAd.h"

#import "config.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self showServerAd];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showServerAd{
    
    ServerAd *serverAd = [[ServerAd alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    serverAd.userInteractionEnabled = NO;
    [self.view addSubview:serverAd];
    
}
@end
