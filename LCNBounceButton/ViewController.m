//
//  ViewController.m
//  LCNBounceButton
//
//  Created by 黄春涛 on 16/1/5.
//  Copyright © 2016年 黄春涛. All rights reserved.
//

#import "ViewController.h"
#import "LCNBounceButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LCNBounceButton *button = [[LCNBounceButton alloc] initWithButtonCenter:self.view.center
                                                                 buttonSize:CGSizeMake(50, 50)
                                                                 bloomAngle:120 bloomRadius:120
                                                             bloomDirection:kBloomDirectionTop
                                                                itemButtons:[NSArray array]];
    
    [self.view addSubview:button];
    
}


@end
