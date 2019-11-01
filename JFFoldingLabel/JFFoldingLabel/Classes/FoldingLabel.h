//
//  JFFoldingLabel.h
//  JFFoldingLabel
//
//  Created by zhaoyan on 2019/10/30.
//  Copyright © 2019 zhaoyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFFoldingLabel : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) NSUInteger numberOfLinesWhenFolded;

@property (nonatomic, assign) BOOL folded;

@property (nonatomic, copy) NSString *foldText;
@property (nonatomic, copy) NSString *unfoldText;

@end

NS_ASSUME_NONNULL_END
