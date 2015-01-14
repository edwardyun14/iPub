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
            [orderNumbers addObject:theOrder[@"orderNumber"]];
        }
        
        NSString *createdString = [orderNumbers componentsJoinedByString:@" "];
        UILabel *displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        displayLabel.text = createdString;
        displayLabel.font = [UIFont systemFontOfSize:23];
        displayLabel.textColor = [UIColor orangeColor];
        displayLabel.backgroundColor = [UIColor clearColor];
        displayLabel.numberOfLines = 1;
        [displayLabel setFont:[UIFont fontWithName:@"DotMatrix" size:33]];

        CGFloat textLength = [displayLabel.text sizeWithFont:displayLabel.font constrainedToSize:CGSizeMake(9999, 50) lineBreakMode:NSLineBreakByWordWrapping].width;
        
        _myScrollView.contentSize = CGSizeMake(textLength, 50); //or some value you like, you may have to try this out a few times
        CGPoint origin = [_myScrollView contentOffset];
        [_myScrollView setContentOffset:CGPointMake(origin.x, 0.0)];
        
        displayLabel.frame = CGRectMake(displayLabel.frame.origin.x, displayLabel.frame.origin.y, textLength, displayLabel.frame.size.height);
        
        [_myScrollView addSubview: displayLabel];
        [self.view addSubview:_myScrollView];
        _myScrollView.backgroundColor = [UIColor clearColor];

        //NSLog(@"string is %@", createdString);
  
        // Delay execution of my block for 4.9 seconds.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //_displayText.text = @"";
            displayLabel.text = @"";
            [_myScrollView setContentOffset:CGPointMake(0.0, 0.0)];

        });
        
    }
}
- (IBAction)orderButtonPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pub Order:" message:@"What is your order number?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[alert textFieldAtIndex:0] becomeFirstResponder];
    [alert addButtonWithTitle:@"Done"];
    [alert show];
}

-(void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index = %ld",buttonIndex);
    if (buttonIndex == 1) {  //Done
        UITextField *orderNum = [alertView textFieldAtIndex:0];
        NSLog(@"order #: %@", orderNum.text);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//  Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brick_texture"]];
    [self getOrders];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshOrders:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
