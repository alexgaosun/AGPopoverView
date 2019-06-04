//
//  AGPopoverCellModel.h
//  PopoverViewDemo
//
//  Created by 高莹莹 on 2019/6/3.
//  Copyright © 2019 高莹莹. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGPopoverCellModel : NSObject
@property (nonatomic, strong) NSString * _Nullable imageName ;
@property (nonatomic, strong) NSString * _Nonnull title ;
@property(nonatomic, strong)NSArray *dataArr;
@property(nonatomic, assign)BOOL isBack;
+ (instancetype)modelWithImage:(NSString * _Nullable)imageName title:(NSString  * _Nonnull )title dataArr:(NSArray * _Nullable)dataArr;
@end

NS_ASSUME_NONNULL_END
