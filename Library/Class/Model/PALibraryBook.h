//
//  PALibraryBooks.h
//  Library
//
//  Created by 薛 迎松 on 10/16/15.
//  Copyright © 2015 薛 迎松. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PABookKeyType)
{
    PABookKeyTypeID,
    PABookKeyTypeISBN10,
    PABookKeyTypeISBN13,
    PABookKeyTypeURL,
};

@interface PALibraryBook : NSObject

+ (PABookKeyType)typeOf:(NSString *)str;

+ (NSArray *)book;

+ (NSArray *)bookInfoOf:(NSString *)more;

@end

