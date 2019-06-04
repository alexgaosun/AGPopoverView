//
//  UIResponder+Transmit.m
//  PopoverViewDemo
//
//  Created by 高莹莹 on 2019/6/4.
//  Copyright © 2019 高莹莹. All rights reserved.
//

#import "UIResponder+Transmit.h"

@implementation UIResponder (Transmit)
- (void)transmitEventWithName:(NSString *)eventName object:(id)object
{
    [[self nextResponder] transmitEventWithName:eventName object:object];
}
- (id)findAndMethodAction:(SEL)action
{
    UIResponder *responder = self;
    // 循环获取下一个响应者,直到响应者是一个UIViewController类的一个对象为止,然后返回该对象.
    while ((responder = [responder nextResponder])) {
        if ([responder respondsToSelector:action]) {
            IMP imp = [responder methodForSelector:action];
            void(*func)(id, SEL, NSDictionary*) = (void *)imp;
            func(responder, action,nil);
            return (UIViewController *)responder;
        }
    }
    return nil;

}
@end
