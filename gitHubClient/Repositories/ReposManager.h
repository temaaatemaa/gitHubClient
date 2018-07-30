//
//  ReposManager.h
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ReposManager;
@class Repo;

NS_ASSUME_NONNULL_BEGIN

@protocol ReposManagerDelegate

@required
- (void)reposDidLoad:(ReposManager *)reposManager withReposArray:(NSArray <Repo *> *)reposArray;

@required
- (void)reposLoadError:(ReposManager *)reposManager withError:(NSError *)error;

@end


@interface ReposManager : NSObject

@property (nonatomic, weak) id<ReposManagerDelegate> delegate;

- (void)getRepos;


@end

NS_ASSUME_NONNULL_END
