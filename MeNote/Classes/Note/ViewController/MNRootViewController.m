//
//  ViewController.m
//  MeNote
//
//  Created by luoyan on 2017/4/20.
//  Copyright © 2017年 roger. All rights reserved.
//

#import "MNRootViewController.h"
#import "MNFloatToolView.h"
#import "MNNoteTableViewCell.h"
#import "MNNoteSectionHeaderView.h"
#import "MNNoteListModel.h"
#import "MNNewNoteViewController.h"
#import "MNNoteDetailViewController.h"
#import "MNUserCenterViewController.h"

@interface MNRootViewController ()<UITableViewDelegate,UITableViewDataSource,MNFloatToolViewDelegete>
{
    
}

@property (nonatomic, strong) UITableView    *myNotesTabelView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MNRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self demoDataSource];
    [self loadSubView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadSubView
{
    self.myNotesTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.myNotesTabelView.backgroundColor = UIColorHex(0xf5f6f8);
    self.myNotesTabelView.dataSource = self;
    self.myNotesTabelView.delegate = self;
    self.myNotesTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myNotesTabelView registerClass:[MNNoteTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MNNoteTableViewCell class])];
    [self.myNotesTabelView registerClass:[MNNoteSectionHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([MNNoteSectionHeaderView class])];
    [self.view addSubview:self.myNotesTabelView];
    
    
    MNFloatToolView *floadView = [MNFloatToolView new];
    floadView.delegate = self;
    [floadView addToView:self.view];
}

- (void)demoDataSource
{
    self.dataSource = [NSMutableArray new];
    
    NSMutableArray *section1 = [NSMutableArray new];
    for (int i = 0; i<3; i++) {
        MNNoteListModel *model = [[MNNoteListModel alloc] init];
        model.noteDate = @"2017.04.21";
        model.noteDes  = @"今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。";
        model.noteImages = @[@"note_image1",@"note_image1"];
        
        [section1 addObject:model];
    }
    [self.dataSource addObject:section1];
    
    NSMutableArray *section2 = [NSMutableArray new];
    for (int i = 0; i<2; i++) {
        MNNoteListModel *model = [[MNNoteListModel alloc] init];
        model.noteDate = @"2017.04.22";
        model.noteDes  = @"今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。今天周一，收拾好心情，好好上班。";
        model.noteImages = @[@"note_image1",@"note_image1"];
        
        [section2 addObject:model];
    }
    [self.dataSource addObject:section2];
    
    NSMutableArray *section3 = [NSMutableArray new];
    for (int i = 0; i<1; i++) {
        MNNoteListModel *model = [[MNNoteListModel alloc] init];
        model.noteDate = @"2017.04.23";
        model.noteDes  = @"今天周一，收拾好心情，好好上班。";
        model.noteImages = @[@"note_image1",@"note_image1"];
        
        [section3 addObject:model];
    }
    [self.dataSource addObject:section3];
}

#pragma mark MNFloatToolViewDelegete
- (void)didClickToolViewItem:(NSInteger)itemIndex
{
    if (itemIndex == 0) {
        // 写心情
        MNNewNoteViewController *newNoteVC = [[MNNewNoteViewController alloc] init];
        [self.navigationController pushViewController:newNoteVC animated:YES];
    } else if (itemIndex == 1) {
        // 我的
        MNUserCenterViewController *userCenterVC = [[MNUserCenterViewController alloc] init];
        [self.navigationController pushViewController:userCenterVC animated:YES];
    }
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //详情
    MNNoteDetailViewController *detailVC = [[MNNoteDetailViewController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MNNoteSectionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MNNoteSectionHeaderView class])];
    NSArray *datas = [self.dataSource objectAtIndex:section];
    MNNoteListModel *model = [datas firstObject];
    headerView.titleLabel.text = model.noteDate;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *datas = [self.dataSource objectAtIndex:section];
    return datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MNNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MNNoteTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *datas = [self.dataSource objectAtIndex:indexPath.section];
    MNNoteListModel *model = [datas objectAtIndex:indexPath.row];
    [cell noteModel:model];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
