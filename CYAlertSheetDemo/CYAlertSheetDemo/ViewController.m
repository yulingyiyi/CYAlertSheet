//
//  ViewController.m
//  CYAlertSheetDemo
//
//  Created by SX on 2017/5/31.
//  Copyright © 2017年 YULING. All rights reserved.
//

#import "ViewController.h"
#import "CYAlertSheet.h"
@interface ViewController ()<CYAlertSheetDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)click:(UIButton *)sender {
    
    
    [ CYAlertSheet showAlertSheet:@"请选择" action:@[@"11",@"2",@"3",@"4"] cancel:@"cancel" delagate:self];
}

- (void)actionClickByIndex:(NSInteger)index alertSheet:(CYAlertSheet *)alertSheet
{
     NSLog(@"___%@", @(index));
    
}

@end
