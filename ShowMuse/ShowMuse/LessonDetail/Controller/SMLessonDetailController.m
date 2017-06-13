//
//  SMLessonDetailController.m
//  ShowMuse
//
//  Created by 刘勇刚 on 9/12/16.
//  Copyright © 2016 ShowMuse. All rights reserved.
//

#import "SMLessonDetailController.h"
#import "PiwikTracker.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "ShowMuseURLString.h"
#import "TokenManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "UIImageView+WebCache.h"

#import "SMLesson.h"
#import "YGTeacherCourse.h"
#import "SMRelatedCourse.h"
#import "SMRelatedMaterial.h"
#import "SMWatchState.h"
#import "SMSubtitle.h"
#import "SMVideoQuestion.h"
#import "SMRelatedProduct.h"
#import "SMSuggestLessson.h"
#import "SMComment.h"
#import "SMCommentThread.h"
#import "SMDetailComment.h"
#import "DetailsNetWork.h"

#import "SMTeacherIntroCell.h"
#import "SMTagCell.h"
#import "SMVideoCell.h"
#import "SMRelatedCell.h"
#import "SMCommentCell.h"
#import "SMReplyCommentCell.h"
#import "SMTagButton.h"

#import "ZFPlayer.h"
#import <ZFDownloadManager.h>
#import "SMDownloadController.h"
#import "YGMasterMainViewController.h"
#import "CourseViewController.h"
#import "SMSubscribeView.h"
#import "VIPShopViewController.h"
#import "CourseDetailsWebViewController.h"
#import "SMInputView.h"

static NSString *const CommentCellReuseIdentifier = @"commentCellIdentifier";
static NSString *const VideoCellReuseIdentifier = @"videoCell";
static NSString *const IntroCellReuseIdentifier = @"introCell";
static NSString *const tagCellReuseIdentifier = @"tagCell";
static NSString *const relatedCellReuseIdentifier = @"relatedCell";

static NSString *const ReplyCommentCellReuseIdentifier = @"replycommentCellIdentifier";

@interface SMLessonDetailController () <UITableViewDelegate, UITableViewDataSource, SMTeacherIntroCellDelegate, SMRelatedCellDelegate, UIWebViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) UITableView *tableView;
/** inputView */
@property (nonatomic,weak) UIView *bottomView;

@property (nonatomic,weak) SMInputView *input;

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@property (strong, nonatomic) ZFPlayerView *player;
/** 保存视频字幕 */
@property (strong, nonatomic) NSMutableArray *subtitleArr;

@property (nonatomic,weak) SMRelatedCell *relatedCell;

@property (strong, nonatomic) SMVideoCell *videoCell;

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *platform;

@property (strong, nonatomic) UIImage *videoImage;

@property (weak, nonatomic) UIActivityIndicatorView *indicator;

@property (nonatomic,weak) UIWebView *webView;
/** 记录弹出问题的时间 */
@property (assign, nonatomic) NSInteger popupQuesTime;

@property (strong, nonatomic) NSMutableArray *questionArr;

@end


@implementation SMLessonDetailController
#pragma mark - lazy
- (NSMutableArray *)suggestLessonArr
{
    if (!_suggestLessonArr) {
        _suggestLessonArr = [NSMutableArray array];
    }
    return _suggestLessonArr;
}

- (AFHTTPRequestOperationManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPRequestOperationManager manager];
    }
    return _manager;
}
- (NSMutableArray *)subtitleArr
{
    if (!_subtitleArr) {
        _subtitleArr = [NSMutableArray array];
    }
    return _subtitleArr;
}

- (NSMutableArray *)questionArr
{
    if (!_questionArr) {
        _questionArr = [NSMutableArray array];
    }
    return _questionArr;
}

#pragma mark - some view's methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = colorWithRGB(240, 243, 245);
    
    [self setupNav];
    
    [self getLessonData];
    
    [self getRelatedLessons];
    
    [self getSubtitleData];
    
    [self addTableView];
    
    [self setupInputView];
    
    // listen keyboard's showing and hiding notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendBookmarkData:) name:SMVideoPlayBookmarkCountNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popupWebView:) name:SMVideoPlayPopupQuestionNotification object:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[PiwikTracker sharedInstance] sendViews:@"lessons",_lessonID, nil];
    
}

