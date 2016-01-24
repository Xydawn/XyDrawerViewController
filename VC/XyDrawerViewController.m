//
//  XyDrawerViewController.m
//  ChatDemo-UI2.0
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "XyDrawerViewController.h"
#define Xy_PIANYI 3/5.0*k_width



@interface XyDrawerViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIViewController *xy_mainVC;
@property (nonatomic,strong) UIViewController *xy_letfVC;
@property (nonatomic,strong) UIViewController *xy_rightVC;
@property (nonatomic) BOOL changed;
@property (nonatomic,strong) UIView *black;
@property  UIPanGestureRecognizer *pan;
@property (nonatomic) BOOL allowPushed;

@end

@implementation XyDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


+(void)allowPushed:(BOOL)allowPushed{
    XyDrawerViewController *vc = [XyDrawerViewController xy_shareTheView];
    vc.allowPushed = allowPushed;
}

+(void)xy_addPan{
    XyDrawerViewController *vc  = [XyDrawerViewController xy_shareTheView];
    [vc.xy_mainVC.view addGestureRecognizer:vc.pan];
}

+(void)xy_removePan{
    XyDrawerViewController *vc  = [XyDrawerViewController xy_shareTheView];
    [vc.xy_mainVC.view removeGestureRecognizer:vc.pan];
}

+(instancetype)xy_shareTheView{
    static XyDrawerViewController *vc ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [[XyDrawerViewController alloc]init];
        vc.pan = [[UIPanGestureRecognizer alloc]initWithTarget:vc action:@selector(xy_moveWithPan:)];
        vc.pan.delegate = vc;
        vc.allowPushed = NO;
        vc.black = [[UIView alloc]initWithFrame:CGRectMake(0, 0, k_width, k_height)];
        vc.black.backgroundColor = [UIColor blackColor];
        vc.black.alpha =  0;
        vc.black.hidden = YES;
        vc.tap = [[UITapGestureRecognizer alloc]initWithTarget:vc action:@selector(xy_moveToZoretWith:)];
        [vc.black addGestureRecognizer:vc.tap];
        });
    return vc;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if (touch.view == self.black) {
        return NO;
    }else
    if (self.delegate) {
        CHQLog(@"%@",touch.view.superview.class)
        
        if([self.delegate closeTheSideEffectWithTouchView:touch.view]){
      
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}


+(instancetype)xy_setMainVC:(UIViewController *)mainVC withLeftVC:(UIViewController *)letfVC andRitghtVC:(UIViewController *)rightVC{
    
        XyDrawerViewController *vc = [XyDrawerViewController xy_shareTheView];
    
        if (letfVC) {
            vc.xy_letfVC = letfVC;
            vc.xy_letfVC.view.hidden = YES;
            vc.xy_letfVC.view.alpha = 0.0;
            [vc addChildViewController:letfVC];
             [vc.xy_letfVC willMoveToParentViewController:vc];
            letfVC.view.frame = vc.view.bounds;
            [vc.view addSubview:letfVC.view];
            [vc.xy_letfVC didMoveToParentViewController:vc];
        }
        if (rightVC) {
            vc.xy_rightVC = rightVC;
            vc.xy_rightVC.view.hidden = YES;
            vc.xy_rightVC.view.alpha = 0.0;
            [vc addChildViewController:rightVC];
            rightVC.view.frame = vc.view.bounds;
            [vc.view addSubview:rightVC.view];
            [vc.xy_rightVC didMoveToParentViewController:vc];
        }
        if (mainVC) {
            [mainVC.view addSubview:vc.black];
            vc.xy_mainVC = mainVC ;
            [vc.xy_mainVC.view  addGestureRecognizer:vc.pan];
            [vc addChildViewController:mainVC];
            [vc.view addSubview:mainVC.view];
            [vc.view bringSubviewToFront:mainVC.view];
            [vc.xy_mainVC didMoveToParentViewController:vc];
//            [vc.xy_mainVC.view addObserver:vc forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|
//NSKeyValueObservingOptionOld context:nil];
        }
    return vc;
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//
//    if ([keyPath isEqualToString:@"frame"]) {
//        if (self.xy_mainVC.view.frame.origin.x==0) {
//            self.changed = NO;
//            self.xy_rightVC.view.hidden = YES;
//            self.xy_letfVC.view.hidden = YES;
//        }
//    }
//}


-(void)xy_moveWithPan:(UIPanGestureRecognizer *)pan{
   
    if ([self whenPushReturn]) {
        CHQLog(@"跳转之后，关闭侧边栏")
        return;
    }
  
    CGPoint point = [pan translationInView:self.view];
        CHQLog(@"%f",point.x)
    
    if (self.xy_rightVC==nil&&point.x<0&&pan.view.frame.origin.x<=0) {
        [self xy_moveToZoretWith:pan];
        CHQLog(@"并没有右视图")
        return;
    }else{
         self.xy_rightVC.view.hidden = NO;
    }
    if (self.xy_letfVC==nil&&point.x>0&&pan.view.frame.origin.x>=0) {
        [self xy_moveToZoretWith:pan];
        CHQLog(@"并没有左视图")
        return;
    }else{
        self.xy_letfVC.view.hidden = NO;
    }
//    if ((point.x>0&&pan.view.frame.origin.x>=Xy_PIANYI&&self.changed)) {//||(pan.view.frame.origin.x+point.x>=Xy_PIANYI)
//          [self xy_moveToLefttWith:pan];
//    }
//    
//    if ((point.x<0&&pan.view.frame.origin.x<=-Xy_PIANYI&&self.changed)) {//||(pan.view.frame.origin.x+point.x<=-Xy_PIANYI)
//             [self xy_moveToRightWith:pan];
//    }
    
    
    if (pan.state ==UIGestureRecognizerStateEnded ) {
        if (pan.view.frame.origin.x>=1/6.0*k_width&&!self.changed) {
      
            [self xy_moveToLefttWith:pan];
        }else if (pan.view.frame.origin.x<=-1/6.0*k_width&&!self.changed){
       
          [self xy_moveToRightWith:pan];
        }else {//if(pan.view.frame.origin.x<=2/6.0*k_width&&pan.view.frame.origin.x>=-2/6.0*k_width)
            
            [self  xy_moveToZoretWith:pan];
        }
    }
    
    if (point.x>0) {
       [UIView animateWithDuration:0.75 animations:^{
           self.xy_letfVC.view.alpha =0.5;
       }];
    }
    if (point.x<0) {
        [UIView animateWithDuration:0.75 animations:^{
            self.xy_rightVC.view.alpha =0.5;
        }];
    }
    
    
    
    pan.view.center = CGPointMake(pan.view.center.x+point.x, pan.view.center.y);
//    pan.view.transform = CGAffineTransformScale(pan.view.transform, 4/5.0, 4/5.0);
    [pan setTranslation:CGPointZero inView:self.view];

}


-(BOOL)whenPushReturn{
    if (self.allowPushed) {
        return !_allowPushed;
    }
    for (UINavigationController *nav in self.xy_mainVC.childViewControllers) {
        //跳转之后关闭侧滑
        if (nav.childViewControllers.count>1) {
            CHQLog(@"已跳转")
            return YES;
        }
    }
    return NO;
}


-(void)xy_moveToRightWith:(UIPanGestureRecognizer *)pan{
    if (self.xy_rightVC) {
        [UIView animateWithDuration:0.5 animations:^{
            self.xy_letfVC.view.alpha = 0.0;
            self.xy_letfVC.view.hidden = YES;
            self.xy_rightVC.view.alpha = 1.0;
            self.view.userInteractionEnabled = NO;
            self.black.alpha = 0.5;
            self.black.hidden = NO;
            self.xy_mainVC.view.frame = CGRectMake(-Xy_PIANYI, 0, k_width, k_height);
        }completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
            self.changed = YES;
            
        }];
    }else{
        [self xy_moveToZoretWith:pan];
    }
    
}

-(void)xy_moveToLefttWith:(UIPanGestureRecognizer *)pan{
    if (self.xy_letfVC) {
        [UIView animateWithDuration:0.5 animations:^{
            self.xy_rightVC.view.alpha = 0.0;
            self.xy_rightVC.view.hidden = YES;
            self.xy_letfVC.view.alpha = 1.0;
            self.black.alpha = 0.5;
            self.black.hidden = NO;
            self.view.userInteractionEnabled = NO;
            self.xy_mainVC.view.frame = CGRectMake(Xy_PIANYI, 0, k_width, k_height);
        }completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
            self.changed  = YES;
        }];
    }else{
        [self xy_moveToZoretWith:pan];
    }
}



