# JFFoldingLabel

JFFoldingLabel可以按照客户端设置的行数来折叠文本，以及通过交互的方式来展开和重新折叠，客户端只需使用约束确定Label的宽度即可完成最精简的配置，另外客户端也可以配置字体，行间距等。

## Requirements

 JFFoldingLabel可以运行在iOS8以上的系统，并且基于ARC编译
 
## Adding JFFoldingLabel to your project

### carthage

      1. Add MBProgressHUD to your Cartfile. e.g., github "hanz2Z/JFFoldingLabel" ~> 1.1.0
      2. Run carthage up

## Usage

   ```
    JFFoldingLabel *label = [JFFoldingLabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor redColor];
    [self.view addSubview:label];
    label.text = @"your text";
    //label.font = [UIFont systemFontOfSize:12];
    //label.lineSpacing = 12;
    //label.textColor = [UIColor whiteColor];
    //label.folded = YES;
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[view]-15-|"
                                            options:kNilOptions
                                            metrics:nil
                                              views:@{@"view":label}];
    [self.view addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-150-[view]"
                                                          options:kNilOptions
                                                          metrics:nil
                                                            views:@{@"view":label}];
    [self.view addConstraints:constraints];
   ```

## License

MIT

## ScreenShot

![折叠状态](https://i.loli.net/2019/11/04/a7qmKX2fRYvblns.png "折叠状态")

![展开状态](https://i.loli.net/2019/11/04/5PjrSu2Oxn9aEeF.png "展开状态")
