//
//  ViewController.m
//  gitHubClient
//
//  Created by Artem Zabludovsky on 30.07.2018.
//  Copyright © 2018 Artem Zabludovsky. All rights reserved.
//

#import "RepoListViewController.h"
#import "GitHubAutharisation.h"
#import "RepoTableViewCell.h"
#import <Masonry.h>
#import "Repo.h"
#import "ReposManager.h"
#import "CommitsViewController.h"


static NSString *const TITLE = @"Repositories";

static NSString *const NAME_OF_AUTH_BUTTON = @"Auth";
static NSString *const NAME_OF_LOGOUT_BUTTON = @"Log out";

static NSString *const REUSE_CELL_ID = @"REUSE_CELL_ID";

static CGFloat const ESTIMATED_CELL_HEIGHT = 170;


@interface RepoListViewController ()<GitHubAutharisationDelegate, UITableViewDelegate, UITableViewDataSource, ReposManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *autharisationButton;

@property (nonatomic, strong) GitHubAutharisation *gitHubAutharisation;

@property (nonatomic, assign) BOOL isLogon;

@property (nonatomic, strong) ReposManager *reposManager;
@property (nonatomic, copy) NSArray <Repo *> *reposArray;

@end


@implementation RepoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = TITLE;
    _tableView = [self setupTableView];
    [self setupPullToRefresh];
    [self setupNavBarRightButton];
    
    if (self.isLogon)
    {
        [self.reposManager getRepos];
    }
}

- (UITableView *)setupTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectNull style:UITableViewStylePlain];
    [tableView registerClass:[RepoTableViewCell class] forCellReuseIdentifier:REUSE_CELL_ID];
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

- (void)setupPullToRefresh
{
    self.tableView.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)setupNavBarRightButton
{
    NSString *titleOfButton;
    if (self.isLogon)
    {
        titleOfButton = NAME_OF_LOGOUT_BUTTON;
    }
    else
    {
        titleOfButton = NAME_OF_AUTH_BUTTON;
    }
    self.autharisationButton = [[UIBarButtonItem alloc]initWithTitle:titleOfButton style:UIBarButtonItemStylePlain target:self action:@selector(autharisationButtonClicked)];
    self.autharisationButton.possibleTitles = [NSSet setWithObjects:NAME_OF_AUTH_BUTTON,NAME_OF_LOGOUT_BUTTON, nil];
    self.navigationItem.rightBarButtonItem = self.autharisationButton;
}


#pragma mark - Buttons Clicked

- (void)autharisationButtonClicked
{
    if ([self.autharisationButton.title isEqualToString:NAME_OF_AUTH_BUTTON])
    {
        [self.gitHubAutharisation autharisation];
    }
    if ([self.autharisationButton.title isEqualToString:NAME_OF_LOGOUT_BUTTON])
    {
        [self.gitHubAutharisation logout];
        [self changeNameOfAuthButton];
        self.reposArray = @[];
        [self.tableView reloadData];
    }
}

- (void)refresh
{
    [self.reposManager getRepos];
}


#pragma mark - Customs Accessors

- (GitHubAutharisation *)gitHubAutharisation
{
    if (!_gitHubAutharisation)
    {
        _gitHubAutharisation = [GitHubAutharisation new];
        _gitHubAutharisation.delegate = self;
    }
    return _gitHubAutharisation;
}

- (BOOL)isLogon
{
    if ([GitHubAutharisation token])
    {
        return YES;
    }
    return NO;
}

- (ReposManager *)reposManager
{
    if (!_reposManager)
    {
        _reposManager = [ReposManager new];
        _reposManager.delegate = self;
    }
    return _reposManager;
}


#pragma mark - Private Methods

- (void)changeNameOfAuthButton
{
    if (self.isLogon)
    {
        self.autharisationButton.title = NAME_OF_LOGOUT_BUTTON;
    }
    else
    {
        self.autharisationButton.title = NAME_OF_AUTH_BUTTON;
    }
    self.navigationItem.rightBarButtonItem = self.autharisationButton;
}

- (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.reposArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoTableViewCell *cell = [[RepoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSE_CELL_ID];
    [cell setupForRepo:self.reposArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ESTIMATED_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommitsViewController *commitsViewController = [CommitsViewController new];
    commitsViewController.choosenRepo = self.reposArray[indexPath.row];
    
    [self.navigationController pushViewController:commitsViewController animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
}


#pragma mark - GitHubAuthDelegate

- (void)autharisationDidCancel:(GitHubAutharisation *)GitHubAutharisation
{
    NSLog(@"Auth canceled");
}

- (void)autharisationDidDone:(GitHubAutharisation *)GitHubAutharisation withToken:(NSString *)token
{
    [self changeNameOfAuthButton];
    [self.reposManager getRepos];
}

- (void)autharisationError:(GitHubAutharisation *)GitHubAutharisation withError:(NSError *)error
{
    [self showAlertWithTitle:@"Autharisation error!" withMessage:error.localizedDescription];
}


#pragma mark - ReposManagerDelegate

- (void)reposDidLoad:(ReposManager *)reposManager withReposArray:(NSArray <Repo *> *)reposArray
{
    self.reposArray = reposArray;
    [self.tableView reloadData];
    [self.tableView.refreshControl endRefreshing];
}

- (void)reposLoadError:(ReposManager *)reposManager withError:(NSError *)error
{
    [self.tableView.refreshControl endRefreshing];
    [self showAlertWithTitle:@"Repos load error!" withMessage:error.localizedDescription];
}

@end
