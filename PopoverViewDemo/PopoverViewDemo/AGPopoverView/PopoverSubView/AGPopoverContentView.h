//
//  AGPopoverContentView.h
//  PopoverViewDemo
//
//  Created by 高莹莹 on 2019/6/3.
//  Copyright © 2019 高莹莹. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGPopoverCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface AGPopoverContentView : UIView
@property(nonatomic, assign)CGRect mainViewFrame;
@property(nonatomic, strong)NSArray *dataArr;
@property (nonatomic,copy)void(^selectedCellBlock)(AGPopoverCellModel *cellModel);
@property (nonatomic,copy)void(^btnBackClickBlock)(AGPopoverCellModel *cellModel);
@end



/* ------------------------------------------------------------------------------------------------ */

@interface AGPopoverCell : UITableViewCell
extern NSString * const backActionEvent;
@property (nonatomic, strong) AGPopoverCellModel * _Nullable  model;

@end

NS_ASSUME_NONNULL_END
