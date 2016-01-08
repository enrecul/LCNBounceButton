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

@property (nonatomic, assign) CGPoint         flodCenter;
@property (nonatomic, assign) CGPoint         bloomCenter;

@property (nonatomic, assign) CGSize          flodSize;
@property (nonatomic, assign) CGSize          bloomSize;

@property (nonatomic, assign) CGFloat         angel;
@property (nonatomic, assign) CGFloat         radius;

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
        self.flodCenter = center;
        self.bloomCenter = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        
        self.flodSize = size;
        self.bloomSize = [UIScreen mainScreen].bounds.size;
        self.angel = angle;
        self.radius = radius;
        self.direction = direction;
        
        //default setting
        self.allowRotation = YES;
        self.duration = 2.f;//default Animation duration
        self.isBloomed = NO;
        self.timeFunction = [CAMediaTimingFunction functionWithControlPoints:0 :1.49 :0.66 :1.21];
        
        //config self
        CGRect frame = CGRectMake(self.flodCenter.x - self.flodSize.width/2, self.flodCenter.y - self.flodSize.height/2, self.flodSize.width, self.flodSize.height);
        self.frame = frame;
        
        //config bottom
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bloomSize.width, self.bloomSize.height)];
        self.bottomView.backgroundColor = [UIColor blackColor];
        self.bottomView.alpha = 0.3f;
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
    self.frame = CGRectMake(self.flodCenter.x - self.flodSize.width/2, self.flodCenter.y - self.flodSize.height/2, self.flodSize.width, self.flodSize.height);
    self.centerButton.frame = CGRectMake(0, 0, self.flodSize.width, self.flodSize.height);
    self.bottomView.hidden = YES;
    self.bottomView.alpha = 0.3;
    
    for (LCNBounceItemButton *button in self.itemButtons) {
        [button removeFromSuperview];
    }
    
}

- (void) bloom{
    
    self.frame = CGRectMake(0, 0, self.bloomSize.width, self.bloomSize.height);
    self.centerButton.frame = CGRectMake(self.flodCenter.x - self.flodSize.width/2, self.flodCenter.y - self.flodSize.height/2, self.flodSize.width, self.flodSize.height);
    self.bottomView.hidden = NO;
    [UIView animateWithDuration:self.duration animations:^{
        self.bottomView.alpha = 0.4f;
    } completion:^(BOOL finished) {
    }];
    
    
    NSInteger itemButtonsCount = self.itemButtons.count;
    if (itemButtonsCount == 0) return;
    
    CGPoint startPoint = self.flodCenter;
    
    CGFloat gapAngle  = self.angel/(itemButtonsCount - 1);
    CGFloat currentAngle = (180 - self.angel)/2;
    
    //计算运动终点偏移
    for (LCNBounceItemButton *itemButton in self.itemButtons) {
//        itemButton.delegate = self;
        itemButton.center = self.flodCenter;
        [self insertSubview:itemButton belowSubview:self.centerButton];
        
        CGPoint endPoint = [self createEndPointWithRadius:self.radius andAngel:currentAngle/180.f];
        
        //增加位移动画
        CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        moveAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
        moveAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
        moveAnimation.duration = self.duration;
        moveAnimation.repeatCount = 1;
        moveAnimation.autoreverses = NO;
        //http://cubic-bezier.com
        moveAnimation.timingFunction = self.timeFunction;
        
        //增加旋转动画
        CAAnimationGroup *animations = [CAAnimationGroup animation];
        animations.duration = self.duration;
        if (self.allowRotation) {
            CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            rotationAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI * 3, 0, 0, 1)];
            rotationAnimation.duration = self.duration;
            animations.animations = @[moveAnimation,rotationAnimation];
        }
        else{
            animations.animations = @[moveAnimation];
        }
        
        [itemButton.layer addAnimation:animations forKey:nil];
        
        itemButton.center = endPoint;
        currentAngle += gapAngle;
    }
    
}

- (CGPoint)createEndPointWithRadius:(CGFloat)itemExpandRadius
                           andAngel:(CGFloat)angel {
    switch (self.direction) {
            
        case kBloomDirectionTop: {
            return CGPointMake(self.flodCenter.x + cosf((angel + 1) * M_PI) * itemExpandRadius,
                               self.flodCenter.y + sinf((angel + 1) * M_PI) * itemExpandRadius);
            break;
        }
        case kBloomDirectionTopLeft: {
            return CGPointMake(self.flodCenter.x + cosf((angel + 0.75) * M_PI) * itemExpandRadius,
                               self.flodCenter.y + sinf((angel + 0.75) * M_PI) * itemExpandRadius);

            break;
        }
        case kBloomDirectionLeft: {
            return CGPointMake(self.flodCenter.x + cosf((angel + 0.5) * M_PI) * itemExpandRadius,
                               self.flodCenter.y + sinf((angel + 0.5) * M_PI) * itemExpandRadius);
            break;
        }
        case kBloomDirectionBottomLeft: {
            return CGPointMake(self.flodCenter.x + cosf((angel + 0.25) * M_PI) * itemExpandRadius,
                               self.flodCenter.y + sinf((angel + 0.25) * M_PI) * itemExpandRadius);
            break;
        }
        case kBloomDirectionBottom: {
            return CGPointMake(self.flodCenter.x + cosf(angel * M_PI) * itemExpandRadius,
                               self.flodCenter.y + sinf(angel * M_PI) * itemExpandRadius);
            break;
        }
        case kBloomDirectionBottomRight: {
            return CGPointMake(self.flodCenter.x + cosf((angel + 1.75) * M_PI) * itemExpandRadius,
                               self.flodCenter.y + sinf((angel + 1.75) * M_PI) * itemExpandRadius);
            break;
        }
        case kBloomDirectionRight: {
            return CGPointMake(self.flodCenter.x + cosf((angel + 1.5) * M_PI) * itemExpandRadius,
                               self.flodCenter.y + sinf((angel + 1.5) * M_PI) * itemExpandRadius);
            break;
        }
        case kBloomDirectionTopRight: {
            return CGPointMake(self.flodCenter.x + cosf((angel + 1.25) * M_PI) * itemExpandRadius,
                               self.flodCenter.y + sinf((angel + 1.25) * M_PI) * itemExpandRadius);
            break;
        }
    }
}

#pragma mark - Setter & Getter
-(void)setAllowRotation:(BOOL)allowRotation{
    _allowRotation = allowRotation;
}
-(void)setDuration:(CGFloat)duration{
    _duration = duration;
}
-(void)setTimeFunction:(CAMediaTimingFunction *)timeFunction{
    _timeFunction = timeFunction;
}

@end
