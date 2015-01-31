//
//  IPNetworkStore.h
//  iPub
//
//  Created by Edward Yun on 1/31/15.
//  Copyright (c) 2015 Edward Yun. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const IPNetworkStoreDidFetchOrders;

extern NSString *const IPNetworkStoreDidFailToFetchOrders;

@interface IPNetworkStore : NSObject

@property (nonatomic, readonly) NSURL *url;

+ (instancetype)sharedInstance;

- (void)registerOrderNumber:(NSInteger)orderNumber;

- (void)unregisterOrderNumber:(NSInteger)orderNumber;

- (void)beginListeningToServer;

- (void)stopListeningToServer;

@end
