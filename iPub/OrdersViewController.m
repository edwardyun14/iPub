//
//  OrdersViewController.m
//  iPub
//
//  Created by Edward Yun on 12/24/14.
//  Copyright (c) 2014 Edward Yun. All rights reserved.
//

#import "OrdersViewController.h"

@interface OrdersViewController ()

@end

@implementation OrdersViewController

-(void) JSONParse {
//    NSData *allPubData = [[NSData alloc] initWithContentsOfURL:
//                              [NSURL URLWithString:@"http://campusdining.Vanderbilt.edu:7070/order?count=100"]];
    NSData *allPubData = [[NSData alloc] initWithContentsOfURL:
    [NSURL URLWithString:@"http://vandyapps.com:7070/order?count=100"]];
    NSError *error;
    NSMutableDictionary *allPubs = [NSJSONSerialization
                                       JSONObjectWithData:allPubData
                                       options:NSJSONReadingMutableContainers
                                    error:&error];
    NSMutableArray *orderNumbers = [[NSMutableArray alloc] init];
    if( error )
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        NSArray *orders = allPubs[@"orders"];
        for ( NSDictionary *theOrder in orders )
        {
            NSLog(@"----");
            NSLog(@"OrderNumber: %@", theOrder[@"orderNumber"] );
            NSLog(@"Time: %@", theOrder[@"timeCreated"] );
            NSLog(@"----");
            [orderNumbers addObject:theOrder[@"orderNumber"]];
        }
        NSString *createdString = [orderNumbers componentsJoinedByString:@" "];
        _displayText.text = createdString;
        NSLog(@"string is %@", createdString);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brick_texture"]];
    [self JSONParse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
