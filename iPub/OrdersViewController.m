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

-(void) refreshOrders:(NSTimer*) t{
    [self getOrders];
}
-(void) getOrders {
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
        _displayText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        _displayText.text = createdString;
        _displayText.font = [UIFont systemFontOfSize:23];
        _displayText.textColor = [UIColor orangeColor];
        _displayText.backgroundColor = [UIColor clearColor];
        _displayText.numberOfLines = 1;
        

        CGFloat textLength = [_displayText.text sizeWithFont:_displayText.font constrainedToSize:CGSizeMake(9999, 50) lineBreakMode:NSLineBreakByWordWrapping].width;
        
        
        _myScrollView.contentSize = CGSizeMake(textLength, 50); //or some value you like, you may have to try this out a few times
        CGPoint origin = [_myScrollView contentOffset];
        [_myScrollView setContentOffset:CGPointMake(origin.x, 0.0)];
        
        _displayText.frame = CGRectMake(_displayText.frame.origin.x, _displayText.frame.origin.y, textLength, _displayText.frame.size.height);
        
        [_myScrollView addSubview: _displayText];
        [self.view addSubview:_myScrollView];
        _myScrollView.backgroundColor = [UIColor clearColor];

        NSLog(@"string is %@", createdString);
  
        // Delay execution of my block for 4.9 seconds.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //_displayText.text = @"";
            [self.displayText removeFromSuperview];
            [_myScrollView setContentOffset:CGPointMake(0.0, 0.0)];

        });
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brick_texture"]];
    [self getOrders];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshOrders:) userInfo:nil repeats:YES]; // the interval is in seconds...
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
