//
//  AGPopoverView.h
//  PopoverViewDemo
//
//  Created by 高莹莹 on 2019/6/3.
//  Copyright © 2019 高莹莹. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGPopoverCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface AGPopoverView : UIView
@property (nonatomic, strong) UIView * _Nonnull attachmentView;
@property (nonatomic, strong) NSArray<AGPopoverCellModel *> * _Nonnull dataArray;
@property (nonatomic, assign) BOOL showAnimation;
+ (instancetype _Nullable )popoverViewWithAttachmentView:(UIView *_Nonnull)attachmentView withModelsArr:(NSArray *)dataArr;
- (void)show ;
@end

NS_ASSUME_NONNULL_END
