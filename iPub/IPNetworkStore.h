//
//  IPNetworkStore.h
//  iPub
//
//  Created by Edward Yun on 1/31/15.
//  Copyright (c) 2015 Edward Yun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPNetworkStore : NSObject

@property (nonatomic, readonly) NSURL *url;

- (void)fetchOrdersWithSuccess:(void(^)(NSArray *))success
                       failure:(void(^)(NSError *))failure;

@end
