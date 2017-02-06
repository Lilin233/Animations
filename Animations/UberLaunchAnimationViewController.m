//
//  UberLaunchAnimationViewController.m
//  Animations
//
//  Created by Liu Kai on 2017/1/17.
//  Copyright © 2017年 CocoaThinking. All rights reserved.
//

#import "UberLaunchAnimationViewController.h"
#import "TileGridView.h"
#import "UberLoginView.h"
@interface UberLaunchAnimationViewController ()

@end

@implementation UberLaunchAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    TileGridView *tileGridView = [[TileGridView alloc]initWithTileFileName:@"Chimes"];
    tileGridView.frame = self.view.bounds;
    [self.view addSubview:tileGridView];
    
    [tileGridView startAnimating];

    
    UberLoginView *logView = [[UberLoginView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
    [logView startAnimating];
    logView.layer.position = self.view.layer.position;
    [self.view addSubview:logView];
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
