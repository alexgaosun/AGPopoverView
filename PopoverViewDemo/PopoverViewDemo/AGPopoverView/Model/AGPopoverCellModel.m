//
//  AGPopoverCellModel.m
//  PopoverViewDemo
//
//  Created by 高莹莹 on 2019/6/3.
//  Copyright © 2019 高莹莹. All rights reserved.
//

#import "AGPopoverCellModel.h"

@implementation AGPopoverCellModel
+ (instancetype)modelWithImage:(NSString * _Nullable)imageName title:(NSString  * _Nonnull )title dataArr:(NSArray * _Nullable)dataArr {
    AGPopoverCellModel *model = [[AGPopoverCellModel alloc] init];
    model.imageName = imageName;
    model.title = title;
    model.dataArr= dataArr;
    return model;
}

@end
