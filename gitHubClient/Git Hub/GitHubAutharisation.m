//
//  GitHubAutharisation.m
//
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "GitHubAutharisation.h"
#import <SafariServices/SafariServices.h>

static NSString *const CLIENT_ID = @"2a532f7437dbe162c1e8";
static NSString *const AUTH_GITHUB_URL = @"https://github.com/login/oauth/authorize";
static NSString *const REDIRECT_GITHUB_URL = @"gitHubClient://authorize";
static NSString *const TOKEN_GITHUB_URL = @"https://github.com/login/oauth/access_token";
static NSString *const CLIENT_SECRET = @"7b7a2dbb23e6a94878412455aa37bb37cd20e89f";

static NSUInteger const LENGTH_OF_ACCESS_TOKEN = 40;
NSString *const KeyForToken = @"KeyForToken";



@interface GitHubAutharisation()

@property (nonatomic, strong) SFAuthenticationSession *sessionSF;

@end


@implementation GitHubAutharisation

- (void)autharisation
{
    
    NSString *urlString = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&scope=repo&allow_signup=false",
                           AUTH_GITHUB_URL,
                           CLIENT_ID,
                           REDIRECT_GITHUB_URL];

    NSURL *url = [NSURL URLWithString:urlString];

    void (^comlitionBlock)(NSURL * _Nullable, NSError * _Nullable) = ^(NSURL * _Nullable callbackURL, NSError * _Nullable error){
        NSString *string = [callbackURL absoluteString];
        if (error)
        {
            [self.delegate autharisationError:self withError:error];
            return;
        }
        if (!string)
        {
            [self.delegate autharisationDidCancel:self];
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *code = [string substringFromIndex:[REDIRECT_GITHUB_URL length]+6];
                NSString *accessTokenUrlString = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&code=%@",
                                                  TOKEN_GITHUB_URL,
                                                  CLIENT_ID,
                                                  CLIENT_SECRET,
                                                  code];

                NSURL *tokenURL = [NSURL URLWithString:accessTokenUrlString];

                NSString *accessTokenString = [NSString stringWithContentsOfURL:tokenURL encoding:NSUTF8StringEncoding error:nil];
                
                NSString *accessToken = [accessTokenString substringFromIndex:13];
                accessToken = [accessToken substringToIndex:LENGTH_OF_ACCESS_TOKEN];

                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:accessToken forKey:KeyForToken];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate autharisationDidDone:self withToken:accessToken];
                });
            });
        }
    };
    self.sessionSF = [[SFAuthenticationSession alloc]initWithURL:url callbackURLScheme:REDIRECT_GITHUB_URL completionHandler:comlitionBlock];
    [self.sessionSF start];
}

+ (NSString *)token
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:KeyForToken];
}

- (void)logout
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:KeyForToken];
}

@end