#pragma mark - send request
- (void)getLessonData
{
    __weak typeof(self) weakSelf = self;
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/lessons/", self.lessonID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        SMLog(@" Lesson -- > %@", responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) return;
        weakSelf.lesson = [SMLesson lessonWithDict:responseObject];
        weakSelf.questionArr = weakSelf.lesson.videoQuestionArr;
        [weakSelf getCommentData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)getRelatedLessons
{
    __weak typeof(self) weakSelf = self;
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/lessons/", self.lessonID, @"/suggested"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        SMLog(@"RelatedLesson -- > %@", responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) return;
        [responseObject[@"suggested_lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf.suggestLessonArr addObject:[SMSuggestLessson sugLessonWithDict:obj]];
        }];
        self.relatedCell.sugLessonsArr = self.suggestLessonArr;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)getCommentData
{
    __weak typeof(self) weakSelf = self;
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/lessons/threads/", self.lesson.commentsThreadId, @"/comments"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SMLog(@"comment -- > %@", responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) return;
        weakSelf.comment = [SMComment commentWithDict:responseObject];
        if (!weakSelf.comment.thread.isCommentable) {
            [weakSelf.bottomView removeFromSuperview];
        } else {
            weakSelf.bottomView.hidden = NO;
            weakSelf.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        }
        [weakSelf setupTableView];
        [weakSelf.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        // delay 1 second to auto play
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.isLocalVideo) {
                [self autoPlayVideo];
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)sendCommentData
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *paramters = @{@"fos_comment_comment[body]" : self.input.text};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"POST" pathComponentsArr:@[@"/v2/lessons/threads/", self.lesson.commentsThreadId, @"/comments"] parameters:paramters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        SMLog(@"-- new Comment -- > %@", responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) return;
        weakSelf.input.text = nil;
        weakSelf.comment = nil;
        weakSelf.comment = [SMComment commentWithDict:responseObject];
        [weakSelf.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SMLog(@"-- --- error --- > %@", error);
        weakSelf.input.text = nil;
        [SMNavigationController modalGlobalLoginViewController];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)getSubtitleData
{
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"get" pathComponentsArr:@[@"/v2/lessons/", self.lessonID, @"/subtitle"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        SMLog(@"-- responseObject -- > %@", responseObject);
        for (NSDictionary *subtitleDict in responseObject[@"subtitles"]) {
            SMSubtitle *subtitle = [SMSubtitle subtitleWithDict:subtitleDict];
            [self.subtitleArr addObject:subtitle];
        }
    } failure:nil];
}

- (void)sendBookmarkData:(NSNotification *)notification
{
    // 记录新观看状态和标签
    NSDictionary *watchState = [notification userInfo];
    if (watchState[@"lessonID"] == self.lessonID) {
        self.watchState = [SMWatchState stateWithDict:watchState];
    }
}

#pragma mark - Share Callback
-(void)shareLessons
{
    NSString *channel = @"";
    if ([self.platform isEqualToString:@"22"]) {
        channel = @"wechat";
    }
    if ([self.platform isEqualToString:@"10"]) {
        channel = @"facebook";
    }
    if ([self.platform isEqualToString:@"43"]) {
        channel = @"whatsapp";
    }
    if ([self.platform isEqualToString:@"23"]) {
        channel = @"wechatmoments";
    }
    if ([self.platform isEqualToString:@"37"]) {
        channel = @"wechatfavorite";
    }
    if ([self.platform isEqualToString:@"1"]) {
        channel = @"sinaweibo";
    }
    if ([self.platform isEqualToString:@"19"]) {
        channel = @"sms";
    }
    if ([self.platform isEqualToString:@"18"]) {
        channel = @"email";
    }
    NSDictionary *requestParameters = @{@"status":self.status,@"channel":channel};
    [SMNetWork sendRequestWithOperationManager:self.manager method:@"put" pathComponentsArr:@[@"/v2/lessons/", self.lessonID, @"/share"] parameters:requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        SMLog(@"-- responeObjct -- > %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        SMLog(@"-- error -- > %@", error);
    }];
}

#pragma mark - initial some widgets
- (void)setupNav
{
    // title
    self.title = NSLocalizedString(@"LESSONS_DETAILS_PAGE_DETAILS", nil);
    NSMutableDictionary *titleAttributes = [NSMutableDictionary dictionary];
    titleAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    titleAttributes[NSFontAttributeName] = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    self.navigationController.navigationBar.titleTextAttributes = titleAttributes;
    // right button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_course_home"] style:UIBarButtonItemStylePlain target:self action:@selector(popupViewController)];
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = colorWithRGB(238, 241, 243);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[SMTeacherIntroCell class] forCellReuseIdentifier:IntroCellReuseIdentifier];
    [self.tableView registerClass:[SMVideoCell class] forCellReuseIdentifier:VideoCellReuseIdentifier];
    [self.tableView registerClass:[SMTagCell class] forCellReuseIdentifier:tagCellReuseIdentifier];
    [self.tableView registerClass:[SMRelatedCell class] forCellReuseIdentifier:relatedCellReuseIdentifier];
    [self.tableView registerClass:[SMCommentCell class] forCellReuseIdentifier:CommentCellReuseIdentifier];
    
    [self.tableView registerClass:[SMReplyCommentCell class] forCellReuseIdentifier:ReplyCommentCellReuseIdentifier];
}

