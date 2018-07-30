//
//  CommitsTableViewCell.m
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "CommitsTableViewCell.h"
#import "Commit.h"
#import <Masonry.h>


static CGFloat const MAIN_OFFSET = 10;
@interface CommitsTableViewCell()

@property (nonatomic, strong) UILabel *commitHashLabel;
@property (nonatomic, strong) UILabel *commitMessageLabel;
@property (nonatomic, strong) UILabel *commitAuthorLabel;
@property (nonatomic, strong) UILabel *commitDateLabel;

@end

@implementation CommitsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _commitHashLabel = [UILabel new];
        [self.contentView addSubview:_commitHashLabel];
        
        _commitMessageLabel = [UILabel new];
        [self.contentView addSubview:_commitMessageLabel];
        
        _commitAuthorLabel = [UILabel new];
        [self.contentView addSubview:_commitAuthorLabel];
        
        _commitDateLabel = [UILabel new];
        [self.contentView addSubview:_commitDateLabel];
        
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    [_commitAuthorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(MAIN_OFFSET);
        make.left.equalTo(self.contentView).with.offset(MAIN_OFFSET);
        make.right.equalTo(self.contentView).with.offset(-MAIN_OFFSET);
    }];
    
    [_commitHashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commitAuthorLabel.mas_bottom).with.offset(MAIN_OFFSET);
        make.left.equalTo(self.contentView).with.offset(MAIN_OFFSET);
        make.right.equalTo(self.contentView).with.offset(-MAIN_OFFSET);
    }];
    
    [_commitMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commitHashLabel.mas_bottom).with.offset(MAIN_OFFSET);
        make.left.equalTo(self.contentView).with.offset(MAIN_OFFSET);
        make.right.equalTo(self.contentView).with.offset(-MAIN_OFFSET);
    }];
    
    [_commitDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commitMessageLabel.mas_bottom).with.offset(MAIN_OFFSET);
        make.left.equalTo(self.contentView).with.offset(MAIN_OFFSET);
        make.right.equalTo(self.contentView).with.offset(-MAIN_OFFSET);
        make.bottom.equalTo(self.contentView).with.offset(-MAIN_OFFSET);
    }];
    [super updateConstraints];
}

- (void)setupForCommit:(Commit *)commit
{
    self.commitHashLabel.text = [@"Hash: " stringByAppendingString:commit.commitHash];
    self.commitAuthorLabel.text = commit.commitAuthor;
    self.commitDateLabel.text = commit.commitDate;
    self.commitMessageLabel.text = commit.commitMessage;
    
    self.commitMessageLabel.numberOfLines = 0;
    self.commitDateLabel.textAlignment = NSTextAlignmentRight;
    
    self.commitAuthorLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightRegular];
    self.commitHashLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    self.commitDateLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
}
@end
