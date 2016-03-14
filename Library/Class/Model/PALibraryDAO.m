//
//  PALibraryDAO.m
//  Library
//
//  Created by 薛 迎松 on 10/16/15.
//  Copyright © 2015 薛 迎松. All rights reserved.
//

#import "PALibraryDAO.h"
#import "FMDatabase.h"
#import "GlobeConfig.h"

NSString *dbPath = @"library.db";

@interface PALibraryDAO ()

@property (nonatomic, retain) FMDatabase *myDB;

@end

@implementation PALibraryDAO

- (void)dealloc
{
    [_myDB close];
}

- (NSString *)dbPath
{
    return [PADocumentsPath stringByAppendingPathComponent:dbPath];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.myDB = [FMDatabase databaseWithPath:[self dbPath]];
        [self.myDB open];
    }
    return self;
}

#pragma mark
#pragma mark CheckDatabase
//检查是否存在
- (BOOL)isExistsDatabase
{
    BOOL result = NO;
    result = [[NSFileManager defaultManager] fileExistsAtPath:[self dbPath]];
    if(result)
    {
        NSString *SQL = @"SELECT COUNT(*) AS Total FROM sqlite_master WHERE type='table' ";
        FMResultSet *rs = [self.myDB executeQuery:SQL];
        result = NO;
        if ([rs next])
        {
            result = [rs intForColumn:@"Total"];
        }
        [rs close];
    }
    return result >= 1;
}

- (BOOL)createDatabase
{
    BOOL complete = NO;
    [self.myDB beginTransaction];
    
    NSMutableString *SQL = [NSMutableString string];
    
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE Books "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   bookID integer PRIMARY KEY "];
    [SQL appendString:@" , isbn10 nvarchar(20) UNIQUE NOT NULL "];
    [SQL appendString:@" , isbn13 nvarchar(30) UNIQUE NOT NULL "];
    [SQL appendString:@" , title nvarchar(500) NOT NULL DEFAULT('No Title')  "];
    [SQL appendString:@" , subtitle nvarchar(500) NULL "];
    [SQL appendString:@" , origin_title nvarchar(500) NULL "];
    [SQL appendString:@" , alt_title nvarchar(500) NULL "];
    [SQL appendString:@" , pubdate nvarchar(50) NULL  "];
    [SQL appendString:@" , publisher nvarchar(50) NULL  "];
    
    [SQL appendString:@" , image nvarchar(1000) NULL  "];
    [SQL appendString:@" , alt nvarchar(1000) NULL  "];
    [SQL appendString:@" , url nvarchar(1000) NULL  "];
    
    [SQL appendString:@" , binding nvarchar(50) NULL  "];
    [SQL appendString:@" , price nvarchar(50) NULL  "];
    [SQL appendString:@" , pages integer NULL DEFAULT('0')  "];
    
    [SQL appendString:@" , author_intro nvarchar(4000) NULL  "];
    [SQL appendString:@" , summary nvarchar(4000) NULL  "];
    [SQL appendString:@" , catalog nvarchar(4000) NULL  "];
    
    [SQL appendString:@" , status integer NULL  "];
    [SQL appendString:@" , syncDate datetime NULL  "];
    [SQL appendString:@" , addDate datetime NULL  "];
    
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE BookImages "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   BookImageID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , bookID integer NULL "];
    [SQL appendString:@" , small nvarchar(1000) NULL "];
    [SQL appendString:@" , medium nvarchar(1000) NULL "];
    [SQL appendString:@" , large nvarchar(1000) NULL "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE BookRatings "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   BookRatingID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , bookID integer NULL "];
    [SQL appendString:@" , max integer NULL DEFAULT(0) "];
    [SQL appendString:@" , min integer NULL DEFAULT(0) "];
    [SQL appendString:@" , numRaters integer NULL DEFAULT(0) "];
    [SQL appendString:@" , average REAL NULL "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE BookAuthors "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   BookAuthorID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , bookID integer NULL "];
    [SQL appendString:@" , author nvarchar(1000) NULL "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE BookTranslators "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   BookTranslatorID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , bookID integer NULL "];
    [SQL appendString:@" , translator nvarchar(1000) NULL "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE BookTags "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   BookTagID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , bookID integer NULL "];
    [SQL appendString:@" , count integer NULL DEFAULT(0) "];
    [SQL appendString:@" , name nvarchar(1000) NULL "];
    [SQL appendString:@" , title nvarchar(1000) NULL "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE BookSettings "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   SettingID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , SettingName nvarchar(4000) NOT NULL  "];
    [SQL appendString:@" , Setting nvarchar(4000)  NULL DEFAULT('') "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    complete = [self.myDB commit];
    
    return complete;
}

//如果有更新的话，会更新并返回YES，如果没有更新会直接返回NO
- (BOOL)upgradeDatabase
{
    return NO;
}

- (void)removeDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbPath = [self dbPath];
    if ([fileManager fileExistsAtPath:dbPath]) {
        [fileManager removeItemAtPath:dbPath error:nil];
    }
}

//是否是第一次，如果存在的话，就会直接返回Exists，
- (BOOL)checkDatabase
{
    BOOL result = YES;
    
    if([self isExistsDatabase])
    {
        if([self upgradeDatabase])
        {
            result = YES;
        }
    }
    else
    {
        [self createDatabase];
    }
    return result;
}

#pragma mark Add Info
- (BOOL)insertBooks:(NSString *)isbn keyType:(PABookKeyType)keyType
{
    if (!(keyType == PABookKeyTypeISBN10 || keyType == PABookKeyTypeISBN13)) {
        return NO;
    }
    NSMutableString *SQL = [NSMutableString string];
    
    [SQL setString:@""];
    [SQL appendString:@" INSERT INTO Books( "];
    switch (keyType) {
        case PABookKeyTypeISBN10:
            [SQL appendString:@"isbn10"];
            break;
        case PABookKeyTypeISBN13:
            [SQL appendString:@"isbn13"];
            break;
        default:
            break;
    }
    [SQL appendString:@" , addDate) "];
    [SQL appendString:@" VALUES ("];
    [SQL appendFormat:@" '%@' ", isbn];
    [SQL appendFormat:@" , datetime( 'today', 'localtime') "];
    return [self.myDB executeUpdate:SQL];
}

#pragma mark GetData
- (NSArray *)getBookList
{
    NSMutableArray *result = [NSMutableArray array];
    NSMutableString *SQL = [NSMutableString string];
    
    [SQL setString:@""];
    [SQL appendString:@" SELECT "];
    [SQL appendString:@"   bookID "];
    [SQL appendString:@" , isbn10 "];
    [SQL appendString:@" , isbn13 "];
    [SQL appendString:@" , title "];
    [SQL appendString:@" , image "];
    [SQL appendString:@" FROM Books "];
    [SQL appendString:@" ORDER BY addDate DESC "];
    FMResultSet *rs = [self.myDB executeQuery:SQL];
    while ([rs next]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:[rs stringForColumn:@"bookID"] forKey:@"bookID"];
        [dict setValue:[rs stringForColumn:@"isbn10"] forKey:@"isbn10"];
        [dict setValue:[rs stringForColumn:@"isbn13"] forKey:@"isbn13"];
        [dict setValue:[rs stringForColumn:@"title"] forKey:@"title"];
        [dict setValue:[rs stringForColumn:@"image"] forKey:@"image"];
        [result addObject:dict];
    }
    return result;
}

@end
