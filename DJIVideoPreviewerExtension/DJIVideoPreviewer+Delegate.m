//
//  DJIVideoPreviewer+Delegate.m
//  Mesh
//
//  Created by Pandara on 2018/9/4.
//  Copyright © 2018 Kiwi Information Technology Co., Ltd. All rights reserved.
//

#import "DJIVideoPreviewer+Delegate.h"
#import <objc/runtime.h>

/// 用来包装内部若引用的 delegate，
/// Wrapper 将会以关联对象的方式存放到 DJIVideoPreviewer 中
@interface DelegateWrapper: NSObject

@property (nonatomic, weak) id <DJIVideoPreviewerDelegate> delegate;

@end

@implementation DelegateWrapper
@end

@implementation DJIVideoPreviewer (Delegate)

static const char *objKey = "associatedDelegate";

- (void)setDelegate:(id<DJIVideoPreviewerDelegate>)delegate {
    if (delegate) {
        DelegateWrapper *wrapper = [[DelegateWrapper alloc] init];
        wrapper.delegate = delegate;
        objc_setAssociatedObject(self, objKey, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, objKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id<DJIVideoPreviewerDelegate>)delegate {
    DelegateWrapper *wrapper = objc_getAssociatedObject(self, objKey);
    return wrapper.delegate;
}

@end
