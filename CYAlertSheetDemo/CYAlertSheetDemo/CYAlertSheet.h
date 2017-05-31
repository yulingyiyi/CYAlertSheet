//
//  CYAlertSheet.h
//  CYAlertSheetDemo
//
//  Created by SX on 2017/5/31.
//  Copyright © 2017年 YULING. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CYAlertSheetCompleteBlock)(NSInteger index);
@class CYAlertSheet;
@protocol CYAlertSheetDelegate <NSObject>

@optional

- (void)actionClickByIndex:(NSInteger)index alertSheet:(CYAlertSheet *)alertSheet;

@end

@interface CYAlertSheet : UIView


//弹出
- (void)show;
//移除
- (void)dissm;

/**
 block 方式回调

 @param title 标题 默认 请选择
 @param actions 选择的内容
 @param cancel 取消的标题 默认 取消
 @param block block
 */
+(void)showAlertSheet:(NSString *)title action:(NSArray<NSString *>*)actions cancel:(NSString *)cancel completeBlock:(CYAlertSheetCompleteBlock)block;

/**
 代理回调

 @param title 标题 默认 请选择
 @param actions 选择的内容
 @param cancel 取消的标题 默认 取消
 @param detegate detegate description
 */
+(void)showAlertSheet:(NSString *)title action:(NSArray<NSString *>*)actions cancel:(NSString *)cancel delagate:(id<CYAlertSheetDelegate>)detegate;

@end
