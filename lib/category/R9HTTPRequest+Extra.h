//
//  R9HTTPRequest+Extra.h
//  iPadPosDemo
//
//  Created by scubism on 13/06/11.
//
//

#import "R9HTTPRequest.h"

@interface R9HTTPRequest (Extras)

+(void)requestHelperWithURL:(NSURL *)url
                      query:(NSDictionary*)query
             successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
               errorHandler:(void(^)(NSError *err))errorHandler;

+(void)requestHelper:(NSString*)parameter
               query:(NSDictionary*)query
      successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
        errorHandler:(void(^)(NSError *err))errorHandler;

+(void)requestHelperNoComeCheck:(NSString*)parameter
                          query:(NSDictionary*)query
                 successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                   errorHandler:(void(^)(NSError *err))errorHandler;

+(void)requestHelper:(NSString*)parameter
               query:(NSDictionary*)query
           dataImage:(NSData*)dataImage
            fileName:(NSString*)fileName
      successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
        errorHandler:(void(^)(NSError *err))errorHandler;

@end