- (void)setupInputView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = colorWithRGB(219, 219, 219);
    [self.view addSubview:bottomView];
    bottomView.hidden = YES;
    self.bottomView = bottomView;
    
    SMInputView *input = [[SMInputView alloc] init];
    input.delegate = self;
    input.layer.cornerRadius = 40 * 0.5;
    input.layer.masksToBounds = YES;
    input.tintColor = colorWithRGB(187, 187, 187);
    input.font = [UIFont systemFontOfSize:16];
    input.placeholder = NSLocalizedString(@"LESSONS_DETAILS_PAGE_COMMENTS", nil);
    [input setValue:colorWithRGB(219, 219, 219) forKeyPath:@"_placeholderLabel.textColor"];
    input.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:input];
    self.input = input;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator = indicator;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(@(44));
    }];
    
    [input mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.left.mas_equalTo(self.bottomView.mas_left).offset(15);
        make.right.mas_equalTo(self.bottomView.mas_right).offset(-15);
        make.height.mas_equalTo(@(38));
    }];
}

#pragma mark - listen keyboard
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, keyboardF.origin.y - SMScreenHeight);
    }];
}
#pragma mark - listen buttons click
-(void)popupViewController
{
    [self.player resetPlayer];
    self.player = nil;
    [[PiwikTracker sharedInstance] sendEventWithCategory:@"click" action:@"mainmenu" name:@"event_mainmenu" value:@(2)];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - popup question
- (void)popupWebView:(NSNotification *)note
{
    if (self.webView) return;
    NSDictionary *object = [note object];
    NSInteger currentTime = [object[@"currentTime"] integerValue];
    if (self.popupQuesTime == currentTime) return;
    // 添加webView
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    webView.frame = window.bounds;
    self.webView = webView;
    for (SMVideoQuestion *question in self.questionArr) {
        if (question.time == currentTime) {
            NSURL *url = [NSURL URLWithString:question.url];
            [webView loadRequest:[NSURLRequest requestWithURL:url]];
            [window addSubview:webView];
            self.popupQuesTime = currentTime;
            break;
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.lesson.relatedMaterialArr.count != 0 && self.lesson.relatedCourseArr.count != 0) {
        return self.comment.commentsArr.count == 0 ? 5 : self.comment.commentsArr.count + 5;
    }else {
        if (self.lesson.relatedMaterialArr.count != 0 || self.lesson.relatedCourseArr.count != 0) {
            return self.comment.commentsArr.count == 0 ? 4 : self.comment.commentsArr.count + 4;
        }else {
            return self.comment.commentsArr.count == 0 ? 3 : self.comment.commentsArr.count + 3;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        if (indexPath.row == 0) {
            SMVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:VideoCellReuseIdentifier];
            self.videoCell = cell;
            __block NSIndexPath *weakIndexPath = indexPath;
            __block SMVideoCell *weakCell = cell;
            __weak typeof (self) weakSelf = self;
            [cell.videoBgView sd_setImageWithURL:[NSURL URLWithString:self.lesson.thumb] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                weakSelf.videoImage = image;
            }];
            if ([self.lesson.videoContent isEqualToString:@"full"]) {
                [cell.subscribe removeFromSuperview];
            }
            cell.subscribe.tapSubscribe = ^ {
                VIPShopViewController *vipVC = [[VIPShopViewController alloc] init];
                [weakSelf.navigationController pushViewController:vipVC animated:YES];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
            };
            if (self.filePath && self.isLocalVideo) { // local video
                self.player = [ZFPlayerView sharedPlayerView];
                self.player.userInteractionEnabled = YES;
                self.player.lesson = self.lesson;
                self.player.subtitleArr = [self.subtitleArr mutableCopy];
                self.player.watchState = self.watchState ? self.watchState : self.lesson.watchStatModel;
                self.player.questionArr = self.lesson.videoQuestionArr; // question
                self.player.seekTime = self.watchState ? self.watchState.playPosition : self.lesson.watchStatModel.playPosition;
                [self.player setVideoURL:[NSURL fileURLWithPath:self.filePath] withTableView:self.tableView AtIndexPath:indexPath withImageViewTag:101];
                [self.player addPlayerToCellImageView:cell.videoBgView];
                self.player.placeholderImageName = @"moren";
                [self.player autoPlayTheVideo];
                self.localVideo = NO;
            }
            self.videoCell.playBlock = ^(UIButton *btn) {
                if ([[weakSelf getNetWorkStates] isEqualToString:@"5"]) {
                    weakSelf.player = [ZFPlayerView sharedPlayerView];
                    weakSelf.player.userInteractionEnabled = YES;
                    weakSelf.player.lesson = weakSelf.lesson;
                    weakSelf.player.subtitleArr = [weakSelf.subtitleArr mutableCopy]; // subtitles
                    weakSelf.player.watchState = weakSelf.watchState ? weakSelf.watchState : weakSelf.lesson.watchStatModel;
                    weakSelf.player.seekTime = weakSelf.watchState ? weakSelf.watchState.playPosition : weakSelf.lesson.watchStatModel.playPosition; // 从上次位置播放
                    [weakSelf.player setVideoURL:[NSURL URLWithString:weakSelf.lesson.videoUrl] withTableView:weakSelf.tableView AtIndexPath:weakIndexPath withImageViewTag:101];
                    [weakSelf.player addPlayerToCellImageView:weakCell.videoBgView];
                    weakSelf.player.placeholderImageName = @"moren";
                    [weakSelf.player autoPlayTheVideo];
                    weakSelf.player.questionArr = [weakSelf.lesson.videoQuestionArr mutableCopy]; // question
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YOU_ARE_USING_MOBILE_NETWORK", nil) delegate:weakSelf cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
                    alertView.tag = 1000;
                    [alertView show];
                }
            };
            [self.tableView layoutIfNeeded];
            return cell;
        } else if (indexPath.row == 1) {
            SMTeacherIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:IntroCellReuseIdentifier forIndexPath:indexPath];
            cell.lesson = self.lesson;
            cell.delegate = self;
            [self.tableView layoutIfNeeded];
            return cell;
        }
    if (self.lesson.relatedCourseArr.count != 0) {
        if (indexPath.row == 2) {
            SMTagCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCellReuseIdentifier forIndexPath:indexPath];
            cell.relatedTagsArr = self.lesson.relatedCourseArr;
            __weak typeof(self) weakSelf = self;
            cell.tagBlock = ^(SMTagButton *button) {
                SMRelatedCourse *course = weakSelf.lesson.relatedCourseArr[button.tag];
                CourseViewController *courseVC = [[CourseViewController alloc] init];
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
                courseVC.ID = [NSString stringWithFormat:@"%zd", course.ID];
                [weakSelf.navigationController pushViewController:courseVC animated:YES];
                [weakSelf.player resetPlayer];
                weakSelf.player = nil;
            };
            [cell layoutIfNeeded];
            return cell;
        }
        if (self.lesson.relatedMaterialArr.count != 0) {
            if (indexPath.row == 3) {
                SMTagCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCellReuseIdentifier forIndexPath:indexPath];
                __weak typeof(self) weakSelf = self;
                cell.materialBlock = ^(SMTagButton *button) {
                    SMRelatedMaterial *material = weakSelf.lesson.relatedMaterialArr[button.tag];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:material.url]];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
                    [weakSelf.player resetPlayer];
                    weakSelf.player = nil;
                };
                cell.relatedMaterialArr = self.lesson.relatedMaterialArr;
                [self.tableView layoutIfNeeded];
                return cell;
            } else if (indexPath.row == 4) {
                SMRelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:relatedCellReuseIdentifier forIndexPath:indexPath];
                self.relatedCell = cell;
                cell.sugLessonsArr = self.suggestLessonArr;
                cell.commentCount = self.comment.commentsArr.count;
                cell.delegate = self;
                [self.tableView layoutIfNeeded];
                return cell;
            } else {
                SMDetailComment * comment = self.comment.commentsArr[indexPath.row - 5];
                if (comment.isReply) {
                    SMReplyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ReplyCommentCellReuseIdentifier forIndexPath:indexPath];
                    cell.comment = self.comment.commentsArr[indexPath.row - 5];
                    [self.tableView layoutIfNeeded];
                    return cell;
                }else {
                    SMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellReuseIdentifier forIndexPath:indexPath];
                    cell.comment = self.comment.commentsArr[indexPath.row - 5];
                    [self.tableView layoutIfNeeded];
                    return cell;
                }
            }
        } else {
            if (indexPath.row == 3) {
                SMRelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:relatedCellReuseIdentifier forIndexPath:indexPath];
                self.relatedCell = cell;
                cell.sugLessonsArr = self.suggestLessonArr;
                cell.commentCount = self.comment.commentsArr.count;
                cell.delegate = self;
                [self.tableView layoutIfNeeded];
                return cell;
            } else {
                SMDetailComment * comment = self.comment.commentsArr[indexPath.row - 4];
                if (comment.isReply) {
                    SMReplyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ReplyCommentCellReuseIdentifier forIndexPath:indexPath];
                    cell.comment = self.comment.commentsArr[indexPath.row - 4];
                    [self.tableView layoutIfNeeded];
                    return cell;
                }else {
                    SMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellReuseIdentifier forIndexPath:indexPath];
                    cell.comment = self.comment.commentsArr[indexPath.row - 4];
                    [self.tableView layoutIfNeeded];
                    return cell;
                }
            }
        }
    }else {
        if (self.lesson.relatedMaterialArr.count != 0) {
            if (indexPath.row == 2) {
                SMTagCell *cell = [tableView dequeueReusableCellWithIdentifier:tagCellReuseIdentifier forIndexPath:indexPath];
                __weak typeof(self) weakSelf = self;
                cell.materialBlock = ^(SMTagButton *button) {
                    SMRelatedMaterial *material = weakSelf.lesson.relatedMaterialArr[button.tag];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:material.url]];
                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
                    [weakSelf.player resetPlayer];
                    weakSelf.player = nil;
                };
                cell.relatedMaterialArr = self.lesson.relatedMaterialArr;
                [self.tableView layoutIfNeeded];
                return cell;
            } else if (indexPath.row == 3) {
                SMRelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:relatedCellReuseIdentifier forIndexPath:indexPath];
                self.relatedCell = cell;
                cell.sugLessonsArr = self.suggestLessonArr;
                cell.commentCount = self.comment.commentsArr.count;
                cell.delegate = self;
                [self.tableView layoutIfNeeded];
                return cell;
            } else {
                SMDetailComment * comment = self.comment.commentsArr[indexPath.row - 4];
                if (comment.isReply) {
                    SMReplyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ReplyCommentCellReuseIdentifier forIndexPath:indexPath];
                    cell.comment = self.comment.commentsArr[indexPath.row - 4];
                    [self.tableView layoutIfNeeded];
                    return cell;
                }else {
                    SMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellReuseIdentifier forIndexPath:indexPath];
                    cell.comment = self.comment.commentsArr[indexPath.row - 4];
                    [self.tableView layoutIfNeeded];
                    return cell;
                }
            }
        } else {
            if (indexPath.row == 2) {
                SMRelatedCell *cell = [tableView dequeueReusableCellWithIdentifier:relatedCellReuseIdentifier forIndexPath:indexPath];
                self.relatedCell = cell;
                cell.sugLessonsArr = self.suggestLessonArr;
                cell.commentCount = self.comment.commentsArr.count;
                cell.delegate = self;
                [self.tableView layoutIfNeeded];
                return cell;
            } else {
                SMDetailComment * comment = self.comment.commentsArr[indexPath.row - 3];
                if (comment.isReply) {
                    SMReplyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ReplyCommentCellReuseIdentifier forIndexPath:indexPath];
                    cell.comment = self.comment.commentsArr[indexPath.row - 3];
                    [self.tableView layoutIfNeeded];
                    return cell;
                }else {
                    SMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellReuseIdentifier forIndexPath:indexPath];
                    cell.comment = self.comment.commentsArr[indexPath.row - 3];
                    [self.tableView layoutIfNeeded];
                    return cell;
                }
            }
        }

    }
    
    return nil;
}

