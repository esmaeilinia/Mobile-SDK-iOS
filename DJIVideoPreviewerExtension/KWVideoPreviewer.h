//
//  KWVideoPreviewer.h
//  DJISdkDemo
//
//  Created by Pandara on 2018/9/14.
//  Copyright © 2018 DJI. All rights reserved.
//

#import "DJIWidget.h"

@class KWVideoPreviewer;

@protocol DJIVideoPreviewerDelegate <NSObject>

- (void)kwVideoPreviewer:(nonnull KWVideoPreviewer *)videoPreviewer willProcessImageBuffer:(nonnull CVImageBufferRef)imageBuffer;

@end

@interface KWVideoPreviewer : DJIVideoPreviewer

@property (nonatomic, weak, nullable) id <DJIVideoPreviewerDelegate> delegate;

@end
