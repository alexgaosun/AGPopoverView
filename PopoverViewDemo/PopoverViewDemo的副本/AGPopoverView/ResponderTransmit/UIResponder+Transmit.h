//
//  UIResponder+Transmit.h
//  PopoverViewDemo
//
//  Created by 高莹莹 on 2019/6/4.
//  Copyright © 2019 高莹莹. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (Transmit)
- (void)transmitEventWithName:(NSString *)eventName object:(id)object;
- (id)findAndMethodAction:(SEL)action;
@end

NS_ASSUME_NONNULL_END