#pragma mark - UItableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 230;
    }
    if (indexPath.row == 1) {
        return 160;
    }
    if (self.lesson.relatedCourseArr.count != 0) {
        if (indexPath.row == 2) {
            return 250;
        }
        if (self.lesson.relatedMaterialArr.count != 0) {
            if (indexPath.row == 3) {
                return 245;
            } else if (indexPath.row == 4) {
                return 200;
            } else {
                SMDetailComment * comment = self.comment.commentsArr[indexPath.row - 5];
                if (comment.isReply) {
                    return 140;
                }else {
                    return 70;
                }
            }
        } else {
            if (indexPath.row == 3) {
                return 245;
            } else {
                SMDetailComment * comment = self.comment.commentsArr[indexPath.row - 4];
                if (comment.isReply) {
                    return 140;
                }else {
                    return 70;
                }
            }
        }
    }else {
        if (self.lesson.relatedMaterialArr.count != 0) {
            if (indexPath.row == 2) {
                return 245;
            } else if (indexPath.row == 3) {
                return 200;
            } else {
                SMDetailComment * comment = self.comment.commentsArr[indexPath.row - 4];
                if (comment.isReply) {
                    return 140;
                }else {
                    return 70;
                }
            }
        } else {
            if (indexPath.row == 2) {
                return 245;
            } else {
                SMDetailComment * comment = self.comment.commentsArr[indexPath.row - 3];
                if (comment.isReply) {
                    return 140;
                }else {
                    return 70;
                }
            }
        }
    }
}

