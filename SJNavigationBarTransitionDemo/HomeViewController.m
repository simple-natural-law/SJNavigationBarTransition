//
//  HomeViewController.m
//  SJNavigationBarTransition
//
//  Created by 如约科技 on 2017/9/27.
//  Copyright © 2017年 如约科技. All rights reserved.
//

#import "HomeViewController.h"
#import "SJNavigationBarTransition.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"SJNavigationBarTransitionDemo";
    
    self.dataArray = @[@{@"title":@"跳转到导航栏透明的页面", @"target":@"TransparentBarViewController"}, @{@"title":@"跳转到导航栏颜色或者图片不同的页面", @"target":@"TestViewController"}, @{@"title":@"跳转到导航栏颜色或者背片相同的页面", @"target":@"SameAppearanceViewController"}];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarBackgroundColor:[UIColor orangeColor]];
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
