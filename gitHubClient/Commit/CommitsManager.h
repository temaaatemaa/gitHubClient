//
//  CommitsManager.h
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Commit;
@class CommitsManager;
@class Repo;

NS_ASSUME_NONNULL_BEGIN

@protocol CommitsManagerDelegate

@required
- (void)commitsDidLoad:(CommitsManager *)commitsManager withReposArray:(NSArray <Commit *> *)commitsArray;

@required
- (void)commitsLoadError:(CommitsManager *)commitsManager withError:(NSError *)error;

@end

@interface CommitsManager : NSObject

@property (nonatomic, weak) id<CommitsManagerDelegate> delegate;

- (void)getCommitsForRepo:(Repo *)repo;

@end

NS_ASSUME_NONNULL_END
