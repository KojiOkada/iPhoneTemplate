//
//  R9HTTPRequest.m
//  PadDemo2
//
//  Created by LunaSun on 12/08/06.
//
//

#import "R9HTTPRequest.h"
#import "Reachability.h"

static NSString *boundary = @"----------0xKhTmLbOuNdArY";

@interface R9HTTPRequest(private)

- (NSData *)createMultipartBodyData;
- (NSData *)createBodyData;
- (void)finish;

@end

@implementation R9HTTPRequest {
    NSURL *_url;
    NSTimeInterval _timeoutSeconds;
    NSHTTPURLResponse *_responseHeader;
    NSMutableData *_responseData;
    NSMutableDictionary *_headers;
    NSMutableDictionary *_bodies;
    NSMutableDictionary *_fileInfo;
    NSOperationQueue *_queue;
    BOOL _isExecuting, _isFinished;
}

@synthesize completionHandler = _completionHandler;
@synthesize uploadProgressHandler = _uploadProgressHandler;
@synthesize failedHandler = _failedHandler;
@synthesize HTTPMethod = _HTTPMethod;
@synthesize shouldRedirect = _shouldRedirect;

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
    if ([key isEqualToString:@"isExecuting"] ||
        [key isEqualToString:@"isFinished"]) {
        return YES;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (BOOL)isFinished
{
    return _isFinished;
}

- (id)initWithURL:(NSURL *)targetUrl
{
    self = [super init];
    if (self) {
        _url = targetUrl;
        _timeoutSeconds = 0;
        _headers = [[NSMutableDictionary alloc] init];
        _bodies = [[NSMutableDictionary alloc] init];
        _fileInfo = [[NSMutableDictionary alloc] init];
        _shouldRedirect = YES;
        _HTTPMethod = @"GET";
    }
    return self;
}

- (BOOL)startRequest
{
    // 通信開始時に通信可能か判断し、通信可能な場合のみ通信処理を行う
    Reachability *curReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通信エラー" message:@"通信が可能な状態か確認してください。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        //DebugLog(@"%d", self.failedHandler);
        if (self.failedHandler) {
            self.failedHandler(nil);
        }
        
        return NO;
    }
    else {
        _queue = [[NSOperationQueue alloc] init];
        [_queue addOperation:self];
    }
    
    return YES;
}

- (void)start
{
//    DebugLog(@"exclusive:%d",_isExclusive)
//    DebugLog(@"RequestKey:%@",_requestKey)
//    if([self searchWithKey:_requestKey] && _isExclusive){
//        DebugLog(@"重複リクエストのため削除")
//        return;
//    }
    [self setValue:[NSNumber numberWithBool:YES] forKey:@"isExecuting"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
    if ([_headers count] > 0) {
        [request setAllHTTPHeaderFields:_headers];
    }
    [request setHTTPMethod:self.HTTPMethod];
    if ([_fileInfo count] > 0) {
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[self createMultipartBodyData]];
    } else {
        [request setHTTPBody:[self createBodyData]];
    }
    if (_timeoutSeconds > 60) {
        [request setTimeoutInterval:_timeoutSeconds];
    }
    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
    if (conn != nil) {
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (_isExecuting);
    }
}

- (void)setTimeoutInterval:(NSTimeInterval)seconds
{
    NSAssert(seconds > 60, @"TimeoutInterval must be greater than 60 seconds.");
    _timeoutSeconds = seconds;
}

- (void)addHeader:(NSString *)value forKey:(NSString *)key
{
    [_headers setObject:value forKey:key];
}

- (void)addBody:(NSString *)value forKey:(NSString *)key
{
    [_bodies setObject:value forKey:key];
}

- (void)setData:(NSData *)data withFileName:(NSString *)fileName andContentType:(NSString *)contentType forKey:(NSString *)key
{
	[_fileInfo setValue:key forKey:@"key"];
	[_fileInfo setValue:fileName forKey:@"fileName"];
	[_fileInfo setValue:contentType forKey:@"contentType"];
	[_fileInfo setValue:data forKey:@"data"];
}