#pragma mark - auto  play
- (void)autoPlayVideo
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isContinuous"] intValue] == 1 && [[self getNetWorkStates] isEqualToString:@"5"] && !self.player) {
        [self createPlayer];
    }
}

- (void)createPlayer
{
    self.player = [ZFPlayerView sharedPlayerView];
    self.player.userInteractionEnabled = YES;
    self.player.lesson = self.lesson;
    self.player.subtitleArr = [self.subtitleArr mutableCopy]; // subtitles
    self.player.watchState = self.watchState ? self.watchState: self.lesson.watchStatModel;
    self.player.seekTime = self.watchState ? self.watchState.playPosition : self.lesson.watchStatModel.playPosition; // 从上次位置播放
    [self.player setVideoURL:[NSURL URLWithString:self.lesson.videoUrl] withTableView:self.tableView AtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withImageViewTag:101];
    [self.player addPlayerToCellImageView:self.videoCell.videoBgView];
    self.player.placeholderImageName = @"moren";
    [self.player autoPlayTheVideo];
    self.player.questionArr = [self.lesson.videoQuestionArr mutableCopy]; // question
}

#pragma mark - SMTeacherIntroCellDelegate
- (void)introCellButtonDidClick:(UIButton *)button
{
    if (button.tag == 0) { // likeBtn
        button.selected = !button.selected;
        if (button.selected) {
            [SMNetWork sendRequestWithOperationManager:self.manager method:@"put" pathComponentsArr:@[@"/v2/lessons/", self.lessonID, @"/like"] parameters:nil success:nil failure:nil];
        } else {
            [SMNetWork sendRequestWithOperationManager:self.manager method:@"delete" pathComponentsArr:@[@"/v2/lessons/", self.lessonID, @"/like"] parameters:nil success:nil failure:nil];
        }
    } else if (button.tag == 1) { // share Btn
        NSString *shareText = self.lesson.shareUrl;  //分享内嵌文字
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKEnableUseClientShare];
        
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@\n%@",self.lesson.title,self.lesson.introduction] images:@[self.lesson.shareImg] url:[NSURL URLWithString:shareText] title:NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil) type:SSDKContentTypeAuto];
        [shareParams SSDKSetupWhatsAppParamsByText:[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil),shareText] image:nil audio:nil video:nil menuDisplayPoint:CGPointMake(0, 0) type:SSDKContentTypeText];
        [shareParams SSDKSetupFacebookParamsByText:[NSString stringWithFormat:@"%@\n%@\n%@",NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil),self.lesson.title,shareText] image:self.lesson.shareImg type:SSDKContentTypeAuto];
        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@\n%@",self.lesson.title,self.lesson.introduction] title:NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil) image:nil url:[NSURL URLWithString:shareText] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeWebPage];
        [shareParams SSDKSetupSMSParamsByText:[NSString stringWithFormat:@"%@\n%@\n%@",NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil),self.lesson.title,shareText] title:NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil)  images:nil attachments:nil recipients:nil type:SSDKContentTypeText];
        [shareParams SSDKSetupMailParamsByText:[NSString stringWithFormat:@"%@\n%@\n%@",NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil),self.lesson.title,shareText] title:NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil) images:nil attachments:nil recipients:nil ccRecipients:nil bccRecipients:nil type:SSDKContentTypeText];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
        [ShareSDK showShareActionSheet:button items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       self.platform = [NSString stringWithFormat:@"%lu",(unsigned long)platformType];
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               self.status = @"3";
                               [self shareLessons];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               self.status = @"2";
                               [self shareLessons];
                               break;
                           }
                           case SSDKResponseStateCancel:
                           {
                               self.status = @"1";
                               [self shareLessons];
                               break;
                           }
                           default:
                               break;
                       }
                   }];
    } else if (button.tag == 2) { // download Btn
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isVIP = [[userDefaults objectForKey:@"premium"] boolValue];
        if (isVIP) {
            //是vip，判断网络
            if ([[self getNetWorkStates] isEqualToString:@"5"]) { // WI-FI
                NSInteger downloadLimit = [[userDefaults objectForKey:@"downloadLimit"] integerValue];
                if ([ZFDownloadManager sharedDownloadManager].finishedlist.count + [ZFDownloadManager sharedDownloadManager].filelist.count < downloadLimit) {
                    [self confirmDownload];
                } else {
                    MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    notice.mode = MBProgressHUDModeText;
                    notice.labelText = [NSString stringWithFormat:@"%@%ld%@",NSLocalizedString(@"YOU_CAN_ONLY_DOWNLOAD_X_", nil),(long)downloadLimit,NSLocalizedString(@"X_VIDEOS", nil)];
                    notice.yOffset = -30;
                    [notice hide:YES afterDelay:5.0];
                }
                
            }else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YOU_ARE_USING_MOBILE_NETWORK", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
                alertView.tag = 2000;
                [alertView show];
            }
        }else {
            //不是vip，跳转购买界面
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YOU_CAN_ONLY_DOWNLOAD_AFTER_SUBSCRIPTION", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            alertView.tag = 200;
            [alertView show];
        }
    } else if (button.tag == 3) { // shop Btn
        SMRelatedProduct *product = self.lesson.relatedProductArr[0];
        CourseDetailsWebViewController *dwVC = [[CourseDetailsWebViewController alloc] init];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        dwVC.urlStr = product.url;
        dwVC.titleStr = product.title;
        [self.navigationController pushViewController:dwVC animated:YES];
        [self.player resetPlayer];
        self.player = nil;
    }
}

