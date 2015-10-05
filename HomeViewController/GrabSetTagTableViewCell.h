//
//  GrabSetTagTableViewCell.h
//  IDo
//
//  Created by liangpengshuai on 10/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoziCollectionLayout.h"

@protocol GrabSetTagTableViewCellDelegate <NSObject>

- (void)setTagDidSelectItemAtIndex:(NSIndexPath *)indexPath;

@end

@interface GrabSetTagTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate, TaoziLayoutDelegate>

+ (CGFloat)heigthOfCellWithDataSource:(NSArray *)dataSource;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (weak, nonatomic) id <GrabSetTagTableViewCellDelegate>delegate;


@end
