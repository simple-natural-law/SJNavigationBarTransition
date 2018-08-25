

# SJNavigationBarTransition

## 功能

- 导航栏背景颜色和背景图片切换时，添加转场动画。
- 设置导航栏透明度。
- 在垂直方向上移动导航栏。

![Demo演示](https://github.com/zhangshijian/SJNavigationBarTransition/raw/master/GIF/Demo.gif)

## 如何使用

将`SJNavigationBarTransition`文件夹放到项目中，并导入头文件`SJNavigationBarTransitio.h`。

设置导航栏背景颜色：
```
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 第一种
    [self.navigationController setNavigationBarBackgroundColor:[UIColor whiteColor]];
    
    // 第二种
    [self.navigationController setNavigationBarBackgroundColor:[UIColor whiteColor] backgroundAlpha:0.5];
}
```

设置导航栏背景图片：
```
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 第一种
    [self.navigationController setNavigationBarBackgroundImage:[UIImage imageNamed:@"bar"]];
    
    // 第二种
    [self.navigationController setNavigationBarBackgroundImage:[UIImage imageNamed:@"bar"] backgroundAlpha:0.5];
}
```

实时更新导航栏透明度：
```
[self.navigationController updateNavigationBarBackgroundAlpha:0.5];
```

设置导航栏在垂直方向上的位移：
```
[self.navigationController setNavigationBarTranslationY:44.0];
```
