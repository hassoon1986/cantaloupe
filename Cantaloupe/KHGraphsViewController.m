//
//  KHGraphsViewController.m
//  Cantaloupe
//
//  Created by Kevin Hwang on 4/29/14.
//  Copyright (c) 2014 Kevin Hwang. All rights reserved.
//

#import "KHGraphsViewController.h"
#import "KHGraphsViewCell.h"
#import "KHDetailedGraphViewController.h"
#import "KHGraphDataSource.h"
#import "KHGraphDataManager.h"

static NSString *KHkGraphsCellIdentifier = @"kGraphsCell";

@interface KHGraphsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *key;

@end

@implementation KHGraphsViewController

#pragma mark - NSObject

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (id)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
        self.key = key;
    }
    return self;
}

#pragma mark - UIViewController
- (void)loadView {
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Graphs", nil);
    [self.tableView registerClass:[KHGraphsViewCell class] forCellReuseIdentifier:KHkGraphsCellIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Graphs Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - UITableView protocols

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KHGraphsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KHkGraphsCellIdentifier forIndexPath:indexPath];
    
    [self customizeCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)customizeCell:(KHGraphsViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    if (row == 0) {
        cell.textLabel.text = NSLocalizedString(@"Purchases", nil);
        cell.tag = KHGraphTypePurchases;
        
    } else if (row == 1) {
        cell.textLabel.text = NSLocalizedString(@"Views", nil);
        cell.tag = KHGraphTypeViews;
        
    } else if (row == 2) {
        cell.textLabel.text = NSLocalizedString(@"Downloads", nil);
        cell.tag = KHGraphTypeDownloads;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    KHDetailedGraphViewController *detailedGraphController = [[KHDetailedGraphViewController alloc] initWithGraphType:cell.tag key:self.key];
    [self.navigationController pushViewController:detailedGraphController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
