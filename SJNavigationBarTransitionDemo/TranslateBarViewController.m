//
//  TranslateBarViewController.m
//  SJNavigationBarTransition
//
//  Created by 张诗健 on 2017/9/29.
//  Copyright © 2017年 张诗健. All rights reserved.
//

#import "TranslateBarViewController.h"
#import "SJNavigationBarTransition.h"


@interface TranslateBarViewController ()<UITableViewDelegate,UITableViewDataSource>

@end


@implementation TranslateBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( (arc4random()%256) % 2 == 0)
    {
        [self.navigationController setNavigationBarBackgroundColor:[UIColor lightGrayColor]];
    }
}


#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}


#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > 0)
    {
        if (offsetY >= self.navigationController.navigationBar.subviews.firstObject.frame.size.height)
        {
            [self.navigationController setNavigationBarTranslationY:-self.navigationController.navigationBar.subviews.firstObject.frame.size.height];
        }else
        {
            [self.navigationController setNavigationBarTranslationY:-offsetY];
        }
    }else
    {
        [self.navigationController setNavigationBarTranslationY:0.0];
    }
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
