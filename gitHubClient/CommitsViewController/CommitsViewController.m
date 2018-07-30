//
//  CommitsViewController.m
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "CommitsViewController.h"
#import "CommitsTableViewCell.h"
#import "Commit.h"
#import "CommitsManager.h"
#import <Masonry.h>

static NSString *const TITLE = @"Commits";

static NSString *const REUSE_COMMITS_CELL_ID = @"REUSE_COMMITS_CELL_ID";

static CGFloat const ESTIMATED_CELL_HEIGHT = 70;


@interface CommitsViewController ()<UITableViewDelegate, UITableViewDataSource, CommitsManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CommitsManager *commitsManager;
@property (nonatomic, strong) NSArray <Commit *> *commitsArray;

@end


@implementation CommitsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = TITLE;
    
    _tableView = [self setupTableView];
    [self setupPullToRefresh];
}

- (UITableView *)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectNull style:UITableViewStylePlain];
    [tableView registerClass:[CommitsTableViewCell class] forCellReuseIdentifier:REUSE_COMMITS_CELL_ID];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = ESTIMATED_CELL_HEIGHT;
    tableView.tableFooterView = [UIView new];
    
    [self.view addSubview:tableView];
    
    CGRect rectForStatusBar = [UIApplication sharedApplication].statusBarFrame;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(rectForStatusBar.size.height);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    return tableView;
}


#pragma mark - Customs Accessors

- (CommitsManager *)commitsManager
{
    if (!_commitsManager)
    {
        _commitsManager = [CommitsManager new];
        _commitsManager.delegate = self;
    }
    return _commitsManager;
}

- (void)setChoosenRepo:(Repo *)choosenRepo
{
    _choosenRepo = choosenRepo;
    [self.commitsManager getCommitsForRepo:choosenRepo];
}


#pragma mark - Private Methods

- (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupPullToRefresh
{
    self.tableView.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh
{
    [self.commitsManager getCommitsForRepo:self.choosenRepo];
}


#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commitsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommitsTableViewCell *cell = [[CommitsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSE_COMMITS_CELL_ID];
    
    [cell setupForCommit:self.commitsArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ESTIMATED_CELL_HEIGHT;
}


#pragma mark - CommitsManagerDelegate

- (void)commitsDidLoad:(CommitsManager *)commitsManager withReposArray:(NSArray<Commit *> *)commitsArray
{
    self.commitsArray = commitsArray;
    [self.tableView reloadData];
    [self.tableView.refreshControl endRefreshing];
}

- (void)commitsLoadError:(CommitsManager *)commitsManager withError:(NSError *)error
{
    [self.tableView.refreshControl endRefreshing];
    [self showAlertWithTitle:@"Commits load error!" withMessage:error.localizedDescription];
}

@end