- (void)introCellTeacherIconTap:(UIImageView *)imageView
{
    YGMasterMainViewController *teacherVC = [[YGMasterMainViewController alloc] init];
    teacherVC.teacherID = [NSString stringWithFormat:@"%zd", self.lesson.teacherModel.ID];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.player resetPlayer];
    [self.navigationController pushViewController:teacherVC animated:YES];
}

#pragma mark - download method
-(void)confirmDownload
{
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.lesson.videoUrl]] delegate:self];
    [connection start];
    
    SMDownloadController *DownloadVc = [[SMDownloadController alloc] init];
    [self.navigationController pushViewController:DownloadVc animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [self.player resetPlayer];
}
- (void)downloadVideoWithURL:(NSURL *)url defaultImage:(UIImage *)image videoDuration:(CGFloat)duration
{
    NSString *fileName = [self.lesson.title stringByAppendingString:@".mp4"];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:[url absoluteString] filename:fileName fileimage:image videoDuration:duration fileID:self.lessonID];
    [ZFDownloadManager sharedDownloadManager].maxCount = 3;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [connection cancel];
    if (self.videoImage) {
        [self downloadVideoWithURL:response.URL defaultImage:self.videoImage videoDuration:self.lesson.videoDuration];
    } else {
        [[[UIImageView alloc] init] sd_setImageWithURL:[NSURL URLWithString:self.lesson.thumb] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self downloadVideoWithURL:response.URL defaultImage:image videoDuration:self.lesson.videoDuration];
        }];
    }
}

