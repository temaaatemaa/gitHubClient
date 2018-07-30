//
//  GitHubAutharisation.h
//  
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GitHubAutharisation;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const KeyForToken;

@protocol GitHubAutharisationDelegate

@required
- (void)autharisationDidDone:(GitHubAutharisation *)GitHubAutharisation
                   withToken:(NSString *)token;

@required
- (void)autharisationDidCancel:(GitHubAutharisation *)GitHubAutharisation;

@required
- (void)autharisationError:(GitHubAutharisation *)GitHubAutharisation withError:(NSError *)error;

@end


@interface GitHubAutharisation : NSObject


+ (NSString * _Nullable )token;
/*
    Если пользователь не авторизован то возвращается NULL.
 */

- (void)autharisation;
/*
    По выполнении вызывается один из методов делегата.
 */


- (void)logout;

@property (nonatomic, weak) id <GitHubAutharisationDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
