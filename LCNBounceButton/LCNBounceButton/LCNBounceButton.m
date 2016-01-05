//
//  LCNBounceButton.m
//  LCNBounceButton
//
//  Created by 黄春涛 on 16/1/5.
//  Copyright © 2016年 黄春涛. All rights reserved.
//

#import "LCNBounceButton.h"

@implementation LCNBounceItemButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTarget:_delegate action:@selector(LCNBounceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end

//============================================================


@interface LCNBounceButton()

@property (nonatomic, strong) UIButton        *centerButton;
@property (nonatomic, strong) NSArray         *itemButtons;
@property (nonatomic, strong) UIView          *bottomView;

@property (nonatomic, assign) CGPoint         foldCenter;
@property (nonatomic, assign) CGPoint         bloomCenter;

@property (nonatomic, assign) CGSize          flodSize;
@property (nonatomic, assign) CGSize          bloomSize;

@property (nonatomic, assign) CGFloat         angel;
@property (nonatomic, assign) CGFloat         radius;
@property (nonatomic, assign) CGFloat         duration;

@property (nonatomic, assign) kBloomDirection direction;

@property (nonatomic, assign) BOOL            isBloomed;

@end

@implementation LCNBounceButton

- (instancetype)initWithButtonCenter:(CGPoint)center
                          buttonSize:(CGSize)size
                          bloomAngle:(CGFloat)angle
                         bloomRadius:(CGFloat)radius
                      bloomDirection:(kBloomDirection)direction
                         itemButtons:(NSArray *)itemButtons ///<LCNBounceItemButton
{
    if ( self = [super init]) {
        
        self.itemButtons = itemButtons;
        self.foldCenter = center;
        self.bloomCenter = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        
        self.flodSize = size;
        self.bloomSize = [UIScreen mainScreen].bounds.size;
        self.angel = angle;
        self.radius = radius;
        self.direction = direction;
        
        //default setting
        self.duration = 0.5f;//default Animation duration
        self.isBloomed = NO;
        
        //config self
        CGRect frame = CGRectMake(self.foldCenter.x - self.flodSize.width/2, self.foldCenter.y - self.flodSize.height/2, self.flodSize.width, self.flodSize.height);
        self.frame = frame;
        
        //config bottom
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bloomSize.width, self.bloomSize.height)];
        self.bottomView.backgroundColor = [UIColor blackColor];
        self.bottomView.alpha = 0.1f;
        self.bottomView.hidden = YES;
        [self addSubview:self.bottomView];
        
        //config centerButton
        self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.centerButton.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.centerButton setBackgroundColor:[UIColor blueColor]];
        [self.centerButton addTarget:self action:@selector(centerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.centerButton];
        
        //config itemButtons
        for (LCNBounceItemButton *button in self.itemButtons) {
            button.delegate = self.delegate;
            button.frame = CGRectMake(0, 0, size.width, size.height);
            [button setBackgroundColor:[UIColor redColor]];
        }
        
    }
    return self;
}

#pragma mark - Target & Action
-(void)centerButtonClicked:(UIButton *)sender{
    if (self.isBloomed) {
        [self flod];
    }
    else{
        [self bloom];
    }
    self.isBloomed = !self.isBloomed;
}

#pragma mark - Private Method
- (void) flod{
    
}

- (void) bloom{
    
}

@end
