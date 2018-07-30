//
//  ReposManager.m
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "ReposManager.h"
#import "GitHubRequest.h"
#import "Repo.h"

@interface ReposManager()

@property (nonatomic, strong) GitHubRequest *gitHubRequest;

@end

@implementation ReposManager

- (GitHubRequest *)gitHubRequest
{
    if (!_gitHubRequest)
    {
        _gitHubRequest = [GitHubRequest new];
    }
    return _gitHubRequest;
}

- (void)getRepos
{
    NSString *methodName = @"user/repos";
    
    [self.gitHubRequest requestForMethodName:methodName withParametrs:@{} withComplitionBlock:^(id  _Nullable responseObject) {
        NSArray *posts = [ReposManager parseResponseToReposArray:responseObject];
        [self.delegate reposDidLoad:self withReposArray:posts];
    } withFailureBlock:^(id  _Nullable error) {
        [self.delegate reposLoadError:self withError:error];
    }];
}

+ (NSArray <Repo *> *)parseResponseToReposArray:(NSArray *)response
{
    NSLog(@"%@", response);
    NSMutableArray *reposMutableArray = [NSMutableArray new];
    for (NSDictionary *repoInfo in response)
    {
        Repo *repo = [Repo new];
        repo.repoID = repoInfo[@"id"];
        repo.repoName = repoInfo[@"name"];
        repo.repoDescription = repoInfo[@"description"];
        repo.repoOwnerLogin = repoInfo[@"owner"][@"login"];
        repo.repoOwnerAvatarUrlString = repoInfo[@"owner"][@"avatar_url"];
        repo.repoForksCount = repoInfo[@"forks_count"];
        repo.repoWatchersCount = repoInfo[@"watchers_count"];
        
        [reposMutableArray addObject:repo];
    }
    return [reposMutableArray copy];
}
@end
