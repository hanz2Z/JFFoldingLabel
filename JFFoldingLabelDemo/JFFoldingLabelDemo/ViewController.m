//
//  ViewController.m
//  JFFoldingLabelDemo
//
//  Created by zhaoyan on 2019/11/1.
//  Copyright © 2019 zhaoyan. All rights reserved.
//

#import "ViewController.h"
#import <JFFoldingLabel/JFFoldingLabel.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView
{
    JFFoldingLabel *label = [JFFoldingLabel new];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:label];
    label.text = @"需要注意的是，在drawRect方法中进行绘制的时候，我们只是用空位的NSMutableAttributedString占在图片的位置，当绘制完成过后，在找到的图片的位置添加一个UIImageView，需要的话并添加点击事件。图片看作一个单独的NSMutableAttributedString，所以图片前后也分别是不同的NSMutableAttributedString，最后将NSMutableAttributedString拼接起来的，并不能将图片插入到一个NSMutableAttributedString中间（我目前没有想到方法）。所以需要在一个字符串中添加多张图片，就要看成多个图片NSMutableAttributedString，和被图片分割的多个不同的字符串NSMutableAttributedString，然后按顺序拼接。和被图片分割的多个不同的字符串";
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
}

@end
