//
//  GrabSetTagTableViewCell.m
//  IDo
//
//  Created by liangpengshuai on 10/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "GrabSetTagTableViewCell.h"
#import "GrabTagCollectionViewCell.h"

@implementation GrabSetTagTableViewCell

+ (CGFloat)heigthOfCellWithDataSource:(NSArray *)dataSource
{
    CGFloat offsetX = 0;
    int line = 1;

    for (int j=0; j < dataSource.count; j++) {
        CGSize itemSize = [[dataSource objectAtIndex:j] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11.0]}];
        itemSize = CGSizeMake(itemSize.width+30, 40);
        
        if (offsetX + itemSize.width > (kWindowWidth-40)) {
            offsetX = itemSize.width;
            line++;
            
        } else {
            offsetX += itemSize.width;

        }
    }

    return line*40 + 40;

}

- (void)awakeFromNib {
    
    _collectionView.backgroundColor = APP_PAGE_COLOR;
    _dataSource = [@[@"收银员",@"收银员",@"收银员",@"收银员",@"收银员",@"收银员", @"收银员",@"收银员",@"收银员",@"收银员",@"收银员"] mutableCopy];
    TaoziCollectionLayout *layou = (TaoziCollectionLayout *)_collectionView.collectionViewLayout;
    layou.delegate = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"GrabTagCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"grabTagCollectionCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - 实现UICollectionView的数据源以及代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GrabTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"grabTagCollectionCell" forIndexPath:indexPath];
    cell.tabBkgImage = @"icon_tage_bg.png";
    [cell.grabTagBtn setTitle:[_dataSource objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark - TaoziLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [_dataSource objectAtIndex:indexPath.row];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11.0]}];
    return CGSizeMake(size.width+30, 40);
}

- (CGSize)collectionview:(UICollectionView *)collectionView sizeForHeaderView:(NSIndexPath *)indexPath
{
    return CGSizeMake(kWindowWidth, 0);
}

- (NSInteger)numberOfSectionsInTZCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)tzcollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tzcollectionLayoutWidth
{
//    NSLog(@"%f", self.bounds.size.width);
    return self.bounds.size.width-40;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate setTagDidSelectItemAtIndex:indexPath];
}

@end
