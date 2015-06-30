//
//  ServerAd.m
//  ServerAdsExample
//
//  Created by Pires on 5/19/15.
//  Copyright (c) 2015 PerpetualApps. All rights reserved.
//

#import "ServerAd.h"
#import "config.h"

//some AFNetworking header files
#import "NSDictionary+dynamicAds_service.h"

//get image from online
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"

//for transparent black bg
#import "ServerAdTransparentBG.h"

#import "AFNetworking.h"

#warning change this according to website and json file link.
//example: our json file is located at http://getclickcraft.com/server_ad_example.json
static NSString * const BaseURLString = @"http://getclickcraft.com/";
//%@ will be filled in with the BaseURLString
static NSString * const endURLString = @"%@server_ad_example.json";

@interface ServerAd () {
    
    //transparent black layer
    ServerAdTransparentBG *transparentBlack;
    
    //Our advertisement image grabbed from the internet
    UIImageView *dynamicInterstitial;
    
    //The three main things we grab from our json file located on our website
    BOOL serverAdBool; //do we want to show the ad?
    NSString *serverAdURL; //grab the link of the app we want to advertise
    NSString *serverAdImgURL; //grab the link of the image of our advertisement
    
    NSDictionary *jsonData;
    
}

@end


@implementation ServerAd

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self showServerAd];
    }
    return self;
}

//parse json file from our website
-(void)showServerAd{
    
    //make an NSURLRequest from our NSURL object from our full url string.
    NSString *stringURL = [NSString stringWithFormat:endURLString, BaseURLString];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //responseSerializer set to JSON serializer. AFNetworking parses the JSON file for us.
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //success block.
        //our received json file is saved here
        jsonData = (NSDictionary *)responseObject;
        
        //we call our function serverAd from the NSDictionary helper
        //this returns our json file parsed into our dictionary with only the info we want
        NSDictionary *ad_json = [jsonData serverAd];
        
        //a value ad_bool in our json file. Do we want to show this ad?*
        //save this as a boolean
        serverAdBool = [ad_json[@"ad_bool"] boolValue];
        
        //save appstore link as string here.
        serverAdURL = [ad_json adLinkURL];
        
        //save image url, which will help us load the image of our ad online.
        serverAdImgURL = [ad_json adImageURL];
        
        //*Do we want to show this ad? if so, let's load the ad.
        if(serverAdBool == YES){
            
            //create a placeholder for our downloaded ad image.
            NSURL *url = [NSURL URLWithString:serverAdImgURL];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
            
            //create a transparent background so only our ad can be interacted with.
            transparentBlack = [[ServerAdTransparentBG alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            
            //different size of ad for an ipad
            if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] ) {
                dynamicInterstitial = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*0.17, kScreenHeight*0.09, kScreenWidth*0.66, kScreenHeight*0.79)];
            }
            else{
                dynamicInterstitial = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth*0.07, kScreenHeight*0.06, kScreenWidth*0.86, kScreenHeight*0.79)];//242,394
            }
            
            //we store our dynamicInterstitial in a weak uiimageview to avoid a retain cycle in our block
            __weak UIImageView *dyn = dynamicInterstitial;
            
            //KVO Model - will call observeValueForKeyPath when our image changes from placeholder to
            //the actual grabbed ad image.
            [dynamicInterstitial addObserver:self forKeyPath:@"image" options:0 context:nil];
            
            //our block: if success, set our ad image in. Because we are using a KVO model,
            //and we set out dynamic interstitial to be observed, once it changes image, we call
            //the function observeValueForKeyPath....with keypath @"image"
            [dynamicInterstitial setImageWithURLRequest:request
                                       placeholderImage:placeholderImage
                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                    
                                                    [dyn setImage: image];
                                                    
                                                } failure:nil]; //you can choose to have an in house ad not from the interwebs here

        }
        
        //if the htpp request fails, we do nothing, just remove this entire view
        //you can choose to have an in house ad not from the interwebs here
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to connect to server for ad");
        [self removeFromSuperview];
    }];
    
    [operation start];
    
}

//KVO - add in our server ad image, transparent bg, and interactive buttons only after the image has loaded successfully.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"image"])
    {
        NSLog(@"server ad image loaded");
        
        self.userInteractionEnabled = YES;
        
        dynamicInterstitial.userInteractionEnabled = YES;
        
        [self addSubview:transparentBlack];
        [self addSubview:dynamicInterstitial];
        
        
        [self addServerButtons];
        
    }
}
- (void)dealloc
{
    //necessary for KVO
    [dynamicInterstitial removeObserver:self forKeyPath:@"image"];
}

//programmatically add our buttons to the ad
- (void)addServerButtons{
    //User clicks x, exit the ad without further action
    UIButton *exit = [[UIButton alloc]initWithFrame:CGRectMake(dynamicInterstitial.frame.size.width*0.035, dynamicInterstitial.frame.size.height*0.91, dynamicInterstitial.frame.size.width*0.11, dynamicInterstitial.frame.size.width*0.11)];
    [exit setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
    [exit addTarget:self action:@selector(exitServerAd) forControlEvents:UIControlEventTouchUpInside];
    [dynamicInterstitial addSubview:exit];
    
    //User clicks check, open the advertised app in appstore
    UIButton *check = [[UIButton alloc]initWithFrame:CGRectMake(dynamicInterstitial.frame.size.width*0.85, dynamicInterstitial.frame.size.height*0.91, dynamicInterstitial.frame.size.width*0.11, dynamicInterstitial.frame.size.width*0.11)];
    [check setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
    [check addTarget:self action:@selector(openAppStore) forControlEvents:UIControlEventTouchUpInside];
    [dynamicInterstitial addSubview:check];
    
    //User clicks play now, open the advertised app in appstore
    UIButton *playNow = [[UIButton alloc]initWithFrame:CGRectMake(dynamicInterstitial.frame.size.width*0.13, dynamicInterstitial.frame.size.height*0.75, dynamicInterstitial.frame.size.width*0.74, dynamicInterstitial.frame.size.height*0.1)];
    [playNow setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    [playNow addTarget:self action:@selector(openAppStore) forControlEvents:UIControlEventTouchUpInside];
    [dynamicInterstitial addSubview:playNow];
}

//opens appstore to advertised app
- (void)openAppStore{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:serverAdURL]];
    
    //after opens up appstore, close the ad.
    [self exitServerAd];
    
}

//close ad
- (void)exitServerAd{
    NSArray *removeSubviews = [self subviews];
    for (UIView *v in removeSubviews) {
        [v removeFromSuperview];
    }

    [self removeFromSuperview];
}

@end
