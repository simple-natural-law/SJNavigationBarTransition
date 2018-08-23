//
//  HomeViewController.m
//  UINavigationBarDemo
//
//  Created by 讯心科技 on 2017/9/27.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "HomeViewController.h"


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"UINavigationBarDemo";
    
    self.dataArray = @[@{@"title":@"NavigationBar外观属性设置", @"target":@"BarAppearanceViewController"},
                       @{@"title":@"控制器对应的NavigationItem设置", @"target":@"BarItemSettingViewController"},
                       @{@"title":@"页面跳转时NavigationBar渐变效果", @"target":@"GradientBarViewController"}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:self.dataArray[indexPath.row][@"target"]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
