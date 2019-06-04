//
//  ViewController.m
//  PopoverViewDemo
//
//  Created by 高莹莹 on 2019/6/3.
//  Copyright © 2019 高莹莹. All rights reserved.
//

#import "ViewController.h"
#import "AGPopoverView.h"
#import "AGPopoverCellModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btnLeftUp = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeftUp.frame = CGRectMake(0, 100, 100, 100);
    btnLeftUp.backgroundColor = [UIColor redColor];
    [btnLeftUp addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnLeftUp];
    
    UIButton *btnMiddletUp = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMiddletUp.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, 100, 100, 100);
    btnMiddletUp.backgroundColor = [UIColor redColor];
    [btnMiddletUp addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnMiddletUp];
    
    
    UIButton *btnLeftDown = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeftDown.frame = CGRectMake(0, 500, 100, 100);
    btnLeftDown.backgroundColor = [UIColor redColor];
    [btnLeftDown addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnLeftDown];
    
    
    UIButton *btnRightUp = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightUp.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 100, 100, 100);
    btnRightUp.backgroundColor = [UIColor redColor];
    [btnRightUp addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnRightUp];
    
    UIButton *btnMiddletDown = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMiddletDown.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, 500, 100, 100);
    btnMiddletDown.backgroundColor = [UIColor redColor];
    [btnMiddletDown addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnMiddletDown];
    
    UIButton *btnRightDown = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRightDown.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 500, 100, 100);
    btnRightDown.backgroundColor = [UIColor redColor];
    [btnRightDown addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnRightDown];
    
}

- (void)tapAction:(UIButton *)sender
{
    NSArray *images = @[
                        @"icon_bgxq",@"icon_pb"
                        ];
    NSArray *titles = @[
                        @"不感兴趣",@"屏蔽"
                        ];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0 ; i < titles.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        if (i == 1) {
            NSArray *subtitles = @[
                                @"屏蔽",@"屏蔽:XXXXXX",@"屏蔽:XXXXXX",@"屏蔽:XXXXXX"
                                ];
            for (int i= 0; i < 4; i ++) {
                
                AGPopoverCellModel *submodel = [AGPopoverCellModel modelWithImage:nil title:subtitles[i] dataArr:nil];
                if (i==0) {
                    submodel.isBack = YES;
                }else{
                    submodel.isBack = NO;
                }
                [arr addObject:submodel];
            }
            AGPopoverCellModel *model = [AGPopoverCellModel modelWithImage:images[i] title:titles[i] dataArr:arr];
            [array addObject:model];
        }else{
            AGPopoverCellModel *model = [AGPopoverCellModel modelWithImage:images[i] title:titles[i] dataArr:nil];
            [array addObject:model];
        }
    }
    AGPopoverView *pop = [AGPopoverView popoverViewWithAttachmentView:sender withModelsArr:array];
    //    pop.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    pop.showAnimation = YES;
    [pop show];
    // Do any additional setup after loading the view.
}

-(void)transmitEvent:(id)info withIdfi:(NSString *)idfi
{
    NSLog(@"%@",self.class);
//    [self backAction];
}
@end
