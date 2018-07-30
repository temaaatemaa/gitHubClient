//
//  CommitsViewController.h
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Repo;

NS_ASSUME_NONNULL_BEGIN

@interface CommitsViewController : UIViewController

@property (nonatomic, strong) Repo *choosenRepo;

@end

NS_ASSUME_NONNULL_END
