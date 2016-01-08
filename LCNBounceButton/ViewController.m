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
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0 ; i < 20; i++) {
        LCNBounceItemButton *button = [LCNBounceItemButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor blueColor]];
        button.frame = CGRectMake(0, 0, 2, 2);
        [array addObject:button];
    }
    
    LCNBounceButton *button = [[LCNBounceButton alloc] initWithButtonCenter:self.view.center
                                                                 buttonSize:CGSizeMake(30, 30)
                                                                 bloomAngle:120
                                                                bloomRadius:100
                                                             bloomDirection:kBloomDirectionTop
                                                                itemButtons:array];
    
    button.duration = .5f;
    button.allowRotation = YES;
    
    [self.view addSubview:button];
    
    
}


@end