-(void)xy_moveToZoretWith:(UIPanGestureRecognizer *)pan{
       [UIView animateWithDuration:0.5 animations:^{
        self.view.userInteractionEnabled = NO;
        self.xy_mainVC.view.frame = CGRectMake(0, 0, k_width, k_height);
        self.black.alpha = 0.0;
        self.xy_letfVC.view.alpha = 0.0;
        self.xy_rightVC.view.alpha = 0.0;
    }completion:^(BOOL finished) {
        self.black.hidden = YES;
        self.view.userInteractionEnabled = YES;
        self.changed = NO;
        self.xy_rightVC.view.hidden = YES;
        self.xy_letfVC.view.hidden = YES;
     
    }];
    
}

+(void)xy_moveToRight{
    XyDrawerViewController *vc = [XyDrawerViewController xy_shareTheView];
    [UIView animateWithDuration:0.5 animations:^{
        vc.xy_rightVC.view.alpha = 1.0;
        vc.view.userInteractionEnabled = NO;
        vc.black.alpha = 0.5;
        vc.black.hidden = NO;
        vc.xy_mainVC.view.frame = CGRectMake(-Xy_PIANYI, 0, k_width, k_height);
    }completion:^(BOOL finished) {
        vc.view.userInteractionEnabled = YES;
        vc.changed = YES;
        
    }];
}

+(void)xy_moveToLeftt{
    XyDrawerViewController *vc = [XyDrawerViewController xy_shareTheView];
    [UIView animateWithDuration:0.5 animations:^{
        vc.xy_letfVC.view.alpha = 1.0;
        vc.black.alpha = 0.5;
        vc.black.hidden = NO;
        vc.view.userInteractionEnabled = NO;
        vc.xy_mainVC.view.frame = CGRectMake(Xy_PIANYI, 0, k_width, k_height);
    }completion:^(BOOL finished) {
        vc.view.userInteractionEnabled = YES;
        vc.changed  = YES;
    }];
}

+(void)xy_moveToZore{
    XyDrawerViewController *vc = [XyDrawerViewController xy_shareTheView];
    [UIView animateWithDuration:0.5 animations:^{
        vc.view.userInteractionEnabled = NO;
        vc.xy_mainVC.view.frame = CGRectMake(0, 0, k_width, k_height);
        vc.black.alpha = 0.0;
        vc.xy_letfVC.view.alpha = 0.0;
        vc.xy_rightVC.view.alpha = 0.0;
    }completion:^(BOOL finished) {
        vc.black.hidden = YES;
        vc.view.userInteractionEnabled = YES;
        vc.changed = NO;
        vc.xy_rightVC.view.hidden = YES;
        vc.xy_letfVC.view.hidden = YES;
    }];
}



- (BOOL)shouldAutorotate{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
