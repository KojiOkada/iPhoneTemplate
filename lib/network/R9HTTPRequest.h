//
//  R9HTTPRequest.h
//  PadDemo2
//
//  Created by LunaSun on 12/08/06.
//
//

#import <Foundation/Foundation.h>

typedef void(^CompletionHandler)(NSHTTPURLResponse *responseHeader, NSString *responseString);
typedef void(^UploadProgressHandler)(float newProgress);
typedef void(^FailedHandler)(NSError *error);

@interface R9HTTPRequest : NSOperation <NSURLConnectionDataDelegate>

@property (copy, nonatomic) CompletionHandler completionHandler;
@property (copy, nonatomic) FailedHandler failedHandler;
@property (copy, nonatomic) UploadProgressHandler uploadProgressHandler;
@property (strong, nonatomic) NSString *HTTPMethod;
@property (nonatomic, getter = isShouldRedirect) BOOL shouldRedirect;
@property (nonatomic,strong) NSString *requestKey;
@property (nonatomic,assign) BOOL isExclusive;

- (id)initWithURL:(NSURL *)targetUrl;

- (void)addHeader:(id)value forKey:(NSString *)key;

- (void)addBody:(NSString *)value forKey:(NSString *)key;

- (void)setData:(NSData *)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key;

/* TimeoutInterval must be greater than 240 seconds. */
- (void)setTimeoutInterval:(NSTimeInterval)seconds;

- (BOOL)startRequest;
-(void)cancelWithKey:(NSString*)key;
-(BOOL)searchWithKey:(NSString*)key;
@end