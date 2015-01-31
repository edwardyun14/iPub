//
//  IPNetworkStore.m
//  iPub
//
//  Created by Edward Yun on 1/31/15.
//  Copyright (c) 2015 Edward Yun. All rights reserved.
//

#import "IPNetworkStore.h"

#import "IPOrder.h"

@interface IPNetworkStore ()

@end


@implementation IPNetworkStore

#pragma mark - Static 

/*
static NSString *const urlString = @"http://campusdining.vanderbilt.edu:7070/order?count=100";
*/

static NSString *const urlString = @"http://vandyapps.com:7070/order?count=100";

#pragma mark - Getters/Setters

- (NSURL *)url {
    return [NSURL URLWithString:urlString];
}

#pragma mark - Private


#pragma mark - Network

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


@end
