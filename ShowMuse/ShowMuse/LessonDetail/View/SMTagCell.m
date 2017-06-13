//
//  SMTagCell.m
//  ShowMuse
//
//  Created by ygliu on 9/14/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMTagCell.h"
#import "Masonry.h"
#import "SMRelatedCourse.h"
#import "SMRelatedMaterial.h"
#import "SMTagButton.h"

@interface SMTagCell ()

@property (nonatomic,weak) UILabel *tagNameLabel;

@property (nonatomic,weak) UIView *sepLine;

@property (nonatomic,weak) SMTagButton *tagButton;

@property (strong, nonatomic) NSMutableArray *tagButtonsArr;

@property (strong, nonatomic) NSMutableArray *materialBtnsArr;


@end

@implementation SMTagCell

#pragma mark - getter
- (NSMutableArray *)tagButtonsArr
{
    if (!_tagButtonsArr) {
        _tagButtonsArr = [NSMutableArray array];
    }
    return _tagButtonsArr;
}

- (NSMutableArray *)materialBtnsArr
{
    if (!_materialBtnsArr) {
        _materialBtnsArr = [NSMutableArray array];
    }
    return _materialBtnsArr;
}

#pragma mark - setter
- (void)setRelatedTagsArr:(NSMutableArray *)relatedTagsArr
{
    _relatedTagsArr = relatedTagsArr;
    
    self.tagNameLabel.text = NSLocalizedString(@"LESSONS_DETAILS_PAGE_TAG", nil);
    // layout tags
    [self addtagButtonsWithArray:relatedTagsArr];
}

- (void)setRelatedMaterialArr:(NSMutableArray *)relatedMaterialArr
{
    _relatedMaterialArr = relatedMaterialArr;
    
    self.tagNameLabel.text = NSLocalizedString(@"LESSONS_DETAILS_PAGE_MATERIAL", nil);
    [self addMaterialButtonsWithArray:relatedMaterialArr];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addChildWidgets];
        self.contentView.backgroundColor = colorWithRGB(238, 241, 243);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)addChildWidgets
{
    UILabel *tagNameLabel = [[UILabel alloc] init];
    tagNameLabel.font = [UIFont systemFontOfSize:16];
    tagNameLabel.textColor = colorWithRGB(82, 82, 82);
    [self.contentView addSubview:tagNameLabel];
    self.tagNameLabel = tagNameLabel;
    [self.tagNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-15);
        make.height.equalTo(@(20));
    }];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:sepLine];
    self.sepLine = sepLine;
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@(1));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)addtagButtonsWithArray:(NSArray *)buttonArr
{
    for (NSInteger i = 0; i < buttonArr.count; i++) {
        SMRelatedCourse *relatedTag = buttonArr[i];
        SMTagButton *tagBtn = [SMTagButton buttonWithType:UIButtonTypeCustom];
        tagBtn.tag = i;
        [tagBtn setTitle:relatedTag.title forState:UIControlStateNormal];
        [tagBtn addTarget:self action:@selector(tagButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
//        [tagBtn sizeToFit];
        tagBtn.layer.cornerRadius = tagBtn.frame.size.height * 0.5;
        tagBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:tagBtn];
        [self.tagButtonsArr addObject:tagBtn];
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.lessThanOrEqualTo(@(SMScreenWidth - 30));
        }];
        //layout
        if (i == 0) {
            [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.tagNameLabel.mas_bottom).offset(10);
                make.left.equalTo(self.mas_left).offset(15);
            }];
        } else {
            SMTagButton *preTag = self.tagButtonsArr[i - 1];
            CGFloat leftDistance = SMScreenWidth - CGRectGetMaxX(preTag.frame) - kTagButtonMargin - 15;
            if (leftDistance > tagBtn.frame.size.width) { // current line
                [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(preTag.mas_top);
                    make.left.equalTo(preTag.mas_right).offset(kTagButtonMargin);
                }];
            } else { // next line
                [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(preTag.mas_bottom).offset(kTagButtonMargin);
                    make.left.equalTo(self.mas_left).offset(15);
                }];
            }
        }
        [self layoutIfNeeded];
    }
    SMTagButton *lastBtn = [self.tagButtonsArr lastObject];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sepLine.mas_top).offset(-15);
    }];
    
}

- (void)addMaterialButtonsWithArray:(NSArray *)materialArr
{
    for (NSInteger i = 0; i < materialArr.count; i++) {
        SMRelatedMaterial *material = materialArr[i];
        SMTagButton *materialBtn = [SMTagButton buttonWithType:UIButtonTypeCustom];
        materialBtn.tag = i;
        NSAttributedString *attrStrTitle = [[NSAttributedString alloc] initWithString:material.title attributes:@{NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName : colorWithRGB(67, 218, 217)}];
        [materialBtn setAttributedTitle:attrStrTitle forState:UIControlStateNormal];
        [materialBtn addTarget:self action:@selector(materialButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [materialBtn sizeToFit];
        materialBtn.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:materialBtn];
        [self.materialBtnsArr addObject:materialBtn];
        [materialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_lessThanOrEqualTo(SMScreenWidth - 30);
        }];
        
        if (i == 0) {
            [materialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.tagNameLabel.mas_bottom).offset(10);
                make.left.equalTo(self.mas_left).offset(15);
            }];
        } else {
            SMTagButton *preMaterialBtn = self.materialBtnsArr[i - 1];
            CGFloat leftDistance = SMScreenWidth - CGRectGetMaxX(preMaterialBtn.frame) - kTagButtonMargin - 15;
            if (leftDistance > materialBtn.frame.size.width) { // current line
                [materialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(preMaterialBtn.mas_top);
                    make.left.equalTo(preMaterialBtn.mas_right).offset(kTagButtonMargin);
                }];
            } else { // next line
                [materialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(preMaterialBtn.mas_bottom).offset(kTagButtonMargin);
                    make.left.equalTo(self.mas_left).offset(15);
                }];
            }
        }
        [self layoutIfNeeded];
    }
    SMTagButton *lastBtn = [self.materialBtnsArr lastObject];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.sepLine.mas_top).offset(-15);
    }];
}


- (void)tagButtonDidClick:(SMTagButton *)button
{
    if (self.tagBlock) {
        self.tagBlock(button);
    }
}

- (void)materialButtonDidClick:(SMTagButton *)button
{
    if (self.materialBlock) {
        self.materialBlock(button);
    }
    
}

@end
