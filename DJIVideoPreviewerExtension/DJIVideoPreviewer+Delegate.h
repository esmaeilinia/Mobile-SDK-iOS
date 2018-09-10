//
//  DJIVideoPreviewer+Delegate.h
//  Mesh
//
//  Created by Pandara on 2018/9/4.
//  Copyright © 2018 Kiwi Information Technology Co., Ltd. All rights reserved.
//

#import "DJIWidget.h"

@protocol DJIVideoPreviewerDelegate;

@interface DJIVideoPreviewer (Delegate)

@property (nonatomic, weak) id <DJIVideoPreviewerDelegate> delegate;

@end
