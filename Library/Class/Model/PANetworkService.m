//
//  PANetworkService.m
//  Library
//
//  Created by 薛 迎松 on 14/12/25.
//  Copyright (c) 2014年 薛 迎松. All rights reserved.
//

#import "PANetworkService.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "JSONKit.h"

const NSString *kDomain = @"api.douban.com";
const NSString *kVersion = @"v2";
const NSString *kCategory = @"book";
const NSString *kOperation = @"isbn";

@interface PANetworkService ()
@property (nonatomic, retain) ASINetworkQueue *queue;
@end

@implementation PANetworkService

- (void)dealloc
{
    [_queue cancelAllOperations];
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.queue = [ASINetworkQueue queue];
        [self.queue setDelegate:self];
        [self.queue setDownloadProgressDelegate:self];
        [self.queue setShouldCancelAllRequestsOnFailure:NO];
    }
    return self;
}

- (NSURL *)urlWithSub:(NSString *)sub
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@/%@/%@/%@",
                           /* DISABLES CODE */ (YES) ? @"https" : @"http",
                           kDomain,
                           kVersion,
                           kCategory,
                           sub];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSURL URLWithString:urlString];
}

- (void)requestWithURL:(NSURL *)url action:(PALibraryRequestType )type
{
    [ASIFormDataRequest clearSession];
    [ASIFormDataRequest setSessionCookies:nil];
    
    ASIFormDataRequest *httpRequest = [ASIFormDataRequest requestWithURL:url];
//    for (NSString *key in dict)
//    {
//        [httpRequest setPostValue:[dict objectForKey:key] forKey:key];
//    }
    [httpRequest setCachePolicy:ASIDoNotReadFromCacheCachePolicy | ASIDoNotWriteToCacheCachePolicy];
    httpRequest.delegate = self;
    httpRequest.tag = type;
    [httpRequest setTimeOutSeconds:30.0];
    [self.queue addOperation:httpRequest];
    
    if([self.queue requestsCount])
    {
        [self.queue go];
    }
}

- (void)netGetInfoISBN:(NSString *)isbn
{
    NSURL *url = [self urlWithSub:[NSString stringWithFormat:@"isbn/%@",isbn]];
    [self requestWithURL:url action:PALibraryRequestTypeISBN];
}
#pragma mark Request Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    id data = [self decodeOfData:request.responseData];
    if([self.delegate respondsToSelector:@selector(successOf:type:)])
    {
        [self.delegate successOf:data type:request.tag];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if([self.delegate respondsToSelector:@selector(failedOf:type:)])
    {
        [self.delegate failedOf:ASIRequestTimedOutErrorType type:request.tag];
    }
}

- (id)decodeOfData:(NSData *)result
{
    id re = [result objectFromJSONDataWithParseOptions: JKParseOptionValidFlags];
    return re;
}

- (void)cancelAllOperation
{
    [self.queue cancelAllOperations];
}

@end
