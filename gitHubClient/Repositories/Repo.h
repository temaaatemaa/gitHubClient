//
//  Repo.h
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Repo : NSObject

@property (nonatomic, strong) NSNumber *repoID;
@property (nonatomic, copy) NSString *repoName;
@property (nonatomic, copy) NSString *repoDescription;
@property (nonatomic, copy) NSString *repoOwnerLogin;
@property (nonatomic, copy) NSString *repoOwnerAvatarUrlString;
@property (nonatomic, strong) NSNumber *repoForksCount;
@property (nonatomic, strong) NSNumber *repoWatchersCount;


@end

NS_ASSUME_NONNULL_END
