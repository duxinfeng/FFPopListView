//
//  ViewController.m
//  FFPopListViewDemo
//
//  Created by HD on 17/4/15.
//  Copyright © 2017年 http://duxinfeng.com. All rights reserved.
//

#import "ViewController.h"
#import "FFPopListView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"show" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 200, self.view.frame.size.width, 100);
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick:(id)sender
{
    NSArray *array = @[@"学龄前",@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级"];
    FFPopListView *popListView = [[FFPopListView alloc] initWithTitle:@"选择年级" dataSource:array selectedText:@"三年级" didSelectBlock:^(FFPopListView *popListView,NSIndexPath *indexPath) {
        NSLog(@"-->%@",array[indexPath.row]);
    }];
    [popListView show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