#pragma mark - SMRelatedCellDelegate
- (void)relatedCellDidClick:(NSInteger)cellIndex
{
    SMSuggestLessson *sugLesson = self.suggestLessonArr[cellIndex];
    SMLessonDetailController *lDVC = [[SMLessonDetailController alloc] init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    lDVC.lessonID = [NSString stringWithFormat:@"%zd", sugLesson.ID];
    [self.navigationController pushViewController:lDVC animated:YES];
    [self.player resetPlayer];
    self.player = nil;
}

#pragma mark - get current network mode
-(NSString *)getNetWorkStates
{
    //判断网络
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }
    NSNumber *num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    NSString *nettype = [NSString stringWithFormat:@"%@",num];
    return nettype;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:@"smevent"]) {
        if ([[url host] isEqualToString:@"continue_lesson"] || [[url host] isEqualToString:@"skip_question"]) { // 跳过、继续播放
            // remove webView
            [webView removeFromSuperview];
            self.webView = nil;
            // 通知代理继续播放
            [[NSNotificationCenter defaultCenter] postNotificationName:SMLocalVideoBeginPlayNotification object:nil];
        }
    }
    
    return YES;
}
#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            VIPShopViewController * VC = [[VIPShopViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            [self.player resetPlayer];
        }
    }
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self createPlayer];
        }
    }
    if (alertView.tag == 2000) {
        if (buttonIndex == 1) {
            [self confirmDownload];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentOffset.y >= SMScreenWidth * 9 / 32) {
        self.player.userInteractionEnabled = NO;
    } else {
        self.player.userInteractionEnabled = YES;
    }
    
    if (self.tableView.contentOffset.y >= SMScreenWidth * 9 / 16) {
        [self.player resetPlayer];
        self.player = nil;
    }
}
#pragma mark - UITextfiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.input.text isEqualToString:@" "] || [self.input.text isEqualToString:@""]) { return NO; };
    [[PiwikTracker sharedInstance] sendEventWithCategory:@"click" action:@"comment" name:@"event_comment" value:@(2)];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view endEditing:YES];
    // 发送评论
    [self sendCommentData];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.returnKeyType = UIReturnKeySend;
}

#pragma mark - dealloc
- (void)dealloc
{
    SMLog(@"-- SMLessonDetail 挂了 ---");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player resetPlayer];
    self.player = nil;
}

@end
