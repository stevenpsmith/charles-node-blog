//
//  CSMServerAPI.m
//  OpenWeatherMap
//
//  Created by Steve Smith on 1/8/14.
//  Copyright (c) 2014 Steve Smith. All rights reserved.
//

#import "CSMServerAPI.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>

#define kBaseURL @"http://api.openweathermap.org/data/2.5/"

@interface CSMServerAPI (){
    AFHTTPRequestOperationManager *_requestManager;
}

@end

@implementation CSMServerAPI

+ (instancetype)sharedInstance {
    static CSMServerAPI *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[CSMServerAPI alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    _requestManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    return self;
}

#pragma mark - Weather

- (void)weatherForLongitude:(double)longitude andLatitude:(double)latitude successBlock:(void(^)(NSDictionary *weatherDict))successBlock failureBlock:(void(^)(NSError *error))failureBlock {
    NSDictionary *params = @{ @"lon" : @(longitude), @"lat" : @(latitude) };
    [_requestManager GET:@"weather" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock){
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request failed: %@", [error localizedDescription]);
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[error userInfo]];
        //make sure we are trying to handle an application error from the server
        if ([[operation responseObject] isKindOfClass:[NSDictionary class]]){
            [userInfo setObject:[[operation responseObject] objectForKey:@"error_msg"] forKey:CSMNetworkingErrorMessageKey];
            [userInfo setObject:[[operation responseObject] objectForKey:@"error"] forKey:CSMNetworkingErrorKey];
        }
        
        NSError *myError = [NSError errorWithDomain:@"com.asyncinterview" code:[error code] userInfo:userInfo];
        if (failureBlock){
            failureBlock(myError);
        }
    }];
}

@end
