//
//  R9HTTPRequest+Extra.m
//  iPadPosDemo
//
//  Created by scubism on 13/06/11.
//
//

#import "R9HTTPRequest+Extra.h"
#import "NSString+Extra.h"

@implementation R9HTTPRequest (Extras)

+(void)requestHelperWithURL:(NSURL *)url
                      query:(NSDictionary*)query
                  dataImage:(NSData*)dataImage
                   fileName:(NSString*)fileName
             successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
               errorHandler:(void(^)(NSError *err))errorHandler;
{
    R9HTTPRequest *request = [[R9HTTPRequest alloc] initWithURL:url];

    DebugLog(@"%@", url);
    [request setRequestKey:@"request"];
    
    [request setHTTPMethod:@"POST"];
    for(NSString *key in [query allKeys]){
//        if([query[key] isKindOfClass:[NSString class]]){
//            [request addBody:[query[key] encodeURIComponentByEncoding:NSUTF8StringEncoding] forKey:key];
//        }
//        else{
            [request addBody:query[key] forKey:key];
//        }
    }
    if(dataImage && fileName){
        [request setData:dataImage withFileName:fileName andContentType:@"png" forKey:@"board_image"];
    }
    DebugLog(@"%@", query);
    
    void (^aSuccessHandler)(NSURLResponse *aResp, NSString *aResponseString) = ^(NSURLResponse *aResp, NSString *aResponseString){
        id data;
        if(aResponseString){
            data = [NSJSONSerialization JSONObjectWithData:[aResponseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//            DebugLog(@"%@", data);
        }
        if([data[@"result"] isEqualToString:@"TIMEOUT"]){
            if([SVProgressHUD isVisible]) [SVProgressHUD dismiss];
//            [_app launchApplication:NO];
            [_app openLoginView];
            return;
        }
        if(successHandler) successHandler(aResp, data);
    };
    [request setCompletionHandler:aSuccessHandler];
    
    void (^aErrorHandler)(NSError *aErr) = ^(NSError *aErr){
        DebugLog(@"%@", aErr);
        if(errorHandler) errorHandler(aErr);
    };
    [request setFailedHandler:aErrorHandler];
    
    if ([request startRequest] == NO) {
    }
}

+(void)requestHelperWithURL:(NSURL *)url
                      query:(NSDictionary*)query
             successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
               errorHandler:(void(^)(NSError *err))errorHandler;
{
    [[XMDataManager sharedManager] requestUseComeCheck:^(id data) {
        [self requestHelperWithURL:url query:query dataImage:nil fileName:nil successHandler:successHandler errorHandler:errorHandler];
    } error:^(NSError *err) {
        if(errorHandler) errorHandler(err);
    }];
}

+(void)requestHelper:(NSString*)parameter
               query:(NSDictionary*)query
      successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
        errorHandler:(void(^)(NSError *err))errorHandler;
{
    NSURL *apiURL = [NSURL URLWithString:[API_URL stringByAppendingString:parameter]];
    [self requestHelperWithURL:apiURL query:query successHandler:successHandler errorHandler:errorHandler];
}

+(void)requestHelperNoComeCheck:(NSString*)parameter
                          query:(NSDictionary*)query
                 successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                   errorHandler:(void(^)(NSError *err))errorHandler;
{
    NSURL *apiURL = [NSURL URLWithString:[API_URL stringByAppendingString:parameter]];
    [self requestHelperWithURL:apiURL query:query dataImage:nil fileName:nil successHandler:successHandler errorHandler:errorHandler];
}

+(void)requestHelper:(NSString*)parameter
               query:(NSDictionary*)query
           dataImage:(NSData*)dataImage
            fileName:(NSString*)fileName
      successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
        errorHandler:(void(^)(NSError *err))errorHandler;
{
    [[XMDataManager sharedManager] requestUseComeCheck:^(id data) {
        NSURL *apiURL = [NSURL URLWithString:[API_URL stringByAppendingString:parameter]];
        [self requestHelperWithURL:apiURL query:query dataImage:dataImage fileName:fileName successHandler:successHandler errorHandler:errorHandler];
    } error:^(NSError *err) {
        if(errorHandler) errorHandler(err);
    }];
}

@end
