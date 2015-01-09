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

-(void) getOrders:(NSTimer*) t {
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
        //_displayText.text = createdString;
        UILabel *displayText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        displayText.text = createdString;
        displayText.font = [UIFont systemFontOfSize:23];
        displayText.textColor = [UIColor orangeColor];
        displayText.backgroundColor = [UIColor clearColor];
        displayText.numberOfLines = 1;

        CGFloat textLength = [displayText.text sizeWithFont:displayText.font constrainedToSize:CGSizeMake(9999, 50) lineBreakMode:NSLineBreakByWordWrapping].width;
        _myScrollView.contentSize = CGSizeMake(textLength + 20, 50); //or some value you like, you may have to try this out a few times
        CGPoint origin = [_myScrollView contentOffset];
        [_myScrollView setContentOffset:CGPointMake(origin.x, 0.0)];
        
        displayText.frame = CGRectMake(displayText.frame.origin.x, displayText.frame.origin.y, textLength, displayText.frame.size.height);
        
        [_myScrollView addSubview: displayText];
        [self.view addSubview:_myScrollView];

        NSLog(@"string is %@", createdString);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brick_texture"]];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getOrders:) userInfo:nil repeats:YES]; // the interval is in seconds...

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
