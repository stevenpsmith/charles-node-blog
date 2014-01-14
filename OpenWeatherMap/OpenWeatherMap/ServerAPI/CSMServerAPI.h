//
//  CSMServerAPI.h
//  OpenWeatherMap
//
//  Created by Steve Smith on 1/8/14.
//  Copyright (c) 2014 Steve Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CSMNetworkingErrorMessageKey @"CSMErrorMessageKey"
#define CSMNetworkingErrorKey @"CSMErrorKey"

@interface CSMServerAPI : NSObject

+ (instancetype)sharedInstance;
- (void)weatherForLongitude:(double)longitude andLatitude:(double)latitude successBlock:(void(^)(NSDictionary *weatherDict))successBlock failureBlock:(void(^)(NSError *error))failureBlock;

@end
