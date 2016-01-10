//
//  PALibraryDAL.h
//  Library
//
//  Created by 薛 迎松 on 14/12/25.
//  Copyright (c) 2014年 薛 迎松. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PALibraryDAL : NSObject
+ (instancetype )sharedIntance;

- (void)Log:(NSString *)isbn;
@end
