//
//  FFPopListView.h
//  FFVideo
//
//  Created by HD on 17/3/6.
//  Copyright © 2017年 http://duxinfeng.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FFPopListView;

typedef void(^FFPopListViewDidSelectBlock)(UITableView *tablewView,NSIndexPath *indexPath);


@interface FFPopListView : UIView

@property(nonatomic,copy) FFPopListViewDidSelectBlock didSelectBlock;

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;

- (instancetype)initWithTitle:(NSString *)title dataSource:(NSArray *)dataarray selectedText:(NSString *)selectedText didSelectBlock:(FFPopListViewDidSelectBlock)didSelectBlock;

- (void)show;
- (void)dismiss;

@end


@interface FFPopListViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIImageView *selectImageView;

@end
