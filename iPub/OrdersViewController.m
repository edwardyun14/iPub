//
//  OrdersViewController.m
//  iPub
//
//  Created by Edward Yun on 12/24/14.
//  Copyright (c) 2014 Edward Yun. All rights reserved.
//

#import "OrdersViewController.h"

#import "IPNetworkStore.h"
#import "IPOrder.h"
#import "IPOrderCell.h"

@interface OrdersViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UILabel *myOrderNumberLabel;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, copy) NSArray *orders;

- (void)refreshOrders;

@end

@implementation OrdersViewController

#pragma mark - Static 

static NSString *const cellId = @"cellId";

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.itemSize = CGSizeMake(50, 25);
    self.flowLayout.minimumInteritemSpacing = 5;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);

    self.collectionView.collectionViewLayout = self.flowLayout;

    [self.collectionView registerNib:[UINib nibWithNibName:@"IPOrderCell" bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:cellId];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brick_texture"]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:15 target:self selector:@selector(refreshOrders:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}


#pragma mark - Private

- (void)refreshOrders:(NSTimer *) timer {
    __weak OrdersViewController *weakSelf = self;
    
    void (^successBlock)(NSArray *) = ^(NSArray *orders) {
        weakSelf.orders = orders;
        NSLog(@"SUCCESS! %@", orders);
        [weakSelf.collectionView reloadData];
    };
    
    void (^failureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"FAILURE!! %@", error);
    };
    
    [[IPNetworkStore sharedInstance] fetchOrdersWithSuccess:successBlock failure:failureBlock];
}


#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    IPOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                  forIndexPath:indexPath];
    
    NSInteger orderNumber = [self.orders[indexPath.row] orderNumber];
    
    cell.orderNumber = orderNumber;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"There are %li orders", self.orders.count);
    return self.orders.count;
}


#pragma mark - UICollectionViewDelegateFlowLayout

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
    if (buttonIndex == 1) {
        UITextField *orderNum = [alertView textFieldAtIndex:0];
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        _myOrderNumberLabel.text = orderNum.text;

    }
}


- (void)sendNotification {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Your order is ready!"
                                                            message:nil delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
    [alertView show];
}

@end
