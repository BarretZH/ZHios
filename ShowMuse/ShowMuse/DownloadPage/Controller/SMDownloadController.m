//
//  SMDownloadController.m
//  ShowMuse
//
//  Created by ygliu on 7/27/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "SMDownloadController.h"
#import "Masonry.h"
#import "SMBottomView.h"
#import "SMDownloadHeaderView.h"
#import "SMDownloadingVideoCell.h"
#import "SMDownloadedCell.h"
#import "SMDeleteAllView.h"
#import <ZFDownloadManager.h>
#import "SMLessonDetailController.h"

#define HeaderViewHeight 60
#define BottomViewHeight 85
#define DeleteViewHeight 50

static NSString *const SMDownloadingVideoReusableCellIdentifier = @"SMDownloadVideoReusableCellIdentifier";

static NSString *const SMDownloadedVideoReusableCellIdentifier = @"SMDownloadVideoReusableCellIdentifier";

@interface SMDownloadController () <SMHeaderViewDelegate, SMDeleteViewDelegate, SMBottomViewDelegate, ZFDownloadDelegate, UITableViewDelegate, UITableViewDataSource> {
    BOOL isEdit;
}

/** top parent View */
@property (nonatomic,strong) SMDownloadHeaderView *headerContentView;
/** bottom parent View */
@property (nonatomic,strong) SMBottomView *bottomContentView;
/** Delete All View */
@property (strong, nonatomic) SMDeleteAllView *deleteAllView;
/** downloading */
@property (nonatomic,strong) UITableView *downloadingTableView;
/** downloaded */
@property (nonatomic,strong) UITableView *downloadedTableView;
/** edit button */
@property (nonatomic,weak) UIButton *editButton;
/** record current select button of header view */
@property (nonatomic,weak) UISegmentedControl *selHeaderBtn;
/** record all selected downloading cell's item */
@property (strong, nonatomic) NSMutableArray *selDownloadingArr;
/** record all selected downloaded cell's item */
@property (strong, nonatomic) NSMutableArray *selDownloadedArr;
/** manager */
@property (strong, nonatomic) ZFDownloadManager *downloadManager;

@end

@implementation SMDownloadController

#pragma mark - lazy load
- (NSMutableArray *)selDownloadingArr
{
    if (!_selDownloadingArr) {
        _selDownloadingArr = [NSMutableArray array];
    }
    return _selDownloadingArr;
}

- (NSMutableArray *)selDownloadedArr
{
    if (!_selDownloadedArr) {
        _selDownloadedArr = [NSMutableArray array];
    }
    return _selDownloadedArr;
}
- (ZFDownloadManager *)downloadManager
{
    if (!_downloadManager) {
        _downloadManager = [ZFDownloadManager sharedDownloadManager];
        _downloadManager.downloadDelegate = self;
    }
    return _downloadManager;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    isEdit = NO;
    // add navigationwedgets
    [self setupNav];
    // add headerView
    [self setupHeaderView];
    // add downloading tableview
    [self setupDownloadingVideoListView];
    // add bottom View
    [self setupBottomView];
    // add delete view
    [self setupDeleteAllView];
    // add downloaded tableview
    [self setupDownloadedVideoListView];
    // constraints
    [self addConstraints];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha = 1;
}
#pragma mark - initData
- (void)initData
{
    [self.downloadManager startLoad];
    [self.downloadedTableView reloadData];
    [self.downloadingTableView reloadData];
}

#pragma mark - add all child widgets
- (void)setupNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = NSLocalizedString(@"LEFT_MENU_DOWNLOAD_MANAGER", nil);
    NSMutableDictionary *titleAttributes = [NSMutableDictionary dictionary];
    titleAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    titleAttributes[NSFontAttributeName] = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    self.navigationController.navigationBar.titleTextAttributes = titleAttributes;
    // right button
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.bounds = CGRectMake(0, 0, 40, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [rightBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:NSLocalizedString(@"DOWNLOAD_PAGE_EDIT", nil) forState:UIControlStateNormal];
    [rightBtn setTitle:NSLocalizedString(@"DOWNLOAD_PAGE_DONE", nil) forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem.enabled = self.downloadManager.finishedlist.count == 0 ? NO : YES;
    self.editButton = rightBtn;
}

- (void)setupHeaderView
{
    SMDownloadHeaderView *headerContentView = [[SMDownloadHeaderView alloc] init];
    headerContentView.headerViewDelegate = self;
    [self.view addSubview:headerContentView];
    self.headerContentView = headerContentView;
    
}

- (void)setupDownloadingVideoListView
{
    UITableView *dlingTableView = [self createTableView];
    self.downloadingTableView = dlingTableView;
    //register cell
    [self.downloadingTableView registerClass:[SMDownloadingVideoCell class] forCellReuseIdentifier:SMDownloadingVideoReusableCellIdentifier];
    
}

- (void)setupDownloadedVideoListView
{
    UITableView *dledTableView= [self createTableView];
    dledTableView.allowsSelection = YES;
    self.downloadedTableView = dledTableView;
    // register cell
    [self.downloadedTableView registerClass:[SMDownloadedCell class] forCellReuseIdentifier:SMDownloadedVideoReusableCellIdentifier];
}

- (UITableView *)createTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = colorWithRGB(240, 242, 245);
    tableView.rowHeight = SMScreenWidth == 320 ? 70 : 80;
    [self.view addSubview:tableView];
    tableView.allowsSelection = NO;
    return tableView;
}

