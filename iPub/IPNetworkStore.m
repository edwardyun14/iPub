//
//  IPNetworkStore.m
//  iPub
//
//  Created by Edward Yun on 1/31/15.
//  Copyright (c) 2015 Edward Yun. All rights reserved.
//

#import "IPNetworkStore.h"

#import "IPOrder.h"

NSString *const IPNetworkStoreDidFetchOrders = @"IPNetworkStoreDidFetchOrders";

NSString *const IPNetworkStoreDidFailToFetchOrders = @"IPNetworkStoreDidFailToFetchOrders";

@interface IPNetworkStore ()

@property (nonatomic, assign) NSInteger orderNumber;

@property (nonatomic, strong) NSTimer *timer;

- (void)refreshOrders:(NSTimer *)timer;

- (void)fetchOrdersWithSuccess:(void(^)(NSArray *))success
                       failure:(void(^)(NSError *))failure;

@end


@implementation IPNetworkStore

#pragma mark - Static 

static NSTimeInterval refreshRate = 1;
/*
static NSString *const urlString = @"http://campusdining.vanderbilt.edu:7070/order?count=100";
*/

static NSString *const urlString = @"http://vandyapps.com:7070/order?count=100";

static IPNetworkStore *instance;

#pragma mark - Getters/Setters

- (NSURL *)url {
    return [NSURL URLWithString:urlString];
}

#pragma mark - Initializers

+ (instancetype)sharedInstance {

    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[IPNetworkStore alloc] init];
    });
    
    return instance;
}

#pragma mark - Private

- (void)refreshOrders:(NSTimer *)timer {
    NSLog(@"Refreshing orders");
    void(^successBlock)(NSArray *) = ^(NSArray *orders) {
        NSDictionary *userInfo = @{ @"orders": orders };
        [[NSNotificationCenter defaultCenter] postNotificationName:IPNetworkStoreDidFetchOrders object:nil userInfo:userInfo];
    };
    
    void (^failureBlock)(NSError *) = ^(NSError *error) {
        NSDictionary *userInfo = @{ @"error": error };
        [[NSNotificationCenter defaultCenter] postNotificationName:IPNetworkStoreDidFailToFetchOrders object:nil userInfo:userInfo];
    };
    
    [self fetchOrdersWithSuccess:successBlock failure:failureBlock];
}


#pragma mark Network

- (void)fetchOrdersWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
    
    void (^completionTask) (NSData *, NSURLResponse *, NSError *) =
    ^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSLog(@"NEtwork refresh");
                NSError *parseError;
                NSMutableDictionary *allPubs = [NSJSONSerialization
                                                JSONObjectWithData:data
                                                options:NSJSONReadingMutableContainers
                                                error:&parseError];
                
                if (parseError) {
                    failure(error);
                }
                
                NSMutableArray *orders = [[NSMutableArray alloc] init];
                for (NSDictionary *json in [allPubs objectForKey:@"orders"]) {
                    [orders addObject:[[IPOrder alloc] initWithJson:json]];
                }
                success([orders copy]);
            }
            else {
                failure(error);
            }
        });
    };
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:completionTask];
    
    [task resume];
    
}

#pragma mark - Public

- (void)beginListeningToServer {
    // Check if there is a timer running.
    if (self.timer) {
        // Throw an error, there is already a timer
        // running.
    }
    else {
        NSLog(@"Calling begin server");
        self.timer = [NSTimer timerWithTimeInterval:refreshRate
                                             target:self
                                           selector:@selector(refreshOrders:)
                                           userInfo:nil
                                            repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        
        
    }
}

- (void)registerOrderNumber:(NSInteger)orderNumber {
    self.orderNumber = orderNumber;
}

- (void)unregisterOrderNumber:(NSInteger)orderNumber {
    if (self.orderNumber == orderNumber) {
        self.orderNumber = 0;
    }
}


@end
