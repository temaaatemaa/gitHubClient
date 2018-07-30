//
//  CommitsTableViewCell.h
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Commit;

NS_ASSUME_NONNULL_BEGIN

@interface CommitsTableViewCell : UITableViewCell

- (void)setupForCommit:(Commit *)commit;

@end

NS_ASSUME_NONNULL_END
