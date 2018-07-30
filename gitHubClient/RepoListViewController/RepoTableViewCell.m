//
//  RepoTableViewCell.m
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "RepoTableViewCell.h"
#import "Repo.h"
#import <Masonry.h>
#import "NetworkService.h"
#import "UIImage+Size.h"


static CGFloat const MAIN_OFFSET = 10;
static CGFloat const IMAGE_SIZE = 50;


@interface RepoTableViewCell()

@property (nonatomic, strong) UIImageView *authorAvatarImageView;
@property (nonatomic, strong) UILabel *authorNameLabel;
@property (nonatomic, strong) UILabel *repoNameLabel;
@property (nonatomic, strong) UILabel *descriptionOfRepoLabel;
@property (nonatomic, strong) UILabel *watchersLabel;
@property (nonatomic, strong) UILabel *watchersCountLabel;
@property (nonatomic, strong) UILabel *forksLabel;
@property (nonatomic, strong) UILabel *forksCountLabel;

@end


@implementation RepoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _authorAvatarImageView = [UIImageView new];
        [self.contentView addSubview:_authorAvatarImageView];
        
        _authorNameLabel = [UILabel new];
        [self.contentView addSubview:_authorNameLabel];
        
        _repoNameLabel = [UILabel new];
        [self.contentView addSubview:_repoNameLabel];
        
        _descriptionOfRepoLabel = [UILabel new];
        [self.contentView addSubview:_descriptionOfRepoLabel];
        
        _watchersLabel = [UILabel new];
        [self.contentView addSubview:_watchersLabel];
        
        _watchersCountLabel = [UILabel new];
        [self.contentView addSubview:_watchersCountLabel];
        
        _forksLabel = [UILabel new];
        [self.contentView addSubview:_forksLabel];
        
        _forksCountLabel = [UILabel new];
        [self.contentView addSubview:_forksCountLabel];
        
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    [self.authorAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(IMAGE_SIZE));
        make.height.equalTo(@(IMAGE_SIZE)).with.priorityHigh();
        make.top.equalTo(self.contentView).with.offset(MAIN_OFFSET);
        make.left.equalTo(self.contentView).with.offset(MAIN_OFFSET);
    }];
    
    [self.authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(MAIN_OFFSET);
        make.left.equalTo(self.authorAvatarImageView.mas_right).with.offset(MAIN_OFFSET);
        make.right.equalTo(self.contentView).with.offset(-MAIN_OFFSET);
    }];
    
    [self.repoNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorNameLabel.mas_bottom).with.offset(0);
        make.height.equalTo(self.authorNameLabel);
        make.bottom.equalTo(self.authorAvatarImageView);
        make.left.equalTo(self.authorAvatarImageView.mas_right).with.offset(MAIN_OFFSET);
        make.right.equalTo(self.contentView).with.offset(-MAIN_OFFSET);
    }];
    
    [self.descriptionOfRepoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.authorAvatarImageView.mas_bottom).with.offset(MAIN_OFFSET);
        make.left.equalTo(self.contentView).with.offset(MAIN_OFFSET);
        make.right.equalTo(self.contentView).with.offset(-MAIN_OFFSET);
        make.height.equalTo(@(IMAGE_SIZE)).with.priorityHigh();
    }];
    
    [self.watchersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionOfRepoLabel.mas_bottom).with.offset(MAIN_OFFSET);
        //make.left.equalTo(self.contentView).with.offset(MAIN_OFFSET);
        make.bottom.equalTo(self.contentView).with.offset(-MAIN_OFFSET);
    }];
    
    [self.watchersCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.watchersLabel);
        make.bottom.equalTo(self.watchersLabel);
        make.left.equalTo(self.watchersLabel.mas_right).with.offset(5);
    }];
    
    [self.forksLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.watchersLabel);
        make.bottom.equalTo(self.watchersLabel);
        make.left.equalTo(self.watchersCountLabel.mas_right).with.offset(MAIN_OFFSET);
    }];
    
    [self.forksCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.watchersLabel);
        make.bottom.equalTo(self.watchersLabel);
        make.left.equalTo(self.forksLabel.mas_right).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-MAIN_OFFSET);
    }];
    
    [super updateConstraints];
}

- (void)setupForRepo:(Repo *)repo
{
    NetworkService *service = [NetworkService new];
    
    [service downloadPhotoWithURL:repo.repoOwnerAvatarUrlString withComplitionBlock:^(id  _Nullable image) {
        [UIImage resizeImage:image forSize:CGSizeMake(IMAGE_SIZE, IMAGE_SIZE) OnGlobalQueueWithCmplitionOnMainThread:^(id  _Nullable image) {
            self.authorAvatarImageView.image = image;
        }];
    }];
    self.authorNameLabel.text = [@"Author: " stringByAppendingString:repo.repoOwnerLogin];
    self.repoNameLabel.text = [@"Repo name: " stringByAppendingString:repo.repoName];
    self.descriptionOfRepoLabel.text = repo.repoDescription;
    self.descriptionOfRepoLabel.numberOfLines = 4;
    self.watchersLabel.text = @"Watchers:";
    self.watchersCountLabel.text = repo.repoWatchersCount.stringValue;
    self.forksLabel.text = @"Forks:";
    self.forksCountLabel.text = repo.repoForksCount.stringValue;
    
    UIFont *fontForFooter = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
    self.watchersLabel.font = fontForFooter;
    self.watchersCountLabel.font = fontForFooter;
    self.forksLabel.font = fontForFooter;
    self.forksCountLabel.font = fontForFooter;
}

@end
