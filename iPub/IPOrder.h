//
//  IPOrder.h
//  iPub
//
//  Created by Edward Yun on 1/31/15.
//  Copyright (c) 2015 Edward Yun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPOrder : NSObject

@property (nonatomic, readonly) NSDate *creationDate;

@property (nonatomic, readonly) NSInteger orderNumber;

- (instancetype)initWithJson:(NSDictionary *)json;

@end
