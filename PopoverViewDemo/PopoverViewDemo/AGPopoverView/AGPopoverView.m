//
//  AGPopoverView.m
//  PopoverViewDemo
//
//  Created by 高莹莹 on 2019/6/3.
//  Copyright © 2019 高莹莹. All rights reserved.
//

#import "AGPopoverView.h"
#import "AGPopoverContentView.h"
#import "AGPopoverCellModel.h"
#import "UIResponder+Transmit.h"
#import "AGPopoverContentView.h"
static CGFloat offset = 5.0;
static CGFloat triangleOffset = 5.0;
static CGFloat CornerRadius = 5;
static CGFloat AnimateDuration = 0.25;
static CGFloat bgOrginX = 15.0;
typedef NS_ENUM(NSInteger, AGPopoverDirection) {
    AGPopoverDirectionUp = 1 << 0,
    AGPopoverDirectionLeft = 1 << 1,
    AGPopoverDirectionDown = 1 << 2,
    AGPopoverDirectionRight = 1 << 3,
};

@interface AGPopoverView()
{
    UIView *_backgroundView;//容器ContainerView
    AGPopoverContentView *_mainView;//
    CAShapeLayer *_triangleLayer;
    AGPopoverDirection _direction;
    CGPoint _arrowLocation;
    CGRect _bgFrame;
}

@end
@implementation AGPopoverView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

+ (instancetype _Nullable )popoverViewWithAttachmentView:(UIView *_Nonnull)attachmentView withModelsArr:(NSArray *)dataArr{
    NSAssert([attachmentView isKindOfClass:[UIView class]], @"attachmentView 必须为UIView子类!");
    
    AGPopoverView *popover = [[AGPopoverView alloc] init];
    popover.attachmentView = attachmentView;
    popover.dataArray = dataArr;
    return popover;
}

- (void)initViews {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.1];
    self.frame = [UIScreen mainScreen].bounds;
    //    self.showAnimation = YES;
    
    UIView *bgView = [UIView new];
    bgView.clipsToBounds = YES;
    [self addSubview:bgView];
    _backgroundView = bgView;
    _backgroundView.backgroundColor = [UIColor clearColor];
    bgView.userInteractionEnabled = YES;
    
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.fillColor = [UIColor whiteColor].CGColor;
    [bgView.layer addSublayer:shaperLayer];
    _triangleLayer = shaperLayer;
    
    __weak typeof(self)weakSelf = self;
    AGPopoverContentView *tmpView  =[[AGPopoverContentView alloc] initWithFrame:CGRectZero];
    tmpView.backgroundColor = [UIColor redColor];
    [tmpView setSelectedCellBlock:^(AGPopoverCellModel * _Nonnull cellModel) {
        [weakSelf didSelCell:cellModel];
    }];
    
    [bgView addSubview:tmpView];
    _mainView = tmpView;
    
}

