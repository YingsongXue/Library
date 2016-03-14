//
//  PALibraryDAL.h
//  Library
//
//  Created by 薛 迎松 on 14/12/25.
//  Copyright (c) 2014年 薛 迎松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PALibraryDAO.h"

@interface PALibraryDAL : NSObject
+ (instancetype )sharedIntance;

@property (nonatomic, strong) PALibraryDAO *bookDAO;

- (void)addBook:(NSString *)isbn;

@end
