//
//  JFFoldingLabel.m
//  JFFoldingLabel
//
//  Created by zhaoyan on 2019/10/30.
//  Copyright © 2019 zhaoyan. All rights reserved.
//

#import "FoldingLabel.h"
#import <CoreText/CoreText.h>

@interface JFFoldingLabel ()

@property (nonatomic, assign) CTFramesetterRef textFrameSetter;
@property (nonatomic, assign) CTFrameRef textFrame;

@property (nonatomic, assign) CGFloat viewWidth;

@property (nonatomic, assign) BOOL canBeFolded;

@property (nonatomic, assign) BOOL needsRecreatFrameSetter;
@property (nonatomic, assign) BOOL needUpdateButtons;

@property (nonatomic, assign) CGSize lastFrameSize;

@property (nonatomic, assign) BOOL foldButtonOnSeparatorLine;

@property (nonatomic, strong) UILabel *foldButton;
@property (nonatomic, strong) UILabel *unfoldButton;

@end

@implementation JFFoldingLabel

- (id)init
{
    if (self = [super init]) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupDefaultValues];
    }
    return self;
}

- (void)setupDefaultValues
{
    self.textColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:10];
    self.lineSpacing = 5;
    self.numberOfLinesWhenFolded = 3;
    self.foldText = @"收起";
    self.unfoldText = @"更多";
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    
    [self setNeedsLayout];
    
    _needsRecreatFrameSetter = YES;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    
    [self setNeedsLayout];

    _needsRecreatFrameSetter = YES;
    
    _needUpdateButtons = YES;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    [self setNeedsLayout];

    _needsRecreatFrameSetter = YES;
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    _lineSpacing = lineSpacing;
    
    [self setNeedsLayout];

    _needsRecreatFrameSetter = YES;
}

- (void)setNumberOfLinesWhenFolded:(NSUInteger)numberOfLinesWhenFolded
{
    _numberOfLinesWhenFolded = numberOfLinesWhenFolded;
    
    [self setNeedsLayout];
}

- (void)setFolded:(BOOL)folded
{
    _folded = folded;
    
    [self setNeedsLayout];
}

- (void)setFoldText:(NSString *)foldText
{
    _foldText = [foldText copy];
    
    _needUpdateButtons = YES;
}

- (void)setUnfoldText:(NSString *)unfoldText
{
    _unfoldText = [unfoldText copy];
    
    _needUpdateButtons = YES;
}

- (UILabel *)foldButton
{
    if (!_foldButton) {
        UILabel *button = [UILabel new];
        button.userInteractionEnabled = YES;

        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.textColor = [UIColor blueColor];
        _foldButton = button;
        
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foldTapped:)];
        [button addGestureRecognizer:rec];
        
        //[button addTarget:self action:@selector(foldTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return _foldButton;
}

- (void)updateFoldButton
{
    self.foldButton.text = self.foldText;
    self.foldButton.font = self.font;
    
    CGSize size = [self.foldText sizeWithAttributes:@{
                                          NSFontAttributeName:self.font
                                          }];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    self.foldButton.frame = frame;
}

- (UILabel *)unfoldButton
{
    if (!_unfoldButton) {
        UILabel *button = [UILabel new];
        button.userInteractionEnabled = YES;
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        button.textColor = [UIColor blueColor];
        
        _unfoldButton = button;
        
        UITapGestureRecognizer *rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unfoldTapped:)];
        [button addGestureRecognizer:rec];
        
        //[button addTarget:self action:@selector(unfoldTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    return _unfoldButton;
}

- (void)updateUnfoldButton
{
    self.unfoldButton.text = self.foldText;
    self.unfoldButton.font = self.font;
    
    CGSize size = [self.unfoldText sizeWithAttributes:@{
                                          NSFontAttributeName:self.font
                                          }];
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    self.unfoldButton.frame = frame;
}

- (void)recreateTextFrameSetter
{
    if (self.textFrameSetter) {
        CFRelease(self.textFrameSetter);
        self.textFrameSetter = NULL;
    }
    
    self.textFrameSetter = [self createFrameSetter];
    
    _needsRecreatFrameSetter = NO;
}

- (CTFramesetterRef)createFrameSetter
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = self.lineSpacing;
    style.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text attributes:@{
                                                                                                    NSForegroundColorAttributeName:self.textColor,
                                                                                                    NSFontAttributeName:self.font,
                                                                                                    NSParagraphStyleAttributeName:style
                                                                                                    }];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrStr);
    
    return frameSetter;
}

