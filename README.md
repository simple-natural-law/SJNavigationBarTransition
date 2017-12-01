# 导航栏颜色、透明度渐变

## 前言

在开发过程中，经常会碰到控制器对应的导航栏的背景颜色不一致或者需要让导航栏背景透明的需求。在导航控制器push和pop视图控制器的过程中，直接修改导航栏背景色在视觉上会显得比较突兀。为了给用户更好的使用体验，就需要为导航栏的背景色和透明度变换添加一种合适的动画效果。

## UINavigationBar基础

### 概述

导航栏是`UINavigationBar`类的实例对象，是一个显示在窗口的顶部并包含用于在屏幕层次结构内进行导航的按钮的栅栏。导航栏最常用于导航控制器中，导航控制器对象创建、显示和管理导航栏，并使用导航控制器管理的视图控制器的相关属性来控制导航栏中显示的内容。

![图2-1](https://docs-assets.developer.apple.com/published/dde7452123/3abba22e-4aef-47dd-b4e2-a9965c424338.png)

使用导航控制器控制导航栏时，需要执行以下步骤：
- 在**Interface Builder**或代码中创建一个导航控制器。
- 使用`UINavigationController`对象的`navigationBar`属性配置导航栏的外观。
- 通过设置导航控制器堆栈中管理的每个视图控制器的`title`和`navigationItem`属性来控制导航栏的内容。

也可以单独使用导航栏，将导航栏添加到界面中时需要执行以下步骤：
- 设置自动布局规则来管理界面中导航栏的位置。
- 创建一个**root navigationItem**来提供初始标题。
- 配置委托对象来处理与导航栏的交互。
- 自定义导航栏的外观。
- 配置应用程序界面，以便用户在浏览分层屏幕时推入和弹出相关`navigationItem`。

### 导航栏和导航控制器配合使用

使用导航控制器来管理不同内容屏幕之间的导航时，导航控制器会自动创建导航栏，并在适当的时间推入和弹出`navigationItem`。

在视图控制器出栈和入栈时，导航控制器使用此视图控制器对象的`navigationItem`属性为其导航栏提供当前需要显示的内容。默认的`navigationItem`使用视图控制器的标题，但可以通过覆盖`UIViewController`子类的`navigationItem`属性来完全控制导航栏内容。

导航控制器会自动将其自身指定为其导航栏对象的委托对象，所以在使用导航控制器时，不要将导航栏的委托对象设置为自定义对象。

要访问与导航控制器关联的导航栏，请使用`UINavigationController`对象的`navigationBar`属性。

有关导航控制器的信息，可以参看[UINavigationController](https://developer.apple.com/documentation/uikit/uinavigationcontroller)。

### 添加内容到到单独使用的导航栏

在绝大多数场景中，导航栏都是作为导航控制器的一部分使用的。但是有些情况下可能需要单独使用导航栏来实现内容导航方法。单独使用导航栏时，需要为其提供内容。与其他类型的视图不同，不能直接将子视图添加到导航栏，而需要使用`navigationItem`来指定要显示的按钮或者自定义视图。`navigationItem`是`UINavigationItem`类的实例对象，其持有用于在导航栏的左侧、右侧和中心指定视图以及用于指定自定义提示字符串的属性，如图2-1所示。

导航栏管理着一个包含`UINavigationItem`对象的堆栈。堆栈主要用于支持导航控制器，可以使用它来实现我们自己的自定义导航界面。堆栈中最顶端的`navigationItem`是导航栏当前显示内容所属的`navigationItem`，使用其`pushNavigationItem:animated:`方法将新的`navigationItem`推入到堆栈中，使用`popNavigationItemAnimated:`方法从堆栈中弹出`navigationItem`。

除了推入和弹出`navigationItem`之外，还可以直接使用导航栏的`items`属性或者`setItems:animated:`方法设置堆栈的内容。可以在应用程序启动时使用此方法将界面恢复到上次关闭应用程序前的状态。下图显示了导航栏是如何管理`navigationItem`堆栈的：

![图2-2](https://docs-assets.developer.apple.com/published/dde7452123/536711f8-0b4b-4ecd-a086-3b8c6feb1a6c.png)

单独使用导航栏时，需要手动为导航栏配置委托对象，委托对象要遵循`UINavigationBarDelegate`协议。通过实现委托对象的委托方法，委托对象就能接收到导航栏发送的消息。这样就能跟踪何时推入`navigationItem`到堆栈中或者从堆栈中弹出`navigationItem`，并根据这些消息来更新应用程序的界面。

有关创建`navigationItem`的信息，可以参看[UINavigationItem](https://developer.apple.com/documentation/uikit/uinavigationitem)。有关委托对象的信息，可以参看[UINavigationBarDelegate](https://developer.apple.com/documentation/uikit/uinavigationbardelegate)。

### 自定义导航栏外观

导航栏有两种标准的外观样式：黑色文字配白色背景或者白色文字配黑色背景。使用其`barStyle`属性来配置外观样式。对导航栏外观样式`barStyle`属性的更改，会覆盖导航栏从其他与外观有关的属性推断出的显示内容。

导航栏默认是半透明的，可以通过将其`translucent`属性值设为`NO`来使导航栏不透明。

可以使用`barTintColor`属性来设置导航栏背景色，设置此属性会覆盖从`barStyle`属性推断出的默认颜色。与所有`UIView`子类一样，可以使用`tintColor`属性来控制导航栏上控件内容的颜色，包括按钮图片和按钮文字。

`titleTextAttributes`属性用来指定标题文本外观的，可以分别使用`NSFontAttributeName`、`NSForegroundColorAttributeName`和`NSShadowAttributeName`键为标题文本指定字体、文本颜色、文本阴影颜色和文本阴影偏移量。




## Demo

示例代码下载地址：https://github.com/zhangshijian/UINavigationBarDemo
