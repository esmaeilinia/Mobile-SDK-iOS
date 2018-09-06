//
//  DJIVideoPreviewer+RetrievingDeocdedBuffer.m
//  Mesh
//
//  Created by Pandara on 2018/9/3.
//  Copyright © 2018 Kiwi Information Technology Co., Ltd. All rights reserved.
//

#import "DJIVideoPreviewer+RetrieveDeocdedBuffer.h"
#import <objc/runtime.h>
#import <CoreVideo/CoreVideo.h>
#import "DJIVideoPreviewerDelegate.h"
#import "DJIVideoPreviewer+Delegate.h"

@implementation DJIVideoPreviewer (RetrieveDeocdedBuffer)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(videoProcessFrame:);
        SEL swizzlingSelector = @selector(swizzling_videoProcessFrame:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        IMP originalIMP = method_getImplementation(originalMethod);
        const char *originalTypes = method_getTypeEncoding(originalMethod);
        
        NSAssert(originalIMP, @"\
                 没有找到 DJIVideoPreviewer 中的 videoProcessFrame 方法，\
                 可能 DJI 对实现细节进行了修改，\
                 需要重新找到类似职责的方法来进行 hook");
        
        Method swizzlingMethod = class_getInstanceMethod(class, swizzlingSelector);
        IMP swizzlingIMP = method_getImplementation(swizzlingMethod);
        const char *swizzlingTypes = method_getTypeEncoding(swizzlingMethod);
        
        class_replaceMethod(class, swizzlingSelector, originalIMP, originalTypes);
        class_replaceMethod(class, originalSelector, swizzlingIMP, swizzlingTypes);
    });
}

/// 在运行时与 DJIVideoPreviewer 中的 videoProcessFrame 方法进行交换
- (void)swizzling_videoProcessFrame:(VideoFrameYUV *)frame {
    // TODO: 在 DJIVideoPreviewer 的实现中，不是所有 buffer 都需要显示，
    // 有提前退出的逻辑，但此处通过 delegate 传送出去的 buffer 没有考虑这层逻辑
    
    if (self.delegate) {
        CVImageBufferRef imageBuffer = (CVImageBufferRef)CFRetain((CFTypeRef)[self convertToImageBufferFromYUVFrame:frame]);
        [self.delegate djiVideoPreviewer:self willProcessImageBuffer:imageBuffer];
        CFRelease(imageBuffer);
    }
    [self swizzling_videoProcessFrame:frame];
}

- (CVImageBufferRef)convertToImageBufferFromYUVFrame:(VideoFrameYUV *)yuvFrame {
    // TODO: 是否有必要加锁
    OSType pixelFormatType = 0;
    
    // 这里的格式选取逻辑不确定，可能会有问题，需要注意
    if (yuvFrame->frameType == VPFrameTypeYUV420Planer) {
        pixelFormatType = kCVPixelFormatType_420YpCbCr8Planar;
    } else if (yuvFrame->frameType == VPFrameTypeYUV420SemiPlaner) {
        pixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
    } else {
        return nil;
    }
    
    NSDictionary *options = @{(__bridge NSString *)kCVPixelBufferCGImageCompatibilityKey: @YES,
                              (__bridge NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @YES};
    
    CVPixelBufferRef pixelBuffer = nil;
    
    CVReturn createStatus = CVPixelBufferCreate(kCFAllocatorDefault,
                                                yuvFrame->width,
                                                yuvFrame->height,
                                                pixelFormatType,
                                                (__bridge CFDictionaryRef) options,
                                                &pixelBuffer);
    
    if (createStatus != kCVReturnSuccess) {
        return nil;
    }
    
    if (CVPixelBufferLockBaseAddress(pixelBuffer, 0) != kCVReturnSuccess) {
        CFRelease(pixelBuffer);
        return nil;
    }
    
    [self copyDataFromYUVFrame:yuvFrame toPixelBuffer:pixelBuffer];
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return (CVImageBufferRef)CFAutorelease(pixelBuffer);
}

- (void)copyDataFromYUVFrame:(VideoFrameYUV *)yuvFrame
               toPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    uint8_t *luma = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    uint8_t *chromaB = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1);
    uint8_t *chromaR = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 2);
    
    if (!luma && !chromaB && !chromaR) {
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        return;
    }
    
    int width = yuvFrame->width;
    int height = yuvFrame->height;
    int semiWidth = width / 2;
    int semiHeight = height / 2;
    
    //copy bytes
    if (yuvFrame->luma != NULL && luma != NULL){
        int copyLen = 0;
        switch (yuvFrame->frameType){
            case VPFrameTypeRGBA:
                copyLen = width * height * 4;
                break;
            case VPFrameTypeYUV420Planer:
                copyLen = width * height;
                break;
            case VPFrameTypeYUV420SemiPlaner:
                copyLen = width * height;
                break;
            default:
                break;
        }
        memcpy(luma, yuvFrame->luma, copyLen);
    }
    if (yuvFrame->chromaB != NULL && chromaB != NULL){
        int copyLen = 0;
        switch (yuvFrame->frameType){
            case VPFrameTypeRGBA:
                copyLen = 0;
                break;
            case VPFrameTypeYUV420Planer:
                copyLen = semiWidth * semiHeight;
                break;
            case VPFrameTypeYUV420SemiPlaner:
                copyLen = semiWidth * semiHeight * 2;
                break;
            default:
                break;
        }
        memcpy(chromaB, yuvFrame->chromaB, copyLen);
    }
    if (yuvFrame->chromaR != NULL && chromaR != NULL){
        int copyLen = 0;
        switch (yuvFrame->frameType){
            case VPFrameTypeRGBA:
                copyLen = 0;
                break;
            case VPFrameTypeYUV420Planer:
                copyLen = semiWidth * semiHeight;
                break;
            case VPFrameTypeYUV420SemiPlaner:
                copyLen = 0;
                break;
            default:
                break;
        }
        memcpy(chromaR, yuvFrame->chromaR,copyLen);
    }
}

@end















