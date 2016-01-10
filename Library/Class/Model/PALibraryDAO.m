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
    [_myDB release];
    
    [super dealloc];
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
            result = [rs boolForColumn:@"Total"];
        }
        [rs close];
    }
    return result;
}

- (BOOL)createDatabase
{
    BOOL complete = NO;
    [self.myDB beginTransaction];
    
    NSMutableString *SQL = [[NSMutableString alloc] init];
    //UGMLocations
    /* {
     "UGMLocationID": "1",
     "Location": "Fort Collins Hilton",
     "Address": "425 W Prospect Rd Fort Collins CO 80526",
     "Longitude": "-105.082617",
     "Latitude": "40.566082",
     "Phone": "9704822626"
     },
     */
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE UGMLocations "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   UGMLocationID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , Location nvarchar(255) NOT NULL "];
    [SQL appendString:@" , Address nvarchar(255)  "];
    [SQL appendString:@" , Longitude nvarchar(50)  "]; //maybe double
    [SQL appendString:@" , Latitude nvarchar(50)  "];
    [SQL appendString:@" , Phone nvarchar(50)  "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    /*
     UGMEvents
     "UGMEventID": "1",
     "EventTitle": "Welcome Reception",
     "Session": "Session 1",
     "EventType": "Welcome Reception",
     "UGMLocationID": "3",
     "Room": "",
     "Description": "Join us for informal<br />conversata",
     "StartTime": "2015/6/8 6:00:00",
     "EndTime": "2015/6/8 9:00:00",
     "DocumentID": "7507",
     "EncompassOnly": "0",
     "KnowledgeID": "35751"
     */
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE UGMEvents "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   UGMEventID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , EventTitle nvarchar(255) NOT NULL "];
    [SQL appendString:@" , Session nvarchar(50) NOT NULL "];
    [SQL appendString:@" , EventType nvarchar(50) NOT NULL "];
    [SQL appendString:@" , UGMLocationID integer "];
    [SQL appendString:@" , Room nvarchar(30) NOT NULL "];
    [SQL appendString:@" , Description nvarchar(4000) "];
    [SQL appendString:@" , StartTime datetime "];
    [SQL appendString:@" , EndTime datetime "];
    [SQL appendString:@" , DocumentID integer  "];
    [SQL appendString:@" , EncompassOnly tinyint NOT NULL DEFAULT(0) "];
    [SQL appendString:@" , KnowledgeID integer  "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    /*UGMEventCustomers
     "UGMEventCustomerID": "1",
     "UGMEventID": "1",
     "CustomerID": "304"
     */
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE UGMEventCustomers "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   UGMEventCustomerID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , UGMEventID integer "];
    [SQL appendString:@" , CustomerID integer  "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    /*
     UGMEventSpeakers
     "UGMEventSpeakerID": "1",
     "UGMEventID": "1",
     "UserID": "5"
     */
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE UGMEventSpeakers "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   UGMEventSpeakerID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , UGMEventID integer "];
    [SQL appendString:@" , UserID integer  "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    /*
     UGMSponsors
     "UGMSponsorID": "1",
     "SponsorName": "Pateros Creek Brewing Co.",
     "Description": "Pateros Creek Brewing (pronounced Puh-Tare-Ohs) got its name from the iconic Cache la Poudre River that runs through the City of Fort Collins and throughout Northern Colorado.",
     "UGMLocationID": "4",
     "DocumentID": "35752",
     "Link": "http://www.pateroscreekbrewing.com/"
     */
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE UGMSponsors "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   UGMSponsorID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , SponsorName nvarchar(50) NOT NULL "];
    [SQL appendString:@" , Description nvarchar(255)  "];
    [SQL appendString:@" , UGMLocationID integer "];
    [SQL appendString:@" , DocumentID integer  "];
    [SQL appendString:@" , Link nvarchar(255) "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    /*
     Documents
     "DocumentID": "35752",
     "FileName": "Pateros creek.jpg",
     "DocumentType": "",
     "FileType": "jpg",
     "CustomerID":"",
     "SubDir": "Images",
     "Token": "eebcae221e7fb9235a79e2d026c1dc22"
     */
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE Documents "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   DocumentID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , FileName nvarchar(300) NOT NULL "];
    [SQL appendString:@" , DocumentType nvarchar(50)  "];
    [SQL appendString:@" , FileType nvarchar(12) "];
    [SQL appendString:@" , SubDir nvarchar(50)  "];
    [SQL appendString:@" , Token nvarchar(50) "];
    [SQL appendString:@" , CustomerID integer "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    /*
     Users
     "UserID": "5",
     "UserName": "Cody",
     "Name": "Cody Henry",
     "UserTypeID": "1",
     "Role": "UGM",
     "Profile": "",
     "UserPic": "../Users/Pioneer1501/UGMPictures/5.jpg?1427966377435",
     "Phone": "4660412"
     */
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE Users "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   UserID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , UserName nvarchar(12) UNIQUE NOT NULL "];
    [SQL appendString:@" , Name nvarchar(50) NOT NULL "];
    [SQL appendString:@" , UserTypeID integer NOT NULL "];
    [SQL appendString:@" , Role nvarchar(50)  "];
    [SQL appendString:@" , LocationID integer NOT NULL "];
    [SQL appendString:@" , Profile nvarchar(4000) "];
    [SQL appendString:@" , Department nvarchar(50) "];
    [SQL appendString:@" , UserPic nvarchar(50) "];
    [SQL appendString:@" , Phone nvarchar(50) "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    /*   Customers
     "CustomerID": "304",
     "Company": "LOOP BREWERY",
     "ShortName": "LOOPBREW",
     "CustomerTypeID": "32"*/
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE Customers "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   CustomerID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , Company nvarchar(50) NOT NULL "];
    [SQL appendString:@" , ShortName nvarchar(12) UNIQUE NOT NULL "];
    [SQL appendString:@" , CustomerTypeID integer NOT NULL "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    /*
     CustomersUsers
     "ID": "88",
     "CustomerID": "1001",
     "UserID": "305"
     */
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE CustomersUsers "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   ID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , CustomerID integer NOT NULL "];
    [SQL appendString:@" , UserID integer NOT NULL "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    /*DeleteRecords*/
    /*SyncDate*/
    [SQL setString:@""];
    [SQL appendString:@"CREATE TABLE UGMSettings "];
    [SQL appendString:@" ( "];
    [SQL appendString:@"   SettingID integer PRIMARY KEY AUTOINCREMENT "];
    [SQL appendString:@" , SyncDate nvarchar(50) NOT NULL DEFAULT('') "];
    [SQL appendString:@" , Version nvarchar(50) NOT NULL DEFAULT(0) "];
    [SQL appendString:@" ) "];
    [self.myDB executeUpdate:SQL];
    
    complete = [self.myDB commit];
    
    [SQL release];
    
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


@end
