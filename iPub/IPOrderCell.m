//
//  IPOrderCell.m
//  iPub
//
//  Created by Edward Yun on 1/31/15.
//  Copyright (c) 2015 Edward Yun. All rights reserved.
//

#import "IPOrderCell.h"

@interface IPOrderCell ()

@property (nonatomic, weak) IBOutlet UILabel *orderNumberLabel;

@end

@implementation IPOrderCell

- (void)setOrderNumber:(NSInteger)orderNumber {
    self.orderNumberLabel.text = [NSString stringWithFormat:@"%li", orderNumber];
}


- (void)awakeFromNib {
    self.orderNumberLabel.font = [UIFont fontWithName:@"DotMatrix" size:23];
    self.orderNumberLabel.textColor = [UIColor orangeColor];
}




@end
