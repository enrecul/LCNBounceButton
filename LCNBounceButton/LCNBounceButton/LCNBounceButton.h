//
//  LCNBounceButton.h
//  LCNBounceButton
//
//  Created by 黄春涛 on 16/1/5.
//  Copyright © 2016年 黄春涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, kBloomDirection){
    kBloomDirectionTop         = 1,
    kBloomDirectionTopLeft     = 2,
    kBloomDirectionLeft        = 3,
    kBloomDirectionBottomLeft  = 4,
    kBloomDirectionBottom      = 5,
    kBloomDirectionBottomRight = 6,
    kBloomDirectionRight       = 7,
    kBloomDirectionTopRight    = 8,
};

@protocol LCNBounceButtonDelegate <NSObject>

- (void)LCNBounceButtonClicked:(UIButton *)sender;

@end

//=====================================================================

@interface LCNBounceItemButton : UIButton

@property (nonatomic, strong) id<LCNBounceButtonDelegate> delegate;

@end

//=====================================================================

@interface LCNBounceButton : UIView

@property (nonatomic, strong) id<LCNBounceButtonDelegate> delegate;

- (instancetype)initWithButtonCenter:(CGPoint)center
                          buttonSize:(CGSize)size
                          bloomAngle:(CGFloat)angle
                         bloomRadius:(CGFloat)radius
                      bloomDirection:(kBloomDirection)direction
                         itemButtons:(NSArray *)itemButtons; ///<LCNBounceItemButton

@end
