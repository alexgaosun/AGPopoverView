//
//  AGPopoverContentView.m
//  PopoverViewDemo
//
//  Created by 高莹莹 on 2019/6/3.
//  Copyright © 2019 高莹莹. All rights reserved.
//

#import "AGPopoverContentView.h"
#import "UIResponder+Transmit.h"
static CGFloat offset = 15.0;
@interface AGPopoverContentView()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation AGPopoverContentView
{
    UITableView *_tableview;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.scrollEnabled = NO;
    tableview.rowHeight = 44;
    tableview.delegate = self;
    tableview.showsVerticalScrollIndicator = NO;
    tableview.tableFooterView = [UIView new];
//    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableview registerClass:[AGPopoverCell class] forCellReuseIdentifier:NSStringFromClass([AGPopoverCell class])];
    [self addSubview:tableview];
    _tableview = tableview;
   
}
#pragma setter&getter
- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = dataArr;
    [_tableview reloadData];
}
#pragma mark TableviewDataSource&Delegatge
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AGPopoverCellModel *tmpModel = _dataArr[indexPath.row];
    [self.nextResponder transmitEventWithName:@"didSelectRow" object:tmpModel];
//    if (self.selectedCellBlock) {
//        self.selectedCellBlock(tmpModel);
//    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AGPopoverCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(AGPopoverCell.class) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (void)setMainViewFrame:(CGRect)mainViewFrame
{
    _mainViewFrame = mainViewFrame;
    _tableview.frame = self.bounds;
}
- (void)transmitEventWithName:(NSString *)eventName object:(id)object
{
    AGPopoverCellModel *tmpModel = _dataArr[0];
    [self.nextResponder transmitEventWithName:eventName object:tmpModel];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataArr.count - 1) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 10000)];
        }
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 15)];
        }
    }
    
    
}
@end
/* ------------------------------------------------------------------------------------------------ */
NSString * const backActionEvent = @"backActionEvent";
@interface AGPopoverCell () {
    UIImageView *_iconView ;
    UILabel *_titleLabel ;
    
    UIImageView *_arrowView ;
    UIButton *_backbtn;
    UILabel *_cellTitleView;
}

@end

@implementation AGPopoverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"icon_fh"] forState:UIControlStateNormal];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
        
        [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:backBtn];
        _backbtn = backBtn;
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        imageView.backgroundColor = [UIColor randomColorWithAlpha:.4];
        [self.contentView addSubview:imageView];
        _iconView = imageView;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"收到货空间A";
        //        label.backgroundColor = [UIColor randomColorWithAlpha:.4];
        label.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:label];
        _titleLabel = label;
        
        UILabel *cellTitleView = [[UILabel alloc] init];
        cellTitleView.text = @"屏蔽";
        //        label.backgroundColor = [UIColor randomColorWithAlpha:.4];
        cellTitleView.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:cellTitleView];
        _cellTitleView = cellTitleView;
        
        
        UIImageView *arrowView = [[UIImageView alloc] init];
        arrowView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:arrowView];
        arrowView.image = [UIImage imageNamed:@"icon_jr"];
        _arrowView = arrowView;
        
    }
    return self;
}

- (void)backAction:(UIButton *)sender
{
    [self transmitEventWithName:@"buttonAction" object:sender];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    _iconView.frame = CGRectMake(offset, height/2-7, 14, 14);
    CGFloat titleLabelOrginX = 0;
    if (_model.imageName) {
        titleLabelOrginX = CGRectGetMaxX(_iconView.frame) + 5;
    }else{
        titleLabelOrginX = offset;
    }
    _titleLabel.frame = CGRectMake(titleLabelOrginX, CGRectGetMinY(_iconView.frame), width - CGRectGetMaxX(_iconView.frame) - 2*offset, CGRectGetHeight(_iconView.frame));
    _arrowView.frame = CGRectMake(self.contentView.bounds.size.width - 15 - 5, height/2 - 4.5, 5, 9);
    CGFloat textWidth = [_cellTitleView.text boundingRectWithSize:CGSizeMake(999, 14) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil].size.width;
    _cellTitleView.frame = CGRectMake((width - textWidth)/2, height/2-7, textWidth, 14);
    _backbtn.frame = CGRectMake(offset, height/2-7, 40, 14);
    
}

- (void)setModel:(AGPopoverCellModel *)model{
    _model = model;
    _backbtn.hidden = !_model.isBack;
    _cellTitleView.hidden = !_model.isBack;;
    //常规cell
    _iconView.hidden = _model.isBack;
    _titleLabel.hidden = _model.isBack;;
    if (_model.isBack) {
        _cellTitleView.text = _model.title;
        
    }else{
        if (_model.imageName) {
            _iconView.image = [UIImage imageNamed:_model.imageName];
        }
        
        _titleLabel.text = _model.title;
    }
    //是否展示箭头
    if (model.dataArr.count) {
        _arrowView.hidden = NO;
    }else{
        _arrowView.hidden = YES;
    }
}
@end
