# Server-Based-Ad
Using AFNetworking and JSON to get customized interstitial ads from your website.

Problem: You want to cross promote your own iOS apps with a simple ad, but
you don't want to update every app for a simple ad every single time you upload a new app.
Solution: Use Server-Based-Ad to grab customized ads from your server.

Using the AFNetworking framework, this project grabs a json file and parses three things.
  1) boolean - is this ad live?
  2) app link to app store - open link to your advertised app.
  3) interstitial ad image link - set the advertisement background image.
  
  
# Usage
1. Get the [AFNetworkingFramework](https://github.com/AFNetworking/AFNetworking)
2. Drag and Copy the AFNetworking folder and UIKit+AFNetworking folder into project
3. Drag and Copy ServerAds folder into project
4. Edit JSON file to your liking, upload to website, and adjust the objects in NSDictionary+dynamicAds_service accordingly
5. Edit the ServerAds.m file to add your json url location
6. Add the ServerAd view to your view


# Example
 4.NSDictionary+dynamicAds_service.m
```objective-c
NSDictionary *dict = self[@"ad_data"];
NSArray *ar = dict[@"object1"];
return ar[0];
```
get ad_link link
```objective-c
NSArray *ar = self[@"ad_link"];
NSDictionary *dict = ar[0];
return dict[@"value"];
```
get ad_image link
```objective-c
NSArray *ar = self[@"ad_image"];
NSDictionary *dict = ar[0];
return dict[@"value"];
```
 5.ServerAd.m
```objective-c
static NSString * const BaseURLString = @"http://reddit.com/";
static NSString * const endURLString = @"%@server_ad_example.json";
```
 6.ViewController.m
```objective-c
#import ServerAd.h
#import config.h
```
```objective-c
ServerAd *serverAd = [[ServerAd alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
serverAd.userInteractionEnabled = NO;
[self.view addSubview:serverAd];
```

#Credit
AFNetworking and KVO tutorials I followed

[The AFNetworking Tutorial I followed](http://www.raywenderlich.com/59255/afnetworking-2-0-tutorial)

[KVO Tutorial](http://www.raywenderlich.com/46988/ios-design-patterns)