- (void)setupBottomView
{
    SMBottomView *bottomView = [[SMBottomView alloc] init];
    bottomView.delegate = self;
    bottomView.backgroundColor = colorWithRGB(240, 242, 245);
    [self.view addSubview:bottomView];
    self.bottomContentView = bottomView;
}

- (void)setupDeleteAllView
{
    SMDeleteAllView *deleteAllView = [[SMDeleteAllView alloc] init];
    deleteAllView.deleteDelegate = self;
    [self.view addSubview:deleteAllView];
    self.deleteAllView = deleteAllView;
    deleteAllView.hidden = YES;
}
#pragma mark - add constraints
- (void)addConstraints
{
    [self.headerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(HeaderViewHeight);
    }];
    
    [self.downloadingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerContentView.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.bottomContentView.top);
    }];
    
    [self.bottomContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
        make.right.equalTo(self.view.right);
        make.height.equalTo(BottomViewHeight);
    }];
    
    [self.deleteAllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
        make.right.equalTo(self.view.right);
        make.height.equalTo(DeleteViewHeight);
    }];
    
    [self.downloadedTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerContentView.bottom);
        make.left.equalTo(self.view.left);
        make.bottom.equalTo(self.view.bottom);
        make.right.equalTo(self.view.right);
    }];
}
#pragma mark - edit button click
- (void)editBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        isEdit = YES;
        if (self.selHeaderBtn.selectedSegmentIndex == 0) { // downloaded btn
            [self.downloadedTableView setEditing:YES];
            self.downloadedTableView.allowsSelection = YES;
            
            [self.headerContentView removeFromSuperview];
            [self.view addSubview:self.deleteAllView];
            self.deleteAllView.hidden = NO;
            
            [self.deleteAllView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.left);
                make.bottom.equalTo(self.view.bottom);
                make.right.equalTo(self.view.right);
                make.height.equalTo(DeleteViewHeight);
            }];
            
            [self.downloadedTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.top);
                make.left.equalTo(self.view.left);
                make.bottom.equalTo(self.deleteAllView.top);
                make.right.equalTo(self.view.right);
            }];
        } else { // downloading btn
            [self.downloadingTableView setEditing:YES];
            self.downloadingTableView.allowsSelection = YES;
            
            [self.headerContentView removeFromSuperview];
            [self.bottomContentView removeFromSuperview];
            self.deleteAllView.hidden = NO;
            
            [self.deleteAllView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.left);
                make.bottom.equalTo(self.view.bottom);
                make.right.equalTo(self.view.right);
                make.height.equalTo(DeleteViewHeight);
            }];
            
            [self.downloadingTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.top);
                make.left.equalTo(self.view.left);
                make.bottom.equalTo(self.deleteAllView.top);
                make.right.equalTo(self.view.right);
            }];
        }
        
    } else {
        isEdit = NO;
        if (self.selHeaderBtn.selectedSegmentIndex == 0) { // downloaded btn
            [self.downloadedTableView setEditing:NO];
//            self.downloadedTableView.allowsSelection = NO;
            
            [self.view addSubview:self.headerContentView];
            self.deleteAllView.hidden = YES;
            
            self.navigationItem.rightBarButtonItem.enabled = self.downloadManager.finishedlist.count == 0 ? NO : YES;
            
            [self.headerContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.top);
                make.left.equalTo(self.view.left);
                make.right.equalTo(self.view.right);
                make.height.equalTo(HeaderViewHeight);
            }];
            
            [self.downloadedTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headerContentView.bottom);
                make.left.equalTo(self.view.left);
                make.right.equalTo(self.view.right);
                make.bottom.equalTo(self.view.bottom);
            }];
            
            
        } else { // downloading btn
            [self.downloadingTableView setEditing:NO];
            self.downloadingTableView.allowsSelection = NO;
            
            [self.view addSubview:self.headerContentView];
            [self.view addSubview:self.bottomContentView];
            self.deleteAllView.hidden = YES;
            
            self.navigationItem.rightBarButtonItem.enabled = self.downloadManager.downinglist.count == 0 ? NO : YES;
            
            [self.headerContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.top);
                make.left.equalTo(self.view.left);
                make.right.equalTo(self.view.right);
                make.height.equalTo(HeaderViewHeight);
            }];
            
            [self.downloadingTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.headerContentView.bottom);
                make.left.equalTo(self.view.left);
                make.right.equalTo(self.view.right);
                make.bottom.equalTo(self.bottomContentView.top);
            }];
            
            [self.bottomContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.left);
                make.bottom.equalTo(self.view.bottom);
                make.right.equalTo(self.view.right);
                make.height.equalTo(BottomViewHeight);
            }];
            
            [self.deleteAllView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.left);
                make.bottom.equalTo(self.view.bottom);
                make.right.equalTo(self.view.right);
                make.height.equalTo(DeleteViewHeight);
            }];
        }
    }
}
#pragma mark - ZFDownloadDelegate
// update progress
- (void)updateCellProgress:(ZFHttpRequest *)request
{
    ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}

