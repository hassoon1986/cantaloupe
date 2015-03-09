//
//  KHMyGamesViewController.m
//  Cantaloupe
//
//  Created by Kevin Hwang on 3/6/15.
//  Copyright (c) 2015 Kevin Hwang. All rights reserved.
//

// Views
#import "KHMyGamesViewController.h"
#import "KHGameViewCell.h"

// Data Source
#import "KHMyGamesDataSource.h"

@interface KHMyGamesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, KHMyGamesDataSourceDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) KHMyGamesDataSource *dataSource;

@end

static NSString *KHkGameCellIdentifier = @"gameCellIdentifier";

@implementation KHMyGamesViewController

- (instancetype)init {
    if (self = [super init]) {
        _dataSource = [[KHMyGamesDataSource alloc] initWithDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupCollectionView];
    [self _setupRefreshControl];
    [self _setupNavigationBar];
    [self.dataSource requestGames];
}

- (void)_setupCollectionView {
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self.collectionView registerClass:[KHGameViewCell class] forCellWithReuseIdentifier:KHkGameCellIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

- (void)_setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(_refresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
}

- (void)_setupNavigationBar {
    self.navigationItem.title = NSLocalizedString(@"My Games", nil);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KHkGameCellIdentifier forIndexPath:indexPath];
    if ([cell isKindOfClass:[KHGameViewCell class]]) {
        KHGameViewCell *gameCell = (KHGameViewCell *)cell;
#warning TODO: Configure cell with KHGameInfo from data source
        
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UIRefreshControl

- (void)_refresh {
    [self.dataSource requestGames];
}

#pragma mark - KHMyGamesDataSourceDelegate

- (void)gamesFetched {
    [self.collectionView reloadData];
}

- (void)gameFetchError:(NSError *)error {
    
}

@end