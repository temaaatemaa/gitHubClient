//
//  Commit.h
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Commit : NSObject

@property (nonatomic, copy) NSString *commitHash;
@property (nonatomic, copy) NSString *commitMessage;
@property (nonatomic, copy) NSString *commitAuthor;
@property (nonatomic, copy) NSString *commitDate;

@end

NS_ASSUME_NONNULL_END
