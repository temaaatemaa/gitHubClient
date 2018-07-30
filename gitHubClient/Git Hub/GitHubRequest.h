//
//  GitHubRequest.h
//
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GitHubRequest : NSObject

- (void)requestForMethodName:(NSString *)methodName withParametrs:(NSDictionary *)parametrs withComplitionBlock:(nullable void (^)(id _Nullable responseObject))complitionBlock withFailureBlock:(nullable void (^)(id _Nullable error))failureBlock;

@end

NS_ASSUME_NONNULL_END