#pragma mark - Private methods

- (NSData *)createMultipartBodyData
{
    NSMutableString *bodyString = [NSMutableString string];
    [bodyString appendFormat:@"--%@\r\n",boundary ];
    [_bodies enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
        [bodyString appendFormat:@"%@", obj];
        [bodyString appendFormat:@"\r\n--%@\r\n",boundary];
    }];
    [bodyString appendFormat:@"Content-Disposition: form-data; name=\"%@\";"
     @" filename=\"%@\"\r\n", [_fileInfo objectForKey:@"key"], [_fileInfo objectForKey:@"fileName"]];
    [bodyString appendFormat:@"Content-Type: %@\r\n\r\n", [_fileInfo objectForKey:@"contentType"]];
    NSMutableData *bodyData = [NSMutableData data];
    [bodyData appendData:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [bodyData appendData:[_fileInfo objectForKey:@"data"]];
    [bodyData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return bodyData;
}

- (NSData *)createBodyData
{
    NSMutableString *content = [NSMutableString string];
    [_bodies enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (![content isEqualToString:@""]) {
            [content appendString:@"&"];
        }
        if (![key isEqualToString:@""]) {
            //[content appendFormat:[NSString stringWithFormat:@"%@=%@", key, obj]];
            [content appendString:[NSString stringWithFormat:@"%@=%@", key, obj]];
        } else {
            [content appendString:obj];
        }
    }];
    return [content dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - NSURLConnectionDelegate and NSURLConnectionDataDelegate methods

// リダイレクトの処理
- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if (response && self.shouldRedirect == NO) {
        return nil;
    }
    return request;
}

// レスポンスヘッダの受け取り
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseHeader = [(NSHTTPURLResponse *)response copy];
    _responseData = [[NSMutableData alloc] init];
}

// データの受け取り
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

// Progress
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (totalBytesExpectedToWrite == 0) return;
    if (self.uploadProgressHandler) {
        float progress = [[NSNumber numberWithInteger:totalBytesWritten] floatValue];
        float total = [[NSNumber numberWithInteger: totalBytesExpectedToWrite] floatValue];
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [queue addOperationWithBlock:^{
            self.uploadProgressHandler(progress / total);
        }];
    }
}

// 通信エラー
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self setCompletionBlock:^{
        //NSError *error;
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [queue addOperationWithBlock:^{
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:@"通信エラーが発生しました" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }];
    }];
    [self finish];
}

// 通信終了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    __weak NSData *responseData = _responseData;
    __weak NSHTTPURLResponse *responseHeader = _responseHeader;
    [self setCompletionBlock:^{
        // Run on main thread.
        NSOperationQueue *queue = [NSOperationQueue mainQueue];
        [queue addOperationWithBlock:^{
            NSString *responseString = nil;
            if (responseData) {
                responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            }
            //NSLog(@"is main thread:%d", [[NSThread currentThread] isMainThread]);
            self.completionHandler(responseHeader, responseString);
        }];
    }];
    [self finish];
}

- (void)finish
{
    [self setValue:[NSNumber numberWithBool:NO] forKey:@"isExecuting"];
    [self setValue:[NSNumber numberWithBool:YES] forKey:@"isFinished"];
}

-(void)cancelWithKey:(NSString*)key{
    DebugLog(@"cancelKey:%@",key)
    for(R9HTTPRequest *kOperation in [_queue operations]){
        if([kOperation isExecuting]==YES){
            if([[kOperation requestKey]isEqualToString:key]){
                [kOperation cancel];
            }
        }
    }
}

-(BOOL)searchWithKey:(NSString*)key{

    int count = 0;
    for(R9HTTPRequest *kOperation in [_queue operations]){
        DebugLog(@"exe:%d finish:%d key:%@",[kOperation isExclusive],[kOperation isFinished],[kOperation requestKey])
        if(![kOperation isExecuting] && ![kOperation isFinished]){
            if([[kOperation requestKey]isEqualToString:key]){
                    count++;
            }
        }
    }
    
    
    return NO;
}
@end