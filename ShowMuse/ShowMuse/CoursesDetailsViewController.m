//
//  CoursesDetailsViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/16.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "CoursesDetailsViewController.h"

#import "CoursesDetailsTableViewCell.h"

#import "DetailsNetWork.h"

#import "UIButton+WebCache.h"

#import "UIImageView+WebCache.h"

#import "JCTagView.h"

#import "RelatedCoursesModel.h"

#import "LessonSuggested.h"

#import "CourseViewController.h"

#import "TokenManager.h"

#import "AppDelegate.h"

#import "LoginViewController.h"

#import "RelatedProductsModel.h"

#import "CourseDetailsWebViewController.h"

#import "YGMasterMainViewController.h"

#import "Comments.h"

#import "CommentsDetailsModel.h"

#import "Materials.h"

#import "ApisTextView.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import "LessonModel.h"
#import "SMWatchState.h"
#import "SMVideoQuestion.h"
#import "VIPShopViewController.h"
#import "MBProgressHUD.h"
//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ZFDownloadManager.h>
#import "SMDownloadController.h"
#import "PiwikTracker.h"

@interface CoursesDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,RelatedCoursesDelegate,UIAlertViewDelegate,UITextViewDelegate, CoursesDetailsCellDelegate, NSURLConnectionDataDelegate>
{
    NSMutableArray * lessonRelatedArray;
    float relatedHeight;
    float materialsHeight;
    NSMutableArray * lessonSuggestedArray;
    UIScrollView * scrollView;
    
    Comments * model;
    
    ApisTextView * textV;
    
    int key_height;
    
    UILabel * lab;
    
    UIButton * sendButton;
    
    NSString * commentStr;
    
    UIActivityIndicatorView * activity;
    
    float titleHeight;
    
    int screenWidth;

    UILabel * titleLabel;
    UILabel * introduceLabel;
    
    BOOL isKeyboard;
    
    
    NSString * platform;
    NSString * status;

    JCTagView *TagView;
    JCTagView *articleTagView;
    
    int tableNumber;
}

/** 保存所有问题模型 */
@property (strong, nonatomic) NSMutableArray *questionsArr;

@property (strong, nonatomic) UITableView *tableView;
/** 记录当前手机的屏幕宽度 */
@property (nonatomic,assign) CGFloat screenW;
/** 记录当前手机的屏幕高度 */
@property (nonatomic,assign) CGFloat screenH;
/** 记录顶部cell的图片 */
@property (strong, nonatomic) UIImage *videoImage;

@end

@implementation CoursesDetailsViewController

- (NSMutableArray *)questionsArr
{

    if (!_questionsArr) {
        _questionsArr = [NSMutableArray array];
    }
    return _questionsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    tableNumber = 5;
    self.view.backgroundColor = colorWithRGB(240, 243, 245);
    screenWidth = SMScreenWidth;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRequestData:) name:SMVIPShopPurchaseSuccessNotification object:nil];
    
    UILabel *titleLanel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLanel.text = NSLocalizedString(@"LESSONS_DETAILS_PAGE_DETAILS", nil);
    titleLanel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    titleLanel.textAlignment = NSTextAlignmentCenter;
    titleLanel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLanel;

    // record the phone screenW and screenH
    self.screenW = SMScreenWidth;
    self.screenH = SMScreenHeight;
    
//    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    menuBtn.frame = CGRectMake(0, 0, 20, 18);
//    [menuBtn setBackgroundImage:[UIImage imageNamed:@"icon_details_back.png"] forState:UIControlStateNormal];
//    [menuBtn addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];

    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 18);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_course_home.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SMScreenWidth, SMScreenHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = colorWithRGB(240, 243, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.alpha = 0;
    [self.view addSubview:self.tableView];
    
    
    //底部评论view；
    self.tView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width, 40)];
    
    self.tView.backgroundColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1];
    self.tView.alpha = 0;
    [self.view addSubview:self.tView];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    lessonRelatedArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self getLessonData];
    
    
    textV = [[ApisTextView alloc] initWithFrame:CGRectMake(20, 3, [UIScreen mainScreen].bounds.size.width-90, 35)];
//    textV.placeHolder = @"123";
    textV.delegate = self;
    textV.font = [UIFont systemFontOfSize:16.0];
    textV.tintColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
    textV.layer.cornerRadius = 35/2;
    textV.keyboardType = UIKeyboardTypeDefault;
    [self.tView addSubview:textV];
    
    
    lab = [[UILabel alloc] initWithFrame:CGRectMake(30, 8, [UIScreen mainScreen].bounds.size.width-90, 26)];
    lab.text = NSLocalizedString(@"LESSONS_DETAILS_PAGE_COMMENTS", nil);
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
    [self.tView addSubview:lab];
    
    sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sendButton.backgroundColor = [UIColor clearColor];
    sendButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-60, self.tView.bounds.size.height-35, 50, 30);
    [sendButton setTitle:NSLocalizedString(@"LESSONS_DETAILS_PAGE_SEND", nil) forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.tView addSubview:sendButton];
    
    
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    [activity setUserInteractionEnabled:YES];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [sendButton addSubview:activity];

    [[PiwikTracker sharedInstance] sendViews:@"lessons",_lessonID, nil];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // recieve notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBookmarkData:) name:SMVideoPlayBookmarkCountNotification object:nil];
    // receive notification to push purchase page
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPurchasePage) name:SMSubscribeAMemberShipNotification object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.alpha=1;
//    self.navigationController.navigationBar.translucent = YES;
    
    if (model.thread_isCommentable) {
        self.tableView.frame = CGRectMake(0, 0, self.screenW, self.screenH - 40);
    }else {
        self.tableView.frame = CGRectMake(0, 0, self.screenW, self.screenH);
    }
    [self.tableView reloadData];
    
}

#pragma mark - receive bookmarks data
- (void)receiveBookmarkData:(NSNotification *)note
{
    // dictionary transfer to model and save
    NSDictionary *notification = [note userInfo];
    self.watchState = [SMWatchState stateWithDict:notification];
    
}

#pragma mark - push to purchase page
- (void)pushPurchasePage
{
    VIPShopViewController *vipVC = [[VIPShopViewController alloc] init];
    [self.navigationController pushViewController:vipVC animated:YES];
}

#pragma mark - 通知方法
- (void)reloadRequestData:(NSNotification *)note {
    [self getLessonData];
}

#pragma mark - 获取视频详情数据
-(void)getLessonData {
    [DetailsNetWork lessoDetailsWithLessonID:self.lessonID CompleteLessonDetails:^(id json, NSError *error) {
        if (json) {
            
            // watchState dictionary transfers to model
            self.watchState = [SMWatchState stateWithDict:json[@"userWatchStat"]];
            // videoQuestion dict transfers to model
            NSArray *questionArr = json[@"videoQuestions"];
            for (NSDictionary *questionDict in questionArr) {
                
                SMVideoQuestion *question = [SMVideoQuestion questionWithDict:questionDict];
                [self.questionsArr addObject:question];
                
            }
            
            self.lesson = [[LessonModel alloc] initWithDictionary:json];
            [self.lesson.relatedCoursesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                RelatedCoursesModel * RCmodel = obj;
                [lessonRelatedArray addObject:RCmodel.title];
            }];
            self.tableView.alpha = 1;
            if (self.lesson.relatedMaterials.count > 0) {
                tableNumber = 6;
            }else {
                tableNumber = 5;
            }
            
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self commentsRequestWithID:self.lesson.commentsThread_id];
        }else {
            [SMNavigationController modalGlobalLoginViewController];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }
        NSDictionary * errDic = (NSDictionary *)error;
        if ([errDic[@"code"] intValue] == 403) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:errDic[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            alertView.tag = 500;
            [alertView show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    lessonSuggestedArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self getOtherVideo];//获取其他视频
}

#pragma mark - 获取其他视频请求
-(void)getOtherVideo {
    [DetailsNetWork lessonSuggestedwithLessonID:self.lessonID CompleteLessonDetails:^(id json, NSError *error) {
        if (error == nil) {
            [json[@"suggested_lessons"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                LessonSuggested * lessonSuggested = [[LessonSuggested alloc] initWithDictionary:obj];
                [lessonSuggestedArray addObject:lessonSuggested];
                [self.tableView reloadData];
            }];
        }
    }];

}

#pragma mark - touches
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    isKeyboard = YES;
    [self textViewFrame];
}

-(void)textViewFrame {
    self.tView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-key_height-self.tView.bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.tView.bounds.size.height);
}

- (void)textViewDidChange:(UITextView *)textView {
    commentStr = textView.text;
    if (![textV.text isEqualToString:@""]) {
        lab.alpha = 0;
    }else {
        lab.alpha = 1;
    }
    CGFloat height = [self creatBubbleCGrectWithString:textView.text];
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    key_height = height;
    float h = self.tView.bounds.size.height;
    if (isKeyboard) {
        self.tView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-height-h, [UIScreen mainScreen].bounds.size.width, h);
    }
}



//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    float viewHeight = self.tView.bounds.size.height;
    
    self.tView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-viewHeight, [UIScreen mainScreen].bounds.size.width, viewHeight);
    isKeyboard = NO;
    
}



#pragma mark - 评论请求
-(void)commentsRequestWithID:(NSString *)ID {
    [DetailsNetWork commentsWithCommentsID:ID CompleteLessonDetails:^(id json, NSError *error) {
//        NSLog(@"评论******%@********%@",error,json);
        if (error == nil) {
            model = [[Comments alloc] initWithDictionary:json];
            if (model.thread_isCommentable) {
                self.tView.alpha = 1;
                self.tableView.frame = CGRectMake(0, 0, SMScreenWidth, SMScreenHeight-40);
            }
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}



#pragma mark - 表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return tableNumber;
    }
    if (section == 1) {
        if (model.commentsArray.count > 0) {
            return 1+model.commentsArray.count;
        }
        if (model.commentsArray.count == 0) {
            return 1;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CoursesDetailsTableViewCell * cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * str = @"detailsCell0";
            cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CoursesDetailsTableViewCell" owner:nil options:nil]objectAtIndex:0];
            }
            if (![self.lesson.thumb isEqualToString:@""]) {
                [cell.bagImage sd_setImageWithURL:[NSURL URLWithString:self.lesson.thumb]];
                self.videoImage = cell.bagImage.image;
            }
            if ([self.lesson.videoContent isEqualToString:@"trailer"]) {
                cell.promptLabel.alpha = 1;
                cell.openVIPButton.alpha = 1;
            }else {
                cell.promptLabel.alpha = 0;
                cell.openVIPButton.alpha = 0;
            }
            NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"THIS_IS_TRAILER", nil)];
            NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:NSLocalizedString(@"SUBSCRIBE_COLOR", nil)].location, [[noteStr string] rangeOfString:NSLocalizedString(@"SUBSCRIBE_COLOR", nil)].length);
            [noteStr addAttribute:NSForegroundColorAttributeName value:colorWithRGBA(89, 212, 234, 1) range:redRange];
            [cell.promptLabel setAttributedText:noteStr];
//            [cell.promptLabel sizeToFit];
            [cell.openVIPButton addTarget:self action:@selector(openVIPButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 1) {
            static NSString * str = @"detailsCell1";
            cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CoursesDetailsTableViewCell" owner:nil options:nil]objectAtIndex:1];
            }
            [titleLabel removeFromSuperview];
            [introduceLabel removeFromSuperview];
            CGRect rect=[self.lesson.title boundingRectWithSize:CGSizeMake(SMScreenWidth-60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
            titleHeight = rect.size.height+5;
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 15, SMScreenWidth-60, titleHeight)];
            titleLabel.numberOfLines = 0;
            titleLabel.text = self.lesson.title;
            titleLabel.textColor = colorWithRGBA(48, 48, 48, 0.8);
//            titleLabel.backgroundColor = [UIColor redColor];
            [cell addSubview:titleLabel];
            
            float H = [self creatBubbleCGrectWithString:self.lesson.introduction];
            introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 15+titleHeight, SMScreenWidth-80, H)];
            introduceLabel.numberOfLines = 0;
            introduceLabel.text = self.lesson.introduction;
            introduceLabel.textColor = colorWithRGBA(153, 154, 151, 1);
            introduceLabel.font = [UIFont systemFontOfSize:15.0];
            [cell addSubview:introduceLabel];
            if (self.lesson.isLikedByUser) {
                [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"icon_details_like_on.png"] forState:UIControlStateNormal];
            }else {
                [cell.likeButton setBackgroundImage:[UIImage imageNamed:@"icon_details_like_off.png"] forState:UIControlStateNormal];
            }
            cell.likeButton.tag = self.lesson.ID;
            [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 2) {
            static NSString * str = @"detailsCell2";
            cell = [tableView dequeueReusableCellWithIdentifier:str];
            cell.delegate = self;
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CoursesDetailsTableViewCell" owner:nil options:nil]objectAtIndex:2];
            }
            if (![self.lesson.teacher_avatar isEqualToString:@""]) {
                [cell.teacherImage sd_setBackgroundImageWithURL:[NSURL URLWithString:self.lesson.teacher_avatar] forState:UIControlStateNormal];
            }
            
            cell.teacherImage.tag = self.lesson.teacher_id;
            [cell.teacherImage addTarget:self action:@selector(teacherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.teacherNameLabel.text = self.lesson.teacher_name;
            if (self.lesson.relatedProductsArray.count > 0) {
                cell.productsButton.alpha = 1;
                cell.shopImage.alpha = 1;
                cell.shopLabel.alpha = 1;
            }
            if (self.lesson.relatedProductsArray.count == 0) {
                cell.productsButton.alpha = 0;
                cell.shopImage.alpha = 0;
                cell.shopLabel.alpha = 0;
            }
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if ([[userDefaults objectForKey:@"videoDownloads_enable"] boolValue]){
                cell.downloadButton.alpha = 1;
                cell.downloadImage.alpha = 1;
            }else {
                cell.downloadButton.alpha = 0;
                cell.downloadImage.alpha = 0;
            }
            cell.shopLabel.text = NSLocalizedString(@"LESSONS_DETAILS_PAGE_SHOP", nil);
            cell.shareLabel.text = NSLocalizedString(@"LESSONS_DETAILS_PAGE_SHARE", nil);
            cell.tagLabel.text = NSLocalizedString(@"LESSONS_DETAILS_PAGE_TAG", nil);
            [cell.productsButton addTarget:self action:@selector(productsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.downloadButton setTitle:NSLocalizedString(@"DOWNLOAD_PAGE_TITLE", nil) forState:UIControlStateNormal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (indexPath.row == 3) {
            static NSString * str = @"detailsCell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
                cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:243/255.0 blue:245/255.0 alpha:1];
            }
            if (lessonRelatedArray.count > 0) {
                [TagView removeAllSubviews];
                TagView = [[JCTagView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
                TagView.tag = 4000;
                TagView.JCSignalTagColor = [UIColor colorWithRed:215/255.0 green:237/255.0 blue:243/255.0 alpha:1];
                TagView.JCbackgroundColor = [UIColor clearColor];
                TagView.delegate = self;
                //            [JCView setArrayTagWithLabelArray:lessonRelatedArray];
                [TagView setArrayTagWithLabelArray:self.lesson.relatedCoursesArray];
                relatedHeight = TagView.bounds.size.height;
                [cell addSubview:TagView];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        if (tableNumber == 6) {
            if (indexPath.row == tableNumber-2) {
                static NSString * str = @"detailsCell6";
                cell = [tableView dequeueReusableCellWithIdentifier:str];
                if (!cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"CoursesDetailsTableViewCell" owner:nil options:nil]objectAtIndex:6];
                }
                if (lessonRelatedArray.count > 0) {
                    [articleTagView removeAllSubviews];
                    articleTagView = [[JCTagView alloc] initWithFrame:CGRectMake(0, 37, [UIScreen mainScreen].bounds.size.width, 0)];
                    articleTagView.isAddLin = YES;
                    articleTagView.tag = 5000;
                    articleTagView.JCSignalTagColor = [UIColor clearColor];
                    articleTagView.JCbackgroundColor = [UIColor clearColor];
                    articleTagView.delegate = self;
                    //            [JCView setArrayTagWithLabelArray:lessonRelatedArray];
                    [articleTagView setArrayTagWithLabelArray:self.lesson.relatedMaterialsArray];
                    materialsHeight = articleTagView.bounds.size.height;
                    [cell addSubview:articleTagView];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        if (indexPath.row == tableNumber-1) {
            static NSString * str = @"detailsCell3";
            cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CoursesDetailsTableViewCell" owner:nil options:nil]objectAtIndex:3];
                
            }
            [scrollView removeAllSubviews];
            scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 105)];
            scrollView.pagingEnabled = YES;
            [cell.scrollView addSubview:scrollView];
            cell.recommendedLabel.text = NSLocalizedString(@"LESSONS_DETAILS_PAGE_RECOMMENDED_VIDEOS", nil);
            if (lessonSuggestedArray.count > 0) {
                scrollView.contentSize = CGSizeMake((115+5)*lessonSuggestedArray.count-5, 105);
                for (int i =0; i<lessonSuggestedArray.count;i++) {
                    LessonSuggested * lessonSuggested = lessonSuggestedArray[i];
                    UIButton * imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    imageButton.frame = CGRectMake((115+5)*i, 0, 115, 65);
                    [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:lessonSuggested.thumb] forState:UIControlStateNormal];
                    
                    imageButton.tag = i;
                    [imageButton addTarget:self action:@selector(scrollViewImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [scrollView addSubview:imageButton];
                    if (lessonSuggested.isLockedToUser) {
                        
                        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((115+5)*i+(115-20)/2, (65-20)/2, 20, 20)];
                        imageView.image = [UIImage imageNamed:@"icon_course_lock.png"];
                        [scrollView addSubview:imageView];
                    }else {
                        
                        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((115+5)*i+(115-20)/2, (65-20)/2, 20, 20)];
                        imageView.image = [UIImage imageNamed:@"icon_course_play.png"];
                        [scrollView addSubview:imageView];
                    }
                    
                    
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((115+5)*i, 70, 115, 35)];
//                    label.backgroundColor = [UIColor redColor];
                    label.numberOfLines = 0;
                    label.text = lessonSuggested.title;
                    label.textColor = [UIColor colorWithRed:82/255.0 green:82/255.0 blue:82/255.0 alpha:0.4];
                    
                    label.font = [UIFont systemFontOfSize:13.0];
                    label.textAlignment = NSTextAlignmentCenter;
//                    label.numberOfLines = 0;
                    [scrollView addSubview:label];
                    
                }
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.showsVerticalScrollIndicator = NO;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            static NSString * str = @"detailsCell4";
            cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CoursesDetailsTableViewCell" owner:nil options:nil]objectAtIndex:4];
            }
            cell.CommentsLabel.text = NSLocalizedString(@"LESSONS_DETAILS_PAGE_COMMENTS", nil);
            cell.numCommentableLabel.text = [NSString stringWithFormat:@"(%d)",model.thread_numComments];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            static NSString * str = @"detailsCell5";
            cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CoursesDetailsTableViewCell" owner:nil options:nil]objectAtIndex:5];
            }
            CommentsDetailsModel * commentssModel = model.commentsArray[indexPath.row-1];
            if (![commentssModel.user_avatar isEqualToString:@""]) {
                [cell.userAvatarImage sd_setImageWithURL:[NSURL URLWithString:commentssModel.user_avatar]];
            }
            cell.useerNameLabel.text = commentssModel.user_name;
            cell.createdAtLabel.text = commentssModel.createdAt;
            cell.bodyLabel.text = commentssModel.body;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return screenWidth*210/375;
        }
        if (indexPath.row == 1) {
            return [self creatBubbleCGrectWithString:self.lesson.introduction]+titleHeight+15;
        }
        if (indexPath.row == 2) {
            return 114;
        }
        if (indexPath.row == 3) {
            return relatedHeight;
        }
        if (tableNumber == 6) {
            if (indexPath.row == tableNumber-2) {
                return materialsHeight+37;
            }
        }
        if (indexPath.row == tableNumber-1) {
            return 170;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 44;
        }else {
            CommentsDetailsModel * commentssModel = model.commentsArray[indexPath.row-1];
            CGRect rect=[commentssModel.body boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-88, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            return ceilf(rect.size.height)+55;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section == 0 && indexPath.row == 0) { // 视频cell
         // 弹出需要的视频播放器
//        [self popupVideoPlayController];
        SMLog(@"dangqianwanglu--------%@",[self getNetWorkStates]);
        if ([[self getNetWorkStates] isEqualToString:@"5"]) {
            [self popupVideoPlayController];
        }else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YOU_ARE_USING_MOBILE_NETWORK", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            alertView.tag = 1000;
            [alertView show];

        }
    }
}

/**
 *  弹出视频播放控制器
 */
- (void)popupVideoPlayController
{
    
    if ([self.lesson.videoSource isEqualToString:@"youtube"]) {  // youtube视频
        
//        SMYouTubeVideoPlayController *videoPlayerViewController = [[SMYouTubeVideoPlayController alloc] initWithVideoIdentifier:self.lesson.videoUrl];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
//        [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
        
    } else if ([self.lesson.videoSource isEqualToString:@"youku"])  { // 优酷视频
        
    } else { // 我们的视频
        
//        SMLocalVideoController *lVC = [[SMLocalVideoController alloc] init];
////        lVC.videoUrl = self.lesson.videoUrl;
//        lVC.lesson = self.lesson;
//        lVC.watchState = self.watchState;
//        lVC.questionArr = self.questionsArr;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
//            [self.navigationController presentViewController:lVC animated:YES completion:nil];
//        } else {
//            [self.navigationController pushViewController:lVC animated:YES];
        
    }
    
    
}

#pragma mark - Notifications
- (void)moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:notification.object];
    MPMovieFinishReason finishReason = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    if (finishReason == MPMovieFinishReasonPlaybackError)
    {
        NSString *title = NSLocalizedString(@"Video Playback Error", @"Full screen video error alert - title");
        NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
        NSString *message = [NSString stringWithFormat:@"%@\n%@ (%@)", error.localizedDescription, error.domain, @(error.code)];
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Full screen video error alert - cancel button");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [alertView show];
    }
}



#pragma mark - likeButtonClick
-(void)likeButtonClick:(UIButton *)sender {
    
    NSString * str = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    if (self.lesson.isLikedByUser) {
        
        [DetailsNetWork lessonDelLikeLessonID:str CompleteLessonDetails:^(id json, NSError *error) {
            if (error == nil) {
//                [sender setBackgroundImage:[UIImage imageNamed:@"icon_details_like_off.png"] forState:UIControlStateNormal];
            }
            
        }];
        [sender setBackgroundImage:[UIImage imageNamed:@"icon_details_like_off.png"] forState:UIControlStateNormal];
    }else {
       
        [DetailsNetWork lessonLikeLessonID:str CompleteLessonDetails:^(id json, NSError *error) {
            if (error == nil) {
//                [sender setBackgroundImage:[UIImage imageNamed:@"icon_details_like_on.png"] forState:UIControlStateNormal];
            }
        }];
        [sender setBackgroundImage:[UIImage imageNamed:@"icon_details_like_on.png"] forState:UIControlStateNormal];
    }
    
    self.lesson.isLikedByUser = !self.lesson.isLikedByUser;
    
}


#pragma mark - 大师头像按钮
-(void)teacherButtonClick:(UIButton *)sender {
   
    
    YGMasterMainViewController * VC = [[YGMasterMainViewController alloc] init];
    VC.teacherID = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    [self.navigationController pushViewController:VC animated:YES];
    self.navigationController.navigationBar.translucent = NO;
}


#pragma mark - 商店按钮
-(void)productsButtonClick:(UIButton *)sender {
    
    if (self.lesson.relatedProductsArray.count > 0) {
        RelatedProductsModel * RCmodel = self.lesson.relatedProductsArray[0];
        CourseDetailsWebViewController * VC = [[CourseDetailsWebViewController alloc] init];
        VC.urlStr = RCmodel.url;
        VC.titleStr = RCmodel.title;
        
        [self.navigationController pushViewController:VC animated:YES];
        self.navigationController.navigationBar.translucent = NO;
    }
    
}

#pragma mark - 分享按钮
-(void)shareButtonClick:(UIButton *)sender {
    NSString *shareText = self.lesson.shareUrl;             //分享内嵌文字
   
    
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        [shareParams SSDKEnableUseClientShare];
        
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@\n%@",self.lesson.title,self.lesson.introduction]
                                         images:@[self.lesson.shareImg]
                                            url:[NSURL URLWithString:shareText]
                                          title:NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil)
                                           type:SSDKContentTypeAuto];
        [shareParams SSDKSetupWhatsAppParamsByText:[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil),shareText] image:nil audio:nil video:nil menuDisplayPoint:CGPointMake(0, 0) type:SSDKContentTypeText];
        [shareParams SSDKSetupFacebookParamsByText:[NSString stringWithFormat:@"%@\n%@\n%@",NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil),self.lesson.title,shareText] image:self.lesson.shareImg type:SSDKContentTypeAuto];
        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@\n%@",self.lesson.title,self.lesson.introduction] title:NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil) image:nil url:[NSURL URLWithString:shareText] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeWebPage];
        [shareParams SSDKSetupSMSParamsByText:[NSString stringWithFormat:@"%@\n%@\n%@",NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil),self.lesson.title,shareText] title:NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil)  images:nil attachments:nil recipients:nil type:SSDKContentTypeText];
        [shareParams SSDKSetupMailParamsByText:[NSString stringWithFormat:@"%@\n%@\n%@",NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil),self.lesson.title,shareText] title:NSLocalizedString(@"LEST_IS_LEARN_ON_SHOWMUSE", nil) images:nil attachments:nil recipients:nil ccRecipients:nil bccRecipients:nil type:SSDKContentTypeText];
    
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:sender //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       platform = [NSString stringWithFormat:@"%lu",(unsigned long)platformType];
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               
                               status = @"3";
                               [self shareLessons];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               status = @"2";
                               [self shareLessons];
                               break;
                           }
                           case SSDKResponseStateCancel:
                           {
                               status = @"1";
                               [self shareLessons];
                               break;
                           }
                           default:
                               break;
                       }
                       //发送服务器
                       
//                       [self shareLessons];
                    }];

}

#pragma mark - 分享后回调
-(void)shareLessons {
    [DetailsNetWork shareWithStatus:status platform:platform lessonID:self.lessonID CompleteLessonDetails:^(id json, NSError *error) {
        
    }];
}

#pragma mark - 发送按钮
-(void)sendButtonClick {
    [[PiwikTracker sharedInstance] sendEventWithCategory:@"click" action:@"comment" name:@"event_comment" value:@(2)];
    if (![textV.text isEqualToString:@""]) {
        [activity startAnimating];
        [sendButton setTitle:@"" forState:UIControlStateNormal];
//        NSLog(@"发送");
        
        [DetailsNetWork sendCommentsWithMessage:commentStr CommentsID:self.lesson.commentsThread_id CompleteLessonDetails:^(id json, NSError *error) {
            if (error == nil) {
                model = [[Comments alloc] initWithDictionary:json];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
                textV.text = @"";
                lab.alpha = 1;
                self.tView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width, 40);
                textV.frame = CGRectMake(20, 5, [UIScreen mainScreen].bounds.size.width-85, 35);
                sendButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-60, self.tView.bounds.size.height-35, 50, 30);
                [sendButton setTitle:NSLocalizedString(@"LESSONS_DETAILS_PAGE_SEND", nil) forState:UIControlStateNormal];
                [activity stopAnimating];
//                [sendButton removeAllSubviews];
                [self.view endEditing:YES];
            }else {
                NSDictionary * errors = (NSDictionary *)error;
                NSString * message = errors[@"message"];
                [[[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil] show];
                textV.text = @"";
                lab.alpha = 1;
                self.tView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width, 40);
                textV.frame = CGRectMake(20, 5, [UIScreen mainScreen].bounds.size.width-85, 35);
                sendButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-60, self.tView.bounds.size.height-35, 50, 30);
                [sendButton setTitle:NSLocalizedString(@"LESSONS_DETAILS_PAGE_SEND", nil) forState:UIControlStateNormal];
                [activity stopAnimating];
                [self.view endEditing:YES];

            }
            
        }];
    }else {
        [self.view endEditing:YES];
    }
}


#pragma mark - 滑动视图按钮的方法
-(void)scrollViewImageButtonClick:(UIButton *)sender {
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    NSString * messageLogin = [userDefaults objectForKey:@"40301"];
    NSString * messageVIP = [userDefaults objectForKey:@"40302"];

    
    LessonSuggested * lessonSuggested = lessonSuggestedArray[sender.tag];
    
    if (lessonSuggested.isLockedToUser) {
        //不能看
        if (![TokenManager getGuest]) {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:messageVIP delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            alertView.tag = 200;
            [alertView show];
        }else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:messageLogin delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            alertView.tag = 100;
            [alertView show];
        }
    }else {
        
        CoursesDetailsViewController * VC = [[CoursesDetailsViewController alloc] init];
        VC.lessonID = [NSString stringWithFormat:@"%d",lessonSuggested.ID];
//        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController pushViewController:VC animated:YES];

    }
}

#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            LoginViewController * VC = [LoginViewController sharedLoginController];
            VC.loginSucc = ^ {
                [tempAppDelegate gotoHomeViewController];
            };
            SMNavigationController * LoginNav = [[SMNavigationController alloc] initWithRootViewController:VC];
            LoginNav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            tempAppDelegate.window.rootViewController = LoginNav;
            [self presentViewController:LoginNav animated:YES completion:nil];
        }
    }
    if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            
            VIPShopViewController * VC = [[VIPShopViewController alloc] init];
            self.navigationController.navigationBar.translucent = NO;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    if (alertView.tag == 500) {
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self popupVideoPlayController];
        }
    }
    if (alertView.tag == 2000) {
        if (buttonIndex == 1) {
            [self confirmDownload];
        }
    }
}

#pragma mark - 开通VIP
-(void)openVIPButtonClick:(UIButton *)sender {
    VIPShopViewController * VC = [[VIPShopViewController alloc] init];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - 标签的代理方法
-(void)relatedCoursesWithTagView:(JCTagView *)tagView ID:(NSString *)ID {
    SMLog(@"标签的tag----%ld",tagView.tag);
    if (tagView.tag == 4000) {
        CourseViewController * VC = [[CourseViewController alloc] init];
        VC.ID = ID;
        [self.navigationController pushViewController:VC animated:YES];
        self.navigationController.navigationBar.translucent = NO;
    }else {
        SMLog(@"-点击文章标签-------%@",ID);
        int number = [ID intValue];
        Materials * materials = self.lesson.relatedMaterialsArray[number];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:materials.url]];
    }
}

#pragma mark - 计算高度
-(CGFloat)creatBubbleCGrectWithString:(NSString *)string
{
    CGRect rect=[string boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return ceilf(rect.size.height);
}

#pragma mark - 导航左侧返回按钮
- (void) openOrCloseLeftList {
    
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - 导航右侧主页按钮
-(void)rightButtonClick {
    [[PiwikTracker sharedInstance] sendEventWithCategory:@"click" action:@"mainmenu" name:@"event_mainmenu" value:@(2)];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - 获取当前网络
-(NSString *)getNetWorkStates{
    //判断网络
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            dataNetworkItemView = subview;
            break;
        }
    }
//    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
//    nettype = [num intValue];
    NSString * nettype = [NSString stringWithFormat:@"%@",num];
    return nettype;
}
#pragma mark - CoursesDetailsCellDelegate
- (void)courseDetailDownloadButtonDidClick:(UIButton *)button
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isVIP = [[userDefaults objectForKey:@"premium"] boolValue];
    if (isVIP) {
        //是vip，判断网络
        if ([[self getNetWorkStates] isEqualToString:@"5"]) {
            //是wifi
            NSInteger downloadLimit = [[userDefaults objectForKey:@"downloadLimit"] integerValue];
            if ([ZFDownloadManager sharedDownloadManager].finishedlist.count+[ZFDownloadManager sharedDownloadManager].filelist.count<downloadLimit) {
                [self confirmDownload];
            }else {
                MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                notice.mode = MBProgressHUDModeText;
                notice.labelText = [NSString stringWithFormat:@"%@%ld%@",NSLocalizedString(@"YOU_CAN_ONLY_DOWNLOAD_X_", nil),(long)downloadLimit,NSLocalizedString(@"X_VIDEOS", nil)];
                notice.yOffset = -30;
                [notice hide:YES afterDelay:5.0];
            }
            
        }else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YOU_ARE_USING_MOBILE_NETWORK", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
            alertView.tag = 2000;
            [alertView show];
        }
    }else {
        //不是vip，跳转购买界面
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"YOU_CAN_ONLY_DOWNLOAD_AFTER_SUBSCRIPTION", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"GLOBAL_ALERTVIEW_CANCEL", nil) otherButtonTitles:NSLocalizedString(@"GLOBAL_ALERTVIEW_CONFIRM", nil), nil];
        alertView.tag = 200;
        [alertView show];
    }
    
}
-(void)confirmDownload {
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.lesson.videoUrl]] delegate:self];
    [connection start];
    
    SMDownloadController *DownloadVc = [[SMDownloadController alloc] init];
    [self.navigationController pushViewController:DownloadVc animated:YES];
}
- (void)downloadVideoWithURL:(NSURL *)url defaultImage:(UIImage *)image videoDuration:(CGFloat)duration
{
    NSString *fileName = [self.lesson.title stringByAppendingString:@".mp4"];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:[url absoluteString] filename:fileName fileimage:image videoDuration:duration fileID:self.lessonID];
    [ZFDownloadManager sharedDownloadManager].maxCount = 3;
}

#pragma mark - NSURLConnectionDataDelegate
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

#pragma mark - 屏幕方向
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
#pragma mark - dealloc
- (void)dealloc
{
    // 移除注册
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
