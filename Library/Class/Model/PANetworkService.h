//
//  PANetworkService.h
//  Library
//
//  Created by 薛 迎松 on 14/12/25.
//  Copyright (c) 2014年 薛 迎松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

typedef NS_ENUM(NSInteger, PALibraryRequestType)
{
    PALibraryRequestTypeISBN = 1,
};

@protocol PALibraryDelegate <NSObject>
//导入数据操作

//
- (void)successOf:(id)data type:(PALibraryRequestType)type;

- (void)failedOf:(ASINetworkErrorType )error type:(PALibraryRequestType)type;

@end

@interface PANetworkService : NSObject
@property (nonatomic, weak) id<PALibraryDelegate> delegate;

- (void)netGetInfoISBN:(NSString *)isbn;

- (void)cancelAllOperation;

@end
