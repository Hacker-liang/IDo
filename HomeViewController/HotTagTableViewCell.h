//
//  HotTagTableViewCell.h
//  IDo
//
//  Created by liangpengshuai on 10/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoziCollectionLayout.h"

@protocol HotTagTableViewCellDelegate <NSObject>

- (void)hotTagDidSelectItemAtIndex:(NSIndexPath *)indexPath;

@end

@interface HotTagTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, TaoziLayoutDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *dataSource;

+ (CGFloat)heigthOfCellWithDataSource:(NSArray *)dataSource;

@property (weak, nonatomic) id <HotTagTableViewCellDelegate>delegate;

@end