- (void)recreateTextFrame:(CGSize)size
{
    if (self.textFrame) {
        CFRelease(self.textFrame);
        self.textFrame = NULL;
    }
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    CTFrameRef frameRef = CTFramesetterCreateFrame(self.textFrameSetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
    
    self.textFrame = frameRef;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = CGSizeZero;
    CGSize textFullSize = CGSizeZero;
    
    if (self.needUpdateButtons) {
        [self updateFoldButton];
        
        [self updateUnfoldButton];
        
        _needUpdateButtons = NO;
    }
    
    if (self.viewWidth == 0) {
        textFullSize = CTFramesetterSuggestFrameSizeWithConstraints(self.textFrameSetter,
                                                     CFRangeMake(0, self.text.length),
                                                     NULL,
                                                     CGSizeMake(CGFLOAT_MAX, 1024), NULL);
        
        size = textFullSize;
    }
    else {
        textFullSize = CTFramesetterSuggestFrameSizeWithConstraints(self.textFrameSetter,
                                                     CFRangeMake(0, self.text.length),
                                                     NULL,
                                                     CGSizeMake(self.viewWidth, 1024), NULL);
        
        CGFloat lineSpacing = (self.numberOfLinesWhenFolded - 1) * self.lineSpacing;
        CGFloat foldingHeight = (self.font.ascender - self.font.descender + 1) * self.numberOfLinesWhenFolded + lineSpacing;
        
        if (textFullSize.height > foldingHeight) {
            self.canBeFolded = YES;
            
            if (self.folded) {
                size = CGSizeMake(self.viewWidth, foldingHeight);
                
                self.unfoldButton.hidden = NO;
                self.foldButton.hidden = YES;
            }
            else {
                size = textFullSize;
                
                UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
                CTFrameRef frameRef = CTFramesetterCreateFrame(self.textFrameSetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
                
                CFArrayRef rows = CTFrameGetLines(frameRef);
                CFIndex numberOfLines = CFArrayGetCount(rows);
                
                CTLineRef line = CFArrayGetValueAtIndex(rows, numberOfLines-1);
                
                CGFloat width = CTLineGetTypographicBounds(line, NULL, NULL, NULL);
                
                CFRelease(frameRef);

                if ((width + self.foldButton.frame.size.width + 5) > size.width) {
                    // 需要单独一行
                    size.height += self.lineSpacing;
                    size.height += self.foldButton.frame.size.height;
                    
                    self.foldButtonOnSeparatorLine = YES;
                }
                else {
                    self.foldButtonOnSeparatorLine = NO;
                }
                
                self.unfoldButton.hidden = YES;
                self.foldButton.hidden = NO;
            }
        }
        else {
            self.unfoldButton.hidden = YES;
            self.foldButton.hidden = YES;
            
            self.canBeFolded = NO;
            
            size = textFullSize;
        }
    }
    
    return size;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    BOOL needRecreateSetter = self.needsRecreatFrameSetter;
    if (needRecreateSetter) {
        [self recreateTextFrameSetter];
    }
    
    self.viewWidth = CGRectGetWidth(self.bounds);
    
    CGSize size = [self intrinsicContentSize];
    
    BOOL differentSize = !CGSizeEqualToSize(size, self.lastFrameSize);
    
    if (differentSize) {
        self.lastFrameSize = size;
        
        [self invalidateIntrinsicContentSize];
    }
    
    if (differentSize || needRecreateSetter) {
        [self recreateTextFrame:size];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.textFrame) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CTFrameRef frameRef = self.textFrame;
        
        CFArrayRef rows = CTFrameGetLines(frameRef);
        CFIndex numberOfLines = CFArrayGetCount(rows);
        
        CGPoint pointList[numberOfLines];
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), pointList);
        
        for (CFIndex i = 0; i < numberOfLines; ++i) {
            CTLineRef line = CFArrayGetValueAtIndex(rows, i);
            CGPoint p = pointList[i];
            
            CGContextSetTextPosition(context, p.x, p.y);

            if (i < (self.numberOfLinesWhenFolded - 1)) {
                CTLineDraw(line, context);
            }
            else {
                if (self.canBeFolded) {
                    if (self.folded) {
                        CGFloat width = CTLineGetTypographicBounds(line, NULL, NULL, NULL);
                        if ((width + self.unfoldButton.frame.size.width + 5) > self.frame.size.width) {
                            CFRange lineRange = CTLineGetStringRange(line);
                            NSInteger length = lineRange.length-4;
                            if (length < 0) {
                                length = 0;
                            }
                            NSString *subStr = [self.text substringWithRange:NSMakeRange(lineRange.location, length)];
                            subStr = [subStr stringByAppendingString:@"..."];
                            
                            NSAttributedString *subAttrStr = [[NSAttributedString alloc] initWithString:subStr attributes:@{
                                                                                                                            NSForegroundColorAttributeName:self.textColor,
                                                                                                                            NSFontAttributeName:self.font}];
                            CTLineRef newLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef) subAttrStr);
                            
                            CTLineDraw(newLine, context);
                            
                            CFRelease(newLine);
                        }
                        else {
                            CTLineDraw(line, context);
                        }
                        
                        CGSize size = self.unfoldButton.frame.size;
                        self.unfoldButton.frame = CGRectMake(self.frame.size.width - size.width - 5,
                                                             self.frame.size.height - size.height + self.font.descender,
                                                             size.width,
                                                             size.height);
                    }
                    else {
                        CTLineDraw(line, context);
                        
                        if (!self.foldButtonOnSeparatorLine) {
                            CGSize size = self.foldButton.frame.size;
                            self.foldButton.frame = CGRectMake(self.frame.size.width - size.width - 5,
                                                                 self.frame.size.height - size.height + self.font.descender,
                                                                 size.width,
                                                                 size.height);
                        }
                    }
                }
                else {
                    CTLineDraw(line, context);
                }
            }
        }
        
        if (self.canBeFolded && !self.folded && self.foldButtonOnSeparatorLine) {
            CGSize size = self.foldButton.frame.size;
            self.foldButton.frame = CGRectMake(0,
                                               self.frame.size.height - size.height + self.font.descender,
                                               size.width,
                                               size.height);
        }
    }
}

- (void)foldTapped:(id)sender
{
    self.folded = YES;
}

- (void)unfoldTapped:(id)sender
{
    self.folded = NO;
}

@end
