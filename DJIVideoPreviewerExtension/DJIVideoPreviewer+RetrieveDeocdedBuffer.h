//
//  DJIVideoPreviewer+RetrievingDeocdedBuffer.h
//  Mesh
//
//  Created by Pandara on 2018/9/3.
//  Copyright © 2018 Kiwi Information Technology Co., Ltd. All rights reserved.
//

#import <DJIWidget/DJIWidget.h>

@protocol DJIVideoPreviewerDelegate;

@interface DJIVideoPreviewer (RetrievingDeocdedBuffer)

@property (nonatomic, weak) id<DJIVideoPreviewerDelegate> delegate;

@end
