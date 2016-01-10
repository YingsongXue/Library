//
//  PALibraryDAO.h
//  Library
//
//  Created by 薛 迎松 on 10/16/15.
//  Copyright © 2015 薛 迎松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PALibraryBook.h"

typedef NS_ENUM(NSInteger, PALibraryTable)
{
    PALibraryTableUnknown = 0,
    PALibraryTableBooks,
};

typedef NS_ENUM(NSInteger, PABookStatus)
{
    PABookStatusDefault = 0,
    PABookStatusChecking = 1,
    PABookStatusFinished = 2,
};



@interface PALibraryDAO : NSObject

//检查数据库，创建或升级
- (BOOL)isExistsDatabase;

- (BOOL)createDatabase;

- (BOOL)upgradeDatabase;

- (void)removeDatabase;

- (BOOL)checkDatabase;

//- (BOOL)importData:(NSArray *)dataList table:(UGMTable )table;
//
//- (BOOL)removeData:(NSArray *)dataList table:(UGMTable )table;

#pragma mark Setting
//- (void)insertSetting:(NSString *)syncDate version:(NSString *)version;

#pragma mark Validate
//- (BOOL)isBook

#pragma mark Add Info
//- (BOOL)insertBooks:(NSString *)isbn keyType:(PABookKeyType)keyType;

//may be need key
//- (BOOL)updateBooksInfo:(NSDictionary *)book;

#pragma mark GetData
//- (NSDictionary *)getOurStaff;
//
//- (NSArray *)getLocations;
//
//- (NSDictionary *)getSetting;
//
//- (NSArray *)getSponsors;
//
//- (NSDictionary *)getAgenda:(NSString *)year;
//
//- (NSArray *)getSpeakersOfEvent:(NSString *)eventID;
//
//- (NSDictionary *)getDistributor;
//
//- (NSDictionary *)getOneOnOne;

@end