- (void)didSelCell:(AGPopoverCellModel *)model
{
    NSArray *array = [NSArray arrayWithArray:model.dataArr];
    if (model.dataArr.count) {
        //计算backgroundView的坐标偏移与大小
        CGFloat subheightY = 0;
        CGRect changeBgFrame = CGRectZero;
        if (_dataArray.count > array.count) {
            subheightY = (_dataArray.count - array.count) * 45;
            if (_direction==AGPopoverDirectionUp) {
                CGFloat tmpOrginY = _bgFrame.origin.y;
                changeBgFrame = CGRectMake(_bgFrame.origin.x, tmpOrginY,  _bgFrame.size.width, _bgFrame.size.height -  subheightY);
            }else{
                CGFloat tmpOrginY = _bgFrame.origin.y + subheightY;
                changeBgFrame = CGRectMake(_bgFrame.origin.x, tmpOrginY,  _bgFrame.size.width, _bgFrame.size.height -  subheightY);
            }
        }else if (_dataArray.count < array.count){
            subheightY = (array.count - _dataArray.count) * 45;
            if (_direction==AGPopoverDirectionUp) {
                CGFloat tmpOrginY = _bgFrame.origin.y;
                changeBgFrame = CGRectMake(_bgFrame.origin.x, tmpOrginY,  _bgFrame.size.width, _bgFrame.size.height +  subheightY);
            }else{
                CGFloat tmpOrginY = _bgFrame.origin.y - subheightY;
                changeBgFrame = CGRectMake(_bgFrame.origin.x, tmpOrginY,  _bgFrame.size.width, _bgFrame.size.height + subheightY);
            }
        }else{
            
        }
        
        _backgroundView.frame = changeBgFrame;
        _triangleLayer.path = [self trianglePath].CGPath ;
        
        AGPopoverContentView *subSelContenView  =[[AGPopoverContentView alloc] initWithFrame:CGRectZero];
        subSelContenView.tag = 100;
        subSelContenView.clipsToBounds = YES;
        subSelContenView.layer.cornerRadius = CornerRadius;
        
        subSelContenView.backgroundColor = [UIColor purpleColor];
        
        CGRect subSelViewRect = _mainView.frame;
        subSelContenView.dataArr = array;
        subSelViewRect.origin.x = _mainView.bounds.size.width;
        subSelViewRect.size.height = 45 *array.count;
        subSelContenView.frame =subSelViewRect;
        subSelContenView.mainViewFrame = _mainView.mainViewFrame;

        [subSelContenView setSelectedCellBlock:^(AGPopoverCellModel * _Nonnull cellModel) {
            
        }];
        
        [_backgroundView addSubview:subSelContenView];
        UIView *tmpMainView = _mainView;
        [UIView animateWithDuration:0.2 animations:^{
            self->_mainView.hidden = YES;
            subSelContenView.frame = CGRectMake(0, subSelContenView.frame.origin.y, subSelContenView.frame.size.width, 45 *array.count);
            tmpMainView.frame = CGRectMake(-tmpMainView.frame.size.width, tmpMainView.frame.origin.y, tmpMainView.frame.size.width, tmpMainView.frame.size.height);

        }completion:^(BOOL finished) {
            
        }];
    }else{
        [self dismissFromSuperView];
    }
}


- (void)backAction
{
    _backgroundView.frame = _bgFrame;
    self->_triangleLayer.path = [self trianglePath].CGPath ;
    _mainView.hidden = NO;
    UIView *subSelView = [_backgroundView viewWithTag:100];
    UIView *tmpMainView = _mainView;
    [UIView animateWithDuration:0.2 animations:^{
        subSelView.alpha = 0;
       tmpMainView.frame = CGRectMake(0, tmpMainView.frame.origin.y, tmpMainView.frame.size.width, tmpMainView.frame.size.height);
        subSelView.frame = CGRectMake(subSelView.frame.size.width, 0, subSelView.frame.size.width,self->_bgFrame.size.height);

    } completion:^(BOOL finished) {
        
        [subSelView removeFromSuperview];
        
    }];
}
- (void)didMoveToSuperview {
    
    if (!self.superview) {
        return;
    }
    
    //    NSLog(@"superView: %@, frame: %@, delegate: %@", self.superview, NSStringFromCGRect(_tableView.frame), self.delegate);
    
    [self calculateArrowDirection];
    [self calculateBackgroundAndMianViewFrame];
    
    CGFloat tableY = 0.0;
    switch (_direction) {
        case AGPopoverDirectionUp:
            //            tableY = offset;
            break;
            
        case AGPopoverDirectionDown:
            tableY = 0.0;
            break;
            
        default:
            break;
    }
    
    _triangleLayer.path = [self trianglePath].CGPath;
}
- (void)show {
    
    NSCAssert(self.attachmentView, @"XLPopoverView没有设置必要的attachmentView属性!");
    NSCAssert([self.attachmentView respondsToSelector:@selector(convertRect:toView:)], @"XLPopoverView的attachmentView不支持convertRect:toView:方法!可能是attachmentView不是UIView的子类!");
    
    UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [rootView addSubview:self];
    
    if (_showAnimation) {
        [self showPopoverView:YES complete:nil];
    }
}
#pragma mark - 私有方法

- (void)calculateArrowDirection {
    // 计算点击触发的view 在当前view的坐标
    CGRect rect = [self.attachmentView convertRect:self.attachmentView.bounds toView:self];
    CGFloat upHeight = rect.origin.y;
    CGFloat downHeight = self.frame.size.height - CGRectGetMaxY(rect);
    
    if (upHeight > downHeight) {
        _direction |= AGPopoverDirectionDown;
    }else{
        _direction |= AGPopoverDirectionUp;
    }
    
    if (rect.origin.x + rect.size.width < 2*offset + CornerRadius) {
        _direction |= AGPopoverDirectionLeft;
    }
    
    if (self.frame.size.width - CGRectGetMinX(rect) < 2*offset + CornerRadius ) {
        _direction |= AGPopoverDirectionRight;
    }
}

