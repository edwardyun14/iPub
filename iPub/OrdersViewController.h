//
//  OrdersViewController.h
//  iPub
//
//  Created by Edward Yun on 12/24/14.
//  Copyright (c) 2014 Edward Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (copy, nonatomic) NSNumber *myOrderNumber;

@end
