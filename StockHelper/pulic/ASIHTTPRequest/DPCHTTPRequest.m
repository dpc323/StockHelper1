//
//  DPCHTTPRequest.m
//  RobotClient
//
//  Created by dpc on 16/3/31.
//  Copyright © 2016年 dpc. All rights reserved.
//

#import "DPCHTTPRequest.h"

#define REQUEST_POST @"POST"

@implementation DPCHTTPRequest

-(void)dealloc
{
    [self clearBlock];
}

- (void)clearBlock
{
    if (CompletionBlock)
    {
        CompletionBlock = nil;
    }
    if (FailedErrorBlock)
    {
        FailedErrorBlock = nil;
    }
}

+(instancetype)shareInstance;
{
    static DPCHTTPRequest *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

-(void)getAddByUrlPath:(NSString*)path addParams:(NSString*)params completion:(SuccessBlock)successBlock failedError:(FailBlock)failBlock
{
    [self clearBlock];
    CompletionBlock = [successBlock copy];
    FailedErrorBlock = [failBlock copy];
    self.tag = [params substringWithRange:NSMakeRange(2, 6)];
    
    if (params)
    {
        path = [path stringByAppendingString:[NSString stringWithFormat:@"?%@",params]];
    }
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path]];
    request.tag = [[params substringWithRange:NSMakeRange(2, 6)] intValue];
    [request setRequestMethod:@"GET"];
    [request setValidatesSecureCertificate:NO];//请求为HTTPS时需要设置这个属性
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];//encoding
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)postAddByUrlPath:(NSString*)path addParams:(NSDictionary*)params completion:(SuccessBlock)successBlock failedError:(FailBlock)failBlock;
{
    [self clearBlock];
    CompletionBlock = [successBlock copy];
    FailedErrorBlock = [failBlock copy];
    
    ASIFormDataRequest *request =  [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:path]];
    [request setValidatesSecureCertificate:NO];//请求https的时候，就要设置这个属性
    [request setRequestMethod:REQUEST_POST];
    [request addRequestHeader:@"Accept" value:@"text/html"];
    [request addRequestHeader:@"Content-Type" value:@"text/html;charset=UTF-8"];
    request.delegate = self;

    for (NSDictionary *subDic in params)
    {
        [request setPostValue:[NSString stringWithFormat:@"%@",[params objectForKey:subDic]] forKey:[NSString stringWithFormat:@"%@",subDic]];
        NSLog(@"%@,%@",subDic,[params objectForKey:subDic]);
    }
    
    [request startAsynchronous];
}

- ( void )requestFailed:( ASIHTTPRequest *)request
{
    if (FailedErrorBlock)
    {
        FailedErrorBlock(@"网络连接失败");
    }
}

// 请求结束，获取 Response 数据
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSData *JSONData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
   // NSLog(@"responseString = %@",responseString);
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    
    if (responseDictionary) {
        CompletionBlock(responseDictionary);
    }

    if (!responseDictionary)
    {
        //服务器关闭时
        if ([responseString rangeOfString:@"html"].location != NSNotFound)
        {
            FailedErrorBlock(@"无数据");
            return;
        }
        
        if ([responseString rangeOfString:@"上证指数"].location != NSNotFound) {
            CompletionBlock(responseString);
            return;
        }
        
        NSString *tagStr = [NSString stringWithFormat:@"%ld",request.tag];
        for (int i = 6-(int)tagStr.length; i>0; i--) {
            tagStr = [@"0" stringByAppendingString:tagStr];
        }
        responseDictionary = [NSDictionary dictionaryWithObject:responseString forKey:tagStr];

        CompletionBlock(responseDictionary);
        return;
    }
    
    /*
    if (responseDictionary) 
    {
        CompletionBlock(responseDictionary[@"cloudserver"][0]);
        return;
    }
    */
    
    if (FailedErrorBlock)
    {
        FailedErrorBlock(@"获取数据失败");

    }
}

@end
