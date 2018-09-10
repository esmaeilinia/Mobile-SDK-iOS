//
//  DJIVideoPreviewerDelegate.h
//  Mesh
//
//  Created by Pandara on 2018/9/3.
//  Copyright © 2018 Kiwi Information Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import "DJIVideoPreviewer.h"

@protocol DJIVideoPreviewerDelegate <NSObject>

- (void)djiVideoPreviewer:(nonnull DJIVideoPreviewer *)videoPreviewer willProcessImageBuffer:(nonnull CVImageBufferRef)imageBuffer;

@end
