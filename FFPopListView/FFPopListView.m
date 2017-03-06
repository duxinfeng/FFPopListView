//
//  FFPopListView.m
//  FFVideo
//
//  Created by HD on 17/3/6.
//  Copyright © 2017年 http://duxinfeng.com. All rights reserved.
//

#import "FFPopListView.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface FFPopListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataarray;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;

@property (nonatomic,copy) NSString *selectedText;
@property (nonatomic,copy) NSString *title;

@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat headHeight;

@property (nonatomic,strong) UIImageView * leftImageView;
@property (nonatomic,strong) UIImageView * rightImageView;
@end


@implementation FFPopListView


- (instancetype)initWithTitle:(NSString *)title dataSource:(NSArray *)dataarray selectedText:(NSString *)selectedText didSelectBlock:(FFPopListViewDidSelectBlock)didSelectBlock
{
    self = [super init];
    
    if (self) {
        
        [self defalutInit];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.didSelectBlock = didSelectBlock;
        self.dataarray = dataarray;
        self.title = title;
        self.selectedText = selectedText;
       
        UIControl *overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:overlayView];

        [self addSubview:self.tableView];
        [self addSubview:self.leftImageView];
        [self addSubview:self.rightImageView];
        
      
        
    }
    return self;
    
}

- (void)defalutInit
{
    self.left = 20;
    self.top = 50;
    self.cellHeight = 44.f;
    self.headHeight = 60.f;
    self.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat realHeight = self.dataarray.count*self.cellHeight+self.headHeight;
    if ((realHeight < self.tableView.frame.size.height)) {
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,(self.frame.size.height - realHeight)/2, self.tableView.frame.size.width, realHeight);
    }

    self.leftImageView.frame = CGRectMake(self.tableView.frame.origin.x-3, self.tableView.frame.origin.y-5, self.leftImageView.image.size.width, self.leftImageView.image.size.height);

    self.rightImageView.frame = CGRectMake(self.tableView.frame.origin.x+self.tableView.frame.size.width-self.rightImageView.image.size.width+3, self.tableView.frame.origin.y-5, self.rightImageView.image.size.width, self.rightImageView.image.size.height);

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * kCellWithIdentifier = @"FFPopListViewCell";
    
    FFPopListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellWithIdentifier];
   
    if (cell==nil) {
        cell = [[FFPopListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellWithIdentifier];
    }
    cell.contentLabel.text = self.dataarray[indexPath.row];
    if ([self.selectedText isEqualToString:cell.contentLabel.text]) {
        cell.selectImageView.image = [UIImage imageNamed:@"ff_cell_select_highlighted"];
        self.selectedIndexPath = indexPath;
    }else{
        cell.selectImageView.image = [UIImage imageNamed:@"ff_cell_select_normal"];
    }
    
    tableView.separatorInset=UIEdgeInsetsMake(0,10, 0, 10);
    tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFPopListViewCell *cancelcell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
    cancelcell.selectImageView.image = [UIImage imageNamed:@"ff_cell_select_normal"];
    
    FFPopListViewCell *selectedcell = [tableView cellForRowAtIndexPath:indexPath];
    selectedcell.selectImageView.image = [UIImage imageNamed:@"ff_cell_select_highlighted"];

    self.selectedIndexPath = indexPath;
    
    self.didSelectBlock(self,indexPath);
    
    [self dismiss];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.title;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.backgroundColor = [UIColor whiteColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headHeight;
}

- (void)show
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            [window addSubview:self];
            break;
        }
    }
    
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.left, self.top, self.frame.size.width - self.left*2, self.frame.size.height - self.top*2) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 15;
    }
    return _tableView;
}



- (UIImageView *)leftImageView
{
    if(!_leftImageView){
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ff_cell_grass_left"]];

    }
    return _leftImageView;
}

- (UIImageView *)rightImageView
{
    if(!_rightImageView){
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ff_cell_grass_right"]];
    }
    return _rightImageView;
}

@end



@interface FFPopListViewCell ()


@end

@implementation FFPopListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        CGFloat padding = 10;
        
        self.selectImageView = [[UIImageView alloc] init];
        self.selectImageView.image = [UIImage imageNamed:@"ff_cell_select_normal"];
        self.selectImageView.frame = CGRectMake(self.frame.size.width-self.selectImageView.image.size.width+5, (self.frame.size.height - self.selectImageView.image.size.height)/2, self.selectImageView.image.size.width, self.selectImageView.image.size.height);
        [self.contentView addSubview:self.selectImageView];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.frame = CGRectMake(padding,0,self.frame.size.width - self.selectImageView.frame.size.width - padding*2,self.frame.size.height);
        [self.contentView addSubview:self.contentLabel];
        

    }

    return self;
}


@end
