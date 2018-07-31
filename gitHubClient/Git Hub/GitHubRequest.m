//
//  VKRequest.m
//  diasoft
//
//  Created by Artem Zabludovsky on 25.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "GitHubRequest.h"
#import "GitHubAutharisation.h"
#import <AFNetworking.h>

@interface GitHubRequest()

@property (nonatomic, copy) NSString *token;

@end


@implementation GitHubRequest

- (NSString *)token
{
    if (!_token)
    {
        _token = [GitHubAutharisation token];
    }
    return _token;
}

- (void)requestForMethodName:(NSString *)methodName withParametrs:(NSDictionary *)parametrs withComplitionBlock:(nullable void (^)(id _Nullable responseObject))complitionBlock withFailureBlock:(nullable void (^)(id _Nullable))failureBlock
{
    
    if (!self.token)
    {
        return;
    }
    NSString *requestURL = [@"https://api.github.com/" stringByAppendingString:methodName];
    
    NSMutableDictionary *paramsWithToken = [NSMutableDictionary dictionaryWithDictionary:parametrs];
    paramsWithToken[@"access_token"] = self.token;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:requestURL parameters:[paramsWithToken copy]
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             complitionBlock(responseObject);
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             failureBlock(error);
         }];
}
@end
