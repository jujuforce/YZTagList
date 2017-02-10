//
//  YZTagList.m
//  Hobby
//
//  Created by yz on 16/8/14.
//  Copyright © 2016年 yz. All rights reserved.
//

#import "YZTagList.h"
#import "YZTagButton.h"

CGFloat const imageViewWH = 20;

@interface YZTagList ()
@property (nonatomic, weak) UICollectionView *tagListView;
@property (nonatomic, strong) NSMutableDictionary *tags;
@property (nonatomic, strong) NSMutableArray *tagButtons;
@end

@implementation YZTagList

- (NSMutableArray *)tagButtons
{
    if (_tagButtons == nil)
    {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (NSMutableDictionary *)tags
{
    if (_tags == nil)
    {
        _tags = [NSMutableDictionary dictionary];
    }
    return _tags;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setup];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setup];
    }
    return self;
}

#pragma mark - 初始化
- (void)setup
{
    _tagMargin = 10;
    _tagColor = [UIColor redColor];
    _tagButtonMargin = 5;
    _tagCornerRadius = 5;
    _borderWidth = 0;
    _borderColor = _tagColor;
    _tagFont = [UIFont systemFontOfSize:13];
    _tagAllowDelete = YES;
    self.clipsToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _tagListView.frame = self.bounds;
}

- (CGFloat)tagListH
{
    return CGRectGetMaxY([self.tagButtons.lastObject frame]) + _tagMargin;
}

- (CGFloat)tagListW
{
    return [self.tagButtons.lastObject frame].origin.x + [self.tagButtons.lastObject frame].size.width + _tagButtonMargin;
}

#pragma mark - 操作标签方法
- (void)addTags:(NSArray *)tagStrs
{
    for (NSString *tagStr in tagStrs)
    {
        [self addTag:tagStr];
    }
}
- (void)addTag:(YZTag *)tag
{
    YZTagButton *tagButton = [YZTagButton buttonWithType:UIButtonTypeCustom];
    tagButton.margin = _tagButtonMargin;
    tagButton.layer.cornerRadius = _tagCornerRadius;
    tagButton.layer.borderWidth = _borderWidth;
    tagButton.layer.borderColor = _borderColor.CGColor;
    tagButton.clipsToBounds = YES;
    tagButton.tag = self.tagButtons.count;
    [tagButton setImage:_tagDeleteimage forState:UIControlStateNormal];
    [tagButton setTitle:tag.text forState:UIControlStateNormal];
    [tagButton setTitleColor:_tagColor forState:UIControlStateNormal];
    [tagButton setBackgroundColor:tag.color != nil ? tag.color : _tagBackgroundColor];
    [tagButton setBackgroundImage:_tagBackgroundImage forState:UIControlStateNormal];
    tagButton.titleLabel.font = _tagFont;
    [tagButton addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tagButton];

    [self.tagButtons addObject:tagButton];

    [self.tags setObject:tagButton forKey:tag.text];

    [self updateTagButtonFrame:tagButton.tag extreMargin:YES];

    CGRect frame = self.frame;
    frame.size.height = self.tagListH;
    [UIView animateWithDuration:0.25
                     animations:^{
                       self.frame = frame;
                     }];
}

- (void)clickTag:(UIButton *)button
{
    if (_tagAllowDelete == YES)
    {
        [self deleteTag:button.currentTitle];
    }
}

- (void)deleteTag:(NSString *)tagStr
{
    YZTagButton *button = self.tags[tagStr];

    [button removeFromSuperview];

    [self.tagButtons removeObject:button];

    [self.tags removeObjectForKey:tagStr];

    [self updateTag];

    [UIView animateWithDuration:0.25
                     animations:^{
                       [self updateLaterTagButtonFrame:button.tag];
                     }];

    CGRect frame = self.frame;
    frame.size.height = self.tagListH;
    [UIView animateWithDuration:0.25
                     animations:^{
                       self.frame = frame;
                     }];

    if ([self.delegate respondsToSelector:@selector(deletedTagFromTagList:title:)])
    {
        [self.delegate deletedTagFromTagList:self title:button.titleLabel.text];
    }
}

- (void)deleteAllTags
{
    for (YZTagButton *currentButton in self.tags.allValues)
    {
        [currentButton removeFromSuperview];
    }
    [self.tagButtons removeAllObjects];
    [self.tags removeAllObjects];
    [self updateTag];
}

- (void)updateTag
{
    NSInteger count = self.tagButtons.count;
    for (int i = 0; i < count; i++)
    {
        UIButton *tagButton = self.tagButtons[i];
        tagButton.tag = i;
    }
}

- (void)updateLaterTagButtonFrame:(NSInteger)laterI
{
    NSInteger count = self.tagButtons.count;
    for (NSInteger i = laterI; i < count; i++)
    {
        [self updateTagButtonFrame:i extreMargin:NO];
    }
}

- (void)updateTagButtonFrame:(NSInteger)i extreMargin:(BOOL)extreMargin
{
    NSInteger preI = i - 1;

    UIButton *preButton;

    if (preI >= 0)
    {
        preButton = self.tagButtons[preI];
    }

    YZTagButton *tagButton = self.tagButtons[i];

    CGFloat btnX = CGRectGetMaxX(preButton.frame) + _tagMargin;
    CGFloat btnY = preButton ? preButton.frame.origin.y : _tagMargin;

    CGFloat titleW = [tagButton.titleLabel.text sizeWithFont:_tagFont].width;
    CGFloat titleH = [tagButton.titleLabel.text sizeWithFont:_tagFont].height;
    CGFloat btnW = extreMargin ? titleW + 2 * _tagButtonMargin : tagButton.bounds.size.width;
    if (_tagDeleteimage && extreMargin == YES)
    {
        btnW += imageViewWH;
        btnW += _tagButtonMargin;
    }

    CGFloat btnH = extreMargin ? titleH + 2 * _tagButtonMargin : tagButton.bounds.size.height;
    if (_tagDeleteimage && extreMargin == YES)
    {
        CGFloat height = imageViewWH > titleH ? imageViewWH : titleH;
        btnH = height + 2 * _tagButtonMargin;
    }

    CGFloat rightWidth = self.bounds.size.width - btnX;

    if (rightWidth < btnW && self.oneLineMode == false)
    {
        btnX = _tagMargin;
        btnY = CGRectGetMaxY(preButton.frame) + _tagMargin;
    }

    tagButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
}

@end
