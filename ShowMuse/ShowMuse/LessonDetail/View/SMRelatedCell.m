//
//  SMRelatedCell.m
//  ShowMuse
//
//  Created by ygliu on 9/14/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMRelatedCell.h"
#import "Masonry.h"
#import "SMRelatedLessonCell.h"
@interface SMRelatedCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionView;

@property (weak, nonatomic) UILabel *comentLabel;
@end

@implementation SMRelatedCell

#pragma mark - setter
- (void)setCommentCount:(NSInteger)commentCount
{
    _commentCount = commentCount;
    self.comentLabel.text = [NSString stringWithFormat:@"%@(%zd)", NSLocalizedString(@"LESSONS_DETAILS_PAGE_COMMENTS", nil), commentCount == 0 ? 0 : commentCount];
}

- (void)setSugLessonsArr:(NSMutableArray *)sugLessonsArr
{
    _sugLessonsArr = sugLessonsArr;
    
    [self.collectionView reloadData];
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
    UILabel *relatedLabel = [[UILabel alloc] init];
//    relatedLabel.backgroundColor = [UIColor randomColor];
    relatedLabel.font = [UIFont systemFontOfSize:16];
    relatedLabel.textColor = colorWithRGB(82, 82, 82);
    relatedLabel.text = NSLocalizedString(@"LESSONS_DETAILS_PAGE_RECOMMENDED_VIDEOS", nil);
    [self.contentView addSubview:relatedLabel];
    
    UICollectionViewFlowLayout *waterLayout = [[UICollectionViewFlowLayout alloc] init];
    waterLayout.itemSize = CGSizeMake(150, 125);
    waterLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:waterLayout];
    collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView = collectionView;
    collectionView.backgroundColor = colorWithRGB(238, 241, 243);
    [self.contentView addSubview:collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[SMRelatedLessonCell class] forCellWithReuseIdentifier:@"relatedLesson"];
    
    UIView *sepLine = [[UIView alloc] init];
    sepLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.contentView addSubview:sepLine];
    
    UILabel *comentLabel = [[UILabel alloc] init];
    comentLabel.textColor = colorWithRGB(82, 82, 82);
    comentLabel.font = [UIFont systemFontOfSize:16];
    self.comentLabel = comentLabel;
    [self.contentView addSubview:comentLabel];
    
    [relatedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.equalTo(@(20));
        make.width.equalTo(@(320));
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(50);
        make.left.mas_equalTo(self.contentView.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(@(140));
    }];
    
    [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(collectionView.mas_bottom);
        make.left.mas_equalTo(relatedLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(1));
    }];
    
    [comentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(sepLine.mas_bottom).offset(20);
        make.left.mas_equalTo(sepLine.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(@(20));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sugLessonsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMRelatedLessonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"relatedLesson" forIndexPath:indexPath];
    cell.sugLesson = self.sugLessonsArr[indexPath.row];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(relatedCellDidClick:)]) {
        [self.delegate relatedCellDidClick:indexPath.row];
    }
}


@end
