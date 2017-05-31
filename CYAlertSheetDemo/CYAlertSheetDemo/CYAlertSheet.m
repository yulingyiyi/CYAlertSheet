//
//  CYAlertSheet.m
//  CYAlertSheetDemo
//
//  Created by SX on 2017/5/31.
//  Copyright © 2017年 YULING. All rights reserved.
//

#import "CYAlertSheet.h"



static const CGFloat kRowHeight = 48.0f;
static const CGFloat kRowLineHeight = 0.5f;
static const CGFloat kSeparatorHeight = 6.0f;
static const CGFloat kTitleFontSize = 13.0f;
static const CGFloat kButtonTitleFontSize = 18.0f;
static const NSTimeInterval kAnimateDuration = 0.3f;

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHieght  [UIScreen mainScreen].bounds.size.height
@interface CYAlertSheet ()
{
    NSArray *_actions;
    NSString *_title;
    NSString *_cancel;
    
}
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *actionSheetView;
@property (copy) CYAlertSheetCompleteBlock block;

@property (assign) id<CYAlertSheetDelegate> delegate;
@end

@implementation CYAlertSheet

- (void)show{
    [[self window] addSubview:self];
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.backgroundView.alpha = 1.0;
        self.actionSheetView.frame =  CGRectMake(0, self.frame.size.height-self.actionSheetView.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
    }];
}
- (void)dissm{
  
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.backgroundView.alpha = 0;
        self.actionSheetView.frame =  CGRectMake(0, self.frame.size.height, self.frame.size.width, self.actionSheetView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.delegate = nil;
    }];
}
// 主要的窗口
- (UIWindow *)window{
    return [UIApplication sharedApplication].keyWindow;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = @"请选择";
        _actions = @[];
        _cancel = @"取消";
    }
    return self;
}

- (void)sheet:(NSString *)title action:(NSArray<NSString *>*)actions cancel:(NSString *)cancel completeBlock:(CYAlertSheetCompleteBlock)block  delegate:(id<CYAlertSheetDelegate>)detegate{
    

        self.frame = CGRectMake(0, 0, kWidth, kHieght);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _title = title ? title : @"" ;
        _actions = actions ? actions : @[];
        _cancel = cancel ? cancel : @"";
        _block = block;
        _delegate = detegate;
    
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHieght)];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        _backgroundView.alpha = 0;
        [self addSubview:_backgroundView];
        
        _actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, kHieght, kWidth, 0)];
        _actionSheetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _actionSheetView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
        [self addSubview:_actionSheetView];
        
        CGFloat actionSheetHeight = 0;
        
        if (_title && _title.length > 0) {
            UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, kRowHeight)];
            titleL.text = title;
            titleL.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
            titleL.font = [UIFont systemFontOfSize:kTitleFontSize];
            titleL.textAlignment = NSTextAlignmentCenter;
            titleL.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            titleL.textColor = [UIColor colorWithRed:135.0f/255.0f green:135.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
            [_actionSheetView  addSubview:titleL];
            actionSheetHeight += kRowHeight;
        }
        UIImage *normalImage = [CYAlertSheet imageWithColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
        UIImage *highlightedImage = [CYAlertSheet imageWithColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        if (actions && actions.count > 0) {
            for (int i = 0; i < actions.count; i++) {
                actionSheetHeight += kRowLineHeight;
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, actionSheetHeight, self.frame.size.width, kRowHeight);
                button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                button.tag = i+1;
                button.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
                [button setTitle:actions[i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];

                [button setBackgroundImage:normalImage forState:UIControlStateNormal];
                [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_actionSheetView addSubview:button];
                actionSheetHeight += kRowHeight;
                
            }
        }
        if (cancel && cancel.length > 0)
        {
            actionSheetHeight += kSeparatorHeight;
            
            UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake(0, actionSheetHeight, self.frame.size.width, kRowHeight);
            cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            cancelButton.tag = 0;
            cancelButton.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize];
            [cancelButton setTitle:cancel ?: @"取消" forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:normalImage forState:UIControlStateNormal];
            [cancelButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
            [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_actionSheetView addSubview:cancelButton];
            
            actionSheetHeight += kRowHeight;
        }
        
        _actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, actionSheetHeight);
     
  
    
}
- (void)buttonClicked:(UIButton *)sender{

    if (_block) {
        _block(sender.tag);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(actionClickByIndex:alertSheet:)]) {
        [_delegate actionClickByIndex:sender.tag alertSheet:self];
    }
    [self dissm];
}

+ (instancetype)alertSheet:(NSString *)title action:(NSArray<NSString *>*)actions cancel:(NSString *)cancel completeBlock:(CYAlertSheetCompleteBlock)block delegate:(id<CYAlertSheetDelegate>)detegate
{
    CYAlertSheet *sheet = [[CYAlertSheet alloc] initWithFrame:CGRectZero];
     [sheet sheet:title action:actions cancel:cancel completeBlock:block delegate:detegate];
    return sheet;
}

// 显示
+(void)showAlertSheet:(NSString *)title action:(NSArray<NSString *>*)actions cancel:(NSString *)cancel completeBlock:(CYAlertSheetCompleteBlock)block{
    
    CYAlertSheet *sheet = [self alertSheet:title action:actions cancel:cancel completeBlock:block delegate:nil];
    [sheet show];
}


+ (UIImage *)imageWithColor:(UIColor *)color{

    CGRect rect = CGRectMake(0, 0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
     CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
   
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.backgroundView];
    if (!CGRectContainsPoint(self.actionSheetView.frame, point)) {
        if (self.block) {
            self.block(0);
        }
        [self dissm];
    }
}

#pragma mark - 代理的方式

+ (void)showAlertSheet:(NSString *)title action:(NSArray<NSString *> *)actions cancel:(NSString *)cancel delagate:(id<CYAlertSheetDelegate>)detegate
{
    CYAlertSheet *sheet = [self alertSheet:title action:actions cancel:cancel completeBlock:nil delegate:detegate];
    [sheet show];

}











@end