- (void)calculateBackgroundAndMianViewFrame {
    
    // 计算点击触发的view 在当前view的坐标
    CGRect rect = [self.attachmentView convertRect:self.attachmentView.bounds toView:self];
    CGFloat upHeight = rect.origin.y;
    CGFloat downHeight = self.frame.size.height - CGRectGetMaxY(rect);
    
    // 比较cell高度之和与上下所剩高度，若满足则选择较大者，若不满足则设置_tableView的高度并让其可滑动
    CGFloat maxHeight = upHeight > downHeight ? upHeight : downHeight;
    // 计算table高度
    CGFloat defaultHeight = 45 * _dataArray.count;
    CGFloat tableHeight = defaultHeight;
    if (tableHeight > maxHeight - 2*offset) {
        tableHeight = maxHeight - 2*offset;
        // 防止遮挡status bar
        if (upHeight > downHeight) {
            tableHeight -= offset;
        }
    }
    // 计算table宽度
    CGFloat tableWidth = 0;
    tableWidth = self.frame.size.width - (bgOrginX * 2);
    
    // 计算table原点坐标
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    
    CGPoint point = CGPointZero;
    CGPoint tablePoint = CGPointZero;
    
    // 箭头尖在正上方
    if (_direction == AGPopoverDirectionUp) {
        width = tableWidth;
        height = tableHeight + offset;
        point = CGPointMake(bgOrginX, rect.origin.y + rect.size.height);
        if (point.x + width > self.bounds.size.width - offset) {
            point = CGPointMake(self.bounds.size.width - offset - width, point.y);
        }else if (point.x < offset) {
            point = CGPointMake(offset, point.y);
        }
        tablePoint = CGPointMake(0, offset);
    }
    
    // 箭头在正下方
    if (_direction == AGPopoverDirectionDown) {
        width = tableWidth;
        height = tableHeight + offset;
        point = CGPointMake(CGRectGetMaxX(rect) - rect.size.width/2 - width/2, CGRectGetMinY(rect) - height);
        if (point.x + width > self.bounds.size.width - offset) {
//            point = CGPointMake(self.bounds.size.width - offset - width, point.y);
            point = CGPointMake(bgOrginX, point.y);
        }else if (point.x < offset) {
            point = CGPointMake(bgOrginX, point.y);
        }
        tablePoint = CGPointMake(0, 0);
    }
    
    // 箭头在左上方
    if (_direction == (AGPopoverDirectionUp | AGPopoverDirectionLeft)) {
        width = tableWidth + offset;
        height = tableHeight;
        CGPoint arrowPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + rect.size.height / 2);
        point = CGPointMake(arrowPoint.x, arrowPoint.y - CornerRadius - 2*offset);
        tablePoint = CGPointMake(offset, 0);
        
        if (point.y + height < self.bounds.size.height - offset && defaultHeight > height ) {
            CGFloat maxHeight = self.bounds.size.height - offset - point.y;
            height = maxHeight > defaultHeight ? defaultHeight : maxHeight;
            tableHeight = height;
        }
    }
    
    // 箭头在右上方
    if (_direction == (AGPopoverDirectionUp | AGPopoverDirectionRight)) {
        width = tableWidth + offset;
        height = tableHeight;
        CGPoint arrowPoint = CGPointMake(CGRectGetMinX(rect) - width, CGRectGetMinY(rect) + rect.size.height / 2);
        point = CGPointMake(arrowPoint.x, arrowPoint.y - 2*offset - CornerRadius);
        tablePoint = CGPointMake(0, 0);
        
        if (point.y + height < self.bounds.size.height - offset && defaultHeight > height  ) {
            CGFloat maxHeight = self.bounds.size.height - offset - point.y;
            height = maxHeight > defaultHeight ? defaultHeight : maxHeight;
            tableHeight = height;
        }
    }
    
    // 箭头在左下方
    if (_direction == (AGPopoverDirectionDown | AGPopoverDirectionLeft)) {
        width = tableWidth + offset;
        height = tableHeight;
        CGPoint arrowPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + rect.size.height / 2);
        point = CGPointMake(arrowPoint.x, arrowPoint.y + 2*offset + CornerRadius - height);
        tablePoint = CGPointMake(offset, 0);
        
        if (point.y > 20 && height < defaultHeight ) {
            CGFloat maxHeight = point.y + height - 20;
            CGFloat maxY = point.y + height;
            height = maxHeight > defaultHeight ? defaultHeight : maxHeight;
            tableHeight = height;
            point.y = maxY - height;
        }
    }
    
    // 箭头在右下方
    if (_direction == (AGPopoverDirectionDown | AGPopoverDirectionRight)) {
        width = tableWidth + offset;
        height = tableHeight;
        CGPoint arrowPoint = CGPointMake(CGRectGetMinX(rect) - width, CGRectGetMinY(rect) + rect.size.height / 2);
        point = CGPointMake(arrowPoint.x, arrowPoint.y + 2*offset + CornerRadius - height);
        tablePoint = CGPointMake(0, 0);
        
        if (point.y > 20 && height < defaultHeight ) {
            CGFloat maxHeight = point.y + height - 20;
            CGFloat maxY = point.y + height;
            height = maxHeight > defaultHeight ? defaultHeight : maxHeight;
            tableHeight = height;
            point.y = maxY - height;
        }
    }
    
    _bgFrame = CGRectMake(point.x, point.y, width, height);
    _backgroundView.frame = _bgFrame;
    
    CGRect mainViewRect = CGRectMake(tablePoint.x, tablePoint.y, tableWidth, tableHeight);
    _mainView.frame = mainViewRect;
    _mainView.mainViewFrame = mainViewRect;
    _mainView.dataArr = _dataArray;
    _mainView.layer.cornerRadius = CornerRadius;
    _mainView.clipsToBounds = YES;
    _mainView.layer.masksToBounds = YES;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissFromSuperView];
}
- (void)dismissFromSuperView {
    if (_showAnimation) {
        [self showPopoverView:NO complete:^{
            [self removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}
// 绘制三角形
- (UIBezierPath *)trianglePath {
    
    CGPoint point = CGPointZero;
    CGRect rect = [self.attachmentView convertRect:self.attachmentView.bounds toView:self];
    
    CGPoint point1 = CGPointZero, point2 = CGPointZero;
    
    // 箭头在正上方
    if (_direction == AGPopoverDirectionUp) {
        point = CGPointMake(CGRectGetMaxX(rect) - rect.size.width/2, CGRectGetMaxY(rect));
        point1 = CGPointMake(point.x - triangleOffset, point.y + triangleOffset);
        point2 = CGPointMake(point.x + triangleOffset, point.y + triangleOffset);
    }
    
    // 箭头在正下方
    if (_direction == AGPopoverDirectionDown) {
        point = CGPointMake(CGRectGetMaxX(rect) - rect.size.width/2, CGRectGetMinY(rect));
        point1 = CGPointMake(point.x - triangleOffset, point.y - triangleOffset);
        point2 = CGPointMake(point.x + triangleOffset, point.y - triangleOffset);
    }
    
    // 箭头在左上方
    if (_direction == (AGPopoverDirectionUp | AGPopoverDirectionLeft)) {
        point = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + rect.size.height/2);
        point1 = CGPointMake(point.x + triangleOffset, point.y - triangleOffset);
        point2 = CGPointMake(point.x + triangleOffset, point.y + triangleOffset);
    }
    
    // 箭头在右上方
    if (_direction == (AGPopoverDirectionUp | AGPopoverDirectionRight)) {
        point = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + rect.size.height/2);
        point1 = CGPointMake(point.x - triangleOffset, point.y - triangleOffset);
        point2 = CGPointMake(point.x - triangleOffset, point.y + triangleOffset);
    }
    
    // 箭头在左下方
    if (_direction == (AGPopoverDirectionDown | AGPopoverDirectionLeft)) {
        point = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + rect.size.height/2);
        point1 = CGPointMake(point.x + triangleOffset, point.y - triangleOffset);
        point2 = CGPointMake(point.x + triangleOffset, point.y + triangleOffset);
    }
    
    // 箭头在右下方
    if (_direction == (AGPopoverDirectionDown | AGPopoverDirectionRight)) {
        point = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + rect.size.height/2);
        point1 = CGPointMake(point.x - triangleOffset, point.y - triangleOffset);
        point2 = CGPointMake(point.x - triangleOffset, point.y + triangleOffset);
    }
    
    point = [self.layer convertPoint:point toLayer:_backgroundView.layer];
    _arrowLocation = point;
    point1 = [self.layer convertPoint:point1 toLayer:_backgroundView.layer];
    point2 = [self.layer convertPoint:point2 toLayer:_backgroundView.layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    [path addLineToPoint:point1];
    [path addLineToPoint:point2];
    [path closePath];
    
    return path;
}

//动画show
- (void)showPopoverView:(BOOL)isShowing complete:(void (^)(void))complete{
    
    UIView *animationView = _backgroundView;
    
    CGFloat scale = 0.01;
    
    CGFloat offsetX =  0.0;
    CGFloat offsetY =  0.0;
    
    // 计算偏移量
    
    // 箭头在正上方
    if (_direction == AGPopoverDirectionUp) {
        offsetX = -(1 - scale)*((self.bounds.size.width- 40)/2 - _arrowLocation.x);
        offsetY = -(1 - scale)*animationView.frame.size.height/2;
    }
    
    // 箭头在正下方
    if (_direction == AGPopoverDirectionDown) {
        offsetX = -(1 - scale)*((self.bounds.size.width- 40)/2  - _arrowLocation.x);
        offsetY = (1 - scale)*animationView.frame.size.height/2;
    }
    
    // 箭头在左上方
    if (_direction == (AGPopoverDirectionUp | AGPopoverDirectionLeft)) {
        offsetX = -(1 - scale)*(animationView.frame.size.width/2);
        offsetY = -(1 - scale)*(animationView.frame.size.height/2 - _arrowLocation.y );
    }
    
    // 箭头在右上方
    if (_direction == (AGPopoverDirectionUp | AGPopoverDirectionRight)) {
        offsetX = (1 - scale)*(animationView.frame.size.width/2);
        offsetY = -(1 - scale)*(animationView.frame.size.height/2 - _arrowLocation.y );
    }
    
    // 箭头在左下方
    if (_direction == (AGPopoverDirectionDown | AGPopoverDirectionLeft)) {
        offsetX = -(1 - scale)*(animationView.frame.size.width/2);
        offsetY = -(1 - scale)*(animationView.frame.size.height/2 - _arrowLocation.y );
    }
    
    // 箭头在右下方
    if (_direction == (AGPopoverDirectionDown | AGPopoverDirectionRight)) {
        offsetX = (1 - scale)*(animationView.frame.size.width/2);
        offsetY = -(1 - scale)*(animationView.frame.size.height/2 - _arrowLocation.y );
    }
    
    //    NSLog(@"offsetX: %f, offsetY: %f", offsetX, offsetY);
    
    CGAffineTransform beginTransform = CGAffineTransformIdentity;
    CGAffineTransform endTransform = CGAffineTransformIdentity;
    CGFloat beginAlpha = 0.0;
    CGFloat endAlpha = 0.0;
    
    if (isShowing) {
        beginTransform = CGAffineTransformMake(scale, 0, 0, scale, offsetX, offsetY);
        endTransform = CGAffineTransformIdentity;
        beginAlpha = 0;
        endAlpha = 1.0;
    }else{
        beginTransform = animationView.transform;
        endTransform = CGAffineTransformMake(scale, 0, 0, scale, offsetX, offsetY);
        beginAlpha = animationView.alpha;
        endAlpha = .1;
    }
    
    // 动画由小变大
    animationView.transform = beginTransform;
    self.alpha = beginAlpha;
    
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.alpha = endAlpha;
        animationView.transform = endTransform;
        
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}
- (void)transmitEventWithName:(NSString *)eventName object:(id)object
{
    NSLog(@"%@",eventName);
    if ([eventName isEqualToString:@"didSelectRow"]) {//cell点击
        if ([object isKindOfClass:[AGPopoverCellModel class]]) {
            [self didSelCell:object];
        }
    }else{//返回事件
        [self backAction];
    }
}
@end
