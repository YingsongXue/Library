//
//  PALibraryDAL.m
//  Library
//
//  Created by 薛 迎松 on 14/12/25.
//  Copyright (c) 2014年 薛 迎松. All rights reserved.
//

#import "PALibraryDAL.h"
#import "PALibraryDAO.h"
#import "PANetworkService.h"

@interface PALibraryDAL ()
    <PALibraryDelegate>
@property (nonatomic, retain) PANetworkService *networkService;
@end

@implementation PALibraryDAL

- (void)Log:(NSString *)isbn
{
    PALibraryDAO *myDAO = [[PALibraryDAO alloc] init];
    [myDAO checkDatabase];
    [myDAO release];
    
    [self.networkService netGetInfoISBN:isbn];
}

- (void)successOf:(id)data type:(PALibraryRequestType)type
{
    NSLog(@"%@",data);
}

- (void)failedOf:(ASINetworkErrorType )error type:(PALibraryRequestType)type
{
    NSLog(@"failed");
}


#pragma mark Initial

static PALibraryDAL *_sharedInstance = nil;

- (instancetype )init
{
    if (self = [super init]) {
        self.networkService = [[[PANetworkService alloc] init] autorelease];
        self.networkService.delegate = self;
    }
    return self;
}

+ (instancetype )sharedIntance
{
    @synchronized(self)
    {
        if(nil == _sharedInstance)
        {
            _sharedInstance = [[super allocWithZone:nil] init];
        }
    }
    return _sharedInstance;
}

+ (instancetype)allocWithZone:(NSZone *)zone
{
    return [[self sharedIntance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

@end
