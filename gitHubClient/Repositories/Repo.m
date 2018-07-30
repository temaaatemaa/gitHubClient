//
//  Repo.m
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "Repo.h"

@implementation Repo

- (NSString *)repoDescription
{
    if ([_repoDescription isKindOfClass: [NSNull class]])
    {
        _repoDescription = @"No description";
    }
    return _repoDescription;
}

@end