- (void)updateCellOnMainThread:(ZFFileModel *)fileInfo
{
    NSArray *cellArr = [self.downloadingTableView visibleCells];
    for (SMDownloadingVideoCell *cell in cellArr) {
        if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
            cell.fileInfo = fileInfo;
        }
    }
}
// finish
- (void)finishedDownload:(ZFHttpRequest *)request
{
    [self initData];
}


#pragma mark - SMHeaderViewDelegate
- (void)headerViewSegmentControlDidClick:(UISegmentedControl *)pageControl
{
    self.selHeaderBtn = pageControl;
    if (pageControl.selectedSegmentIndex == 0) { //downloaded button
        self.navigationItem.rightBarButtonItem.enabled = self.downloadManager.finishedlist.count == 0 ? NO : YES;
        [self.view addSubview:self.downloadedTableView];
        [self.downloadingTableView removeFromSuperview];
        [self.bottomContentView removeFromSuperview];
        
        // update constraints
        [self.downloadedTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerContentView.bottom);
            make.left.equalTo(self.view.left);
            make.bottom.equalTo(self.view.bottom);
            make.right.equalTo(self.view.right);
        }];
        [self.downloadedTableView reloadData];
        
    } else { // downloading button
        self.navigationItem.rightBarButtonItem.enabled = self.downloadManager.downinglist.count == 0 ? NO : YES;
        [self.view addSubview:self.downloadingTableView];
        [self.view addSubview:self.bottomContentView];
        [self.downloadedTableView removeFromSuperview];
        
        // update constraints
        [self.downloadingTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerContentView.bottom);
            make.left.equalTo(self.view.left);
            make.right.equalTo(self.view.right);
            make.bottom.equalTo(self.bottomContentView.top);
        }];
        
        [self.bottomContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.left);
            make.bottom.equalTo(self.view.bottom);
            make.right.equalTo(self.view.right);
            make.height.equalTo(BottomViewHeight);
        }];
        
        [self.downloadingTableView reloadData];
        
    }
}
#pragma mark - SMDeleteViewDelegate
- (void)SMDeleteViewButtonDidClick:(UIButton *)button
{
    if (button.tag == 0) { // selectedAll
        if (self.selHeaderBtn.selectedSegmentIndex == 0) { // downloaded btn
            for (NSInteger i = 0; i < self.downloadManager.finishedlist.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [self.downloadedTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                ZFFileModel *fileInfo = self.downloadManager.finishedlist[i];
                [self.selDownloadedArr addObject:fileInfo];
            }
            
        } else { // downloading btn
            for (NSInteger i = 0; i < self.downloadManager.downinglist.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [self.downloadingTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                ZFFileModel *fileInfo = self.downloadManager.downinglist[i];
                [self.selDownloadingArr addObject:fileInfo];
            }
        }
    } else { // delete
        if (self.selHeaderBtn.selectedSegmentIndex == 0) { // downloaded btn
            for (NSInteger i = 0; i < self.selDownloadedArr.count; i++) {
                ZFFileModel *fileInfo = self.selDownloadedArr[i];
                [self.downloadManager deleteFinishFile:fileInfo];
            }
            [self.downloadedTableView reloadData];
            
        } else { // downloading btn
            if (self.selDownloadingArr.count == self.downloadManager.downinglist.count) { // delete All
                [self.downloadManager clearAllRquests];
            } else {
                for (NSInteger i = 0; i < self.selDownloadingArr.count; i++) {
                    ZFHttpRequest *request = self.selDownloadingArr[i];
                    [self.downloadManager deleteRequest:request];
                }
            }
            [self.downloadingTableView reloadData];
        }
    }
}
#pragma mark - SMBottomViewDelegate
- (void)bottomViewButtonDidClick:(UIButton *)selectBtn
{
    if (selectBtn.tag == 0) { // beginAll
        for (NSInteger i = 0; i < self.downloadManager.downinglist.count; i++) {
            [self.downloadManager resumeRequest:self.downloadManager.downinglist[i]];
            SMDownloadingVideoCell *cell = [self.downloadingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (i < 3) {
                [cell setVideoButtonStatusWithSelection:NO];
            }
        }
    } else { // stopAll
        NSInteger count = self.downloadManager.downinglist.count;
        for (NSInteger i = 0; i < count; i++) {
            [self.downloadManager stopRequest:self.downloadManager.downinglist[i]];
            SMDownloadingVideoCell *cell = [self.downloadingTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell setVideoButtonStatusWithSelection:YES];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.downloadingTableView) ? self.downloadManager.downinglist.count : self.downloadManager.finishedlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.downloadingTableView) {
        SMDownloadingVideoCell *loadingcell = [tableView dequeueReusableCellWithIdentifier:SMDownloadingVideoReusableCellIdentifier];
        ZFHttpRequest *request = self.downloadManager.downinglist[indexPath.row];
        loadingcell.request = request;
        ZFFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        loadingcell.fileInfo = fileInfo;
        __weak typeof(self) weakSelf = self;
        loadingcell.downloadBlock = ^{
            [weakSelf initData];
        };
        return loadingcell;
    } else {
        SMDownloadedCell *loadedcell = [tableView dequeueReusableCellWithIdentifier:SMDownloadedVideoReusableCellIdentifier];
        loadedcell.fileInfo = self.downloadManager.finishedlist[indexPath.row];
        NSString *filePath = FILE_PATH(loadedcell.fileInfo.fileName);
        __weak typeof(loadedcell) weakCell = loadedcell;
        __weak typeof(self) weakSelf = self;
        loadedcell.playBlock = ^{
            SMLessonDetailController *lDVC = [[SMLessonDetailController alloc] init];
            lDVC.lessonID = weakCell.fileInfo.fileID;
            lDVC.filePath = filePath;
            lDVC.localVideo = YES;
            [weakSelf.navigationController pushViewController:lDVC animated:YES];
        };
        return loadedcell;
    }
}

#pragma mark - UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.editButton.isSelected ? (UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert) : UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"DOWNLOAD_PAGE_DELETE", nil);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.downloadingTableView) { // downloading
        ZFHttpRequest *request = self.downloadManager.downinglist[indexPath.row];
        [self.downloadManager deleteRequest:request];
    } else { // downloaded
        ZFFileModel *fileInfo = self.downloadManager.finishedlist[indexPath.row];
        [self.downloadManager deleteFinishFile:fileInfo];
    }
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SMLog(@"1212121212");
    if (isEdit) {
//        SMLog(@"编辑状态");
        if (tableView == self.downloadingTableView) {
            [self.selDownloadingArr addObject:[self.downloadManager.downinglist objectAtIndex:indexPath.row]];
        } else {
            [self.selDownloadedArr addObject:[self.downloadManager.finishedlist objectAtIndex:indexPath.row]];
        }
    }else {
        if (tableView == self.downloadedTableView) {
//            SMLog(@"下载完成点击");
            ZFFileModel * fileInfo = self.downloadManager.finishedlist[indexPath.row];
            NSString *filePath = FILE_PATH(fileInfo.fileName);
            SMLessonDetailController *lDVC = [[SMLessonDetailController alloc] init];
            lDVC.lessonID = fileInfo.fileID;
            lDVC.filePath = filePath;
            lDVC.localVideo = YES;
            [self.navigationController pushViewController:lDVC animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.downloadingTableView) {
        [self.selDownloadingArr removeObject:[self.downloadManager.downinglist objectAtIndex:indexPath.row]];
    } else {
        [self.selDownloadedArr removeObject:[self.downloadManager.finishedlist objectAtIndex:indexPath.row]];
    }
}

@end
