//
//  XyDrawerViewController.h
//  ChatDemo-UI2.0
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define CHQLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] );
#else
#define CHQLog( s, ... )
#endif

#define k_width [UIScreen mainScreen].bounds.size.width
#define k_height [UIScreen mainScreen].bounds.size.height

@protocol XyDrawerViewControllerDelegate <NSObject>
//关闭侧滑手势的代理
-(BOOL)closeTheSideEffectWithTouchView:(UIView *)view;

@end


/*
 使用方法 , 再Appledele类里的代码
 LeftViewController *letf = [[LeftViewController alloc]init];
 LeftViewController *letf2 = [[LeftViewController alloc]init];
 XyDrawerViewController *vc = [XyDrawerViewController xy_setMainVC:_mainController withLeftVC:letf andRitghtVC:letf2];
 self.window.rootViewController = vc;
 设置关闭侧滑手势的代理
 
vc.delegate = self;
 
 
 #pragma mark - XyDrawerViewControllerDelegate
 -(BOOL)closeTheSideEffectWithTouchView:(UIView *)view{
    if ([view.superview isKindOfClass:[UITableViewCell class]]||[view isKindOfClass:[UIButton class]]) {
        return YES;
    }else{
        return NO;
    }
 }
 */

@interface XyDrawerViewController : UIViewController
@property  UITapGestureRecognizer *tap;
@property id<XyDrawerViewControllerDelegate> delegate;
+(instancetype)xy_shareTheView;//创建
//创建的同时 获取右视图 和左视图  如果没有  则取消侧滑效果
+(instancetype)xy_setMainVC:(UIViewController *)mainVC withLeftVC:(UIViewController *)letfVC andRitghtVC:(UIViewController *)rightVC;
//跳转之后，是否需要侧滑，默认不允允许
+(void)allowPushed:(BOOL)allowPushed;
+(void)xy_removePan;//界面push的时候  需要关掉侧边栏的效果
+(void)xy_addPan;//有关  就有开的效果

+(void)xy_moveToLeftt;//显示左视图
+(void)xy_moveToRight;//显示右视图
+(void)xy_moveToZore;//复位
@end
