//
//  CommitsManager.m
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "CommitsManager.h"
#import "GitHubRequest.h"
#import "Repo.h"
#import "Commit.h"

@interface CommitsManager()

@property (nonatomic, strong) GitHubRequest *gitHubRequest;

@end

@implementation CommitsManager

- (GitHubRequest *)gitHubRequest
{
    if (!_gitHubRequest)
    {
        _gitHubRequest = [GitHubRequest new];
    }
    return _gitHubRequest;
}

- (void)getCommitsForRepo:(Repo *)repo
{
    NSString *methodName = @"repos";
    methodName = [NSString stringWithFormat:@"%@/%@/%@/commits", methodName, repo.repoOwnerLogin, repo.repoName];
    
    [self.gitHubRequest requestForMethodName:methodName withParametrs:@{} withComplitionBlock:^(id  _Nullable responseObject) {
        NSArray *commitsArray = [CommitsManager parseResponseToCommitsArray:responseObject];
        [self.delegate commitsDidLoad:self withReposArray:commitsArray];
    }withFailureBlock:^(id  _Nullable error) {
        [self.delegate commitsLoadError:self withError:error];
    }];
}

+ (NSArray <Commit *> *)parseResponseToCommitsArray:(NSArray *)response
{
    NSMutableArray *commitMutableArray = [NSMutableArray new];
    for (NSDictionary *commitInfo in response)
    {
        Commit *commit = [Commit new];
        commit.commitHash = commitInfo[@"sha"];
        commit.commitMessage = commitInfo[@"commit"][@"message"];
        commit.commitAuthor = commitInfo[@"commit"][@"author"][@"name"];
        commit.commitDate = commitInfo[@"commit"][@"author"][@"date"];
        
        [commitMutableArray addObject:commit];
    }
    return [commitMutableArray copy];
}

@end
