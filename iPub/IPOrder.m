//
//  IPOrder.m
//  iPub
//
//  Created by Edward Yun on 1/31/15.
//  Copyright (c) 2015 Edward Yun. All rights reserved.
//

#import "IPOrder.h"

@implementation IPOrder

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if (self) {
        NSTimeInterval timeInterval = (NSTimeInterval) ([json[@"timeCreated"] integerValue] / 1000);
        _creationDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        _orderNumber = [json[@"orderNumber"] integerValue];
    }
    return self;
}


@end
