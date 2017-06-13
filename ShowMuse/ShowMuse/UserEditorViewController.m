//
//  UserEditorViewController.m
//  ShowMuse
//
//  Created by show zh on 16/5/23.
//  Copyright © 2016年 show zh. All rights reserved.
//

#import "UserEditorViewController.h"

#import "UserEditorTableViewCell.h"

#import "PickerChoiceView.h"

#import "UserDetailsNetWork.h"

#import "UserDetaModel.h"

#import "UIImageView+WebCache.h"

#import "MBProgressHUD.h"

#import "SMDialog.h"


@interface UserEditorViewController ()<UITableViewDelegate,UITableViewDataSource,TFPickerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, SMDialogDelegate>
{
    NSArray * titleArray;
    
    NSDictionary * countryDic;
    
    NSInteger indexPathNumber;
    
    NSDictionary * userDetaDic;
    
    UserDetaModel * model;
    
    NSDictionary * educationDic;
    
    NSDictionary * maritalStatusDic;
    
    NSArray * educationKeyArray , * educationValuArray, * maritalStatusKeyArray, * maritalStatusValuArray, * countryKeyArray, * countryValuArray;
    
    NSMutableArray * sexButtonArray;
    
    UIImageView * userAvatar;
    
    NSString * _name, * _education, * _maritalStatus, * _country, * _dateOfBirth;
    
    BOOL isOK;
}


@end

@implementation UserEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navigationController.navigationBar.translucent = YES;
    
    countryDic = [[NSDictionary alloc] init];
    
    
    NSString *preferredLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"ACLanguageUtilLanguageIdentifier"];
    
//    SMLog(@"获取语言%@*********%@",preferredLang,curLanguage);
    if (/*[preferredLang rangeOfString:@"zh-Hans"].location !=NSNotFound*/[preferredLang containsString:@"zh-Hans"]) {
        countryDic = [self textWithJsonWithCountry:@"Mandarin"];
    }else if (/*[preferredLang rangeOfString:@"zh-Hant"].location !=NSNotFound || [preferredLang rangeOfString:@"zh-HK"].location !=NSNotFound || [preferredLang rangeOfString:@"zh-TW"].location !=NSNotFound*/[preferredLang containsString:@"zh-Hant"] || [preferredLang containsString:@"zh-HK"] || [preferredLang containsString:@"zh-TW"]) {
        countryDic = [self textWithJsonWithCountry:@"HK"];
    }else {
        countryDic = [self textWithJsonWithCountry:@"English"];
    }
    countryKeyArray = [countryDic allKeys];
    countryValuArray = [countryDic allValues];
    
    

    
    UILabel * titleLanel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLanel.text = NSLocalizedString(@"EDIT_PROFILE_PAGE_EDIT_PROFILE", nil);
    titleLanel.font = [UIFont fontWithName:@"HiraginoSans-W3" size:20];
    titleLanel.textAlignment = NSTextAlignmentCenter;
    titleLanel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLanel;

//    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    menuBtn.frame = CGRectMake(0, 0, 20, 18);
//    [menuBtn setBackgroundImage:[UIImage imageNamed:@"icon_details_back.png"] forState:UIControlStateNormal];
//    [menuBtn addTarget:self action:@selector(gobackButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 20, 18);
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"icon_user_editor.png"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    titleArray = [[NSMutableArray alloc] initWithCapacity:0];
//    titleArray = @[@"用户名称",@"出生日期",@"国家",@"婚姻状况",@"教育程度"];
    
    
    
    titleArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"EDIT_PROFILE_PAGE_PROFILE_PICTURE", nil),
                  NSLocalizedString(@"EDIT_PROFILE_PAGE_USER_NAME", nil),
                  NSLocalizedString(@"EDIT_PROFILE_PAGE_GENDER", nil),
                  NSLocalizedString(@"EDIT_PROFILE_PAGE_DATE_OF_BIRTH", nil),
                  NSLocalizedString(@"EDIT_PROFILE_PAGE_MARITAL_STATUS", nil),
                  NSLocalizedString(@"SYSTEM_SETTINGS_MARITAL_STATUS", nil),
                  NSLocalizedString(@"EDIT_PROFILE_PAGE_EDUCATION", nil),
                  nil];
    
    educationDic = @{@"":@"-",
                     @"p":NSLocalizedString(@"EDIT_PROFILE_PAGE_PRIMARY", nil),
                     @"s":NSLocalizedString(@"EDIT_PROFILE_PAGE_SECONDARY", nil),
                     @"u":NSLocalizedString(@"EDIT_PROFILE_PAGE_UNIVERSITY", nil),
                     @"o":NSLocalizedString(@"EDIT_PROFILE_PAGE_OTHERS", nil)
                     };
    maritalStatusDic = @{@"":@"-",
                         @"s":NSLocalizedString(@"EDIT_PROFILE_PAGE_SINGLE", nil),
                         @"m":NSLocalizedString(@"EDIT_PROFILE_PAGE_MARRIED", nil),
                         @"d":NSLocalizedString(@"EDIT_PROFILE_PAGE_DIVORCED", nil)
                         };
    educationKeyArray =@[@"",@"p",@"s",@"u",@"o"]; /*[[NSArray alloc] initWithObjects:@[@"",@"p",@"s",@"u",@"o"], nil];*/
    educationValuArray =@[@"-",NSLocalizedString(@"EDIT_PROFILE_PAGE_PRIMARY", nil),NSLocalizedString(@"EDIT_PROFILE_PAGE_SECONDARY", nil),NSLocalizedString(@"EDIT_PROFILE_PAGE_UNIVERSITY", nil),NSLocalizedString(@"EDIT_PROFILE_PAGE_OTHERS", nil)]; /*[[NSArray alloc] initWithObjects:@[@"-",@"小学",@"中学",@"大学",@"其他"], nil];*/
    maritalStatusKeyArray =@[@"",@"s",@"m",@"d"];/* [[NSArray alloc] initWithObjects:@[@"",@"s",@"m",@"d"], nil];*/
    maritalStatusValuArray =@[@"-",NSLocalizedString(@"EDIT_PROFILE_PAGE_SINGLE", nil),NSLocalizedString(@"EDIT_PROFILE_PAGE_MARRIED", nil),NSLocalizedString(@"EDIT_PROFILE_PAGE_DIVORCED", nil)];/* [[NSArray alloc] initWithObjects:@[@"-",@"单身",@"已婚",@"离婚"], nil];*/
    
    sexButtonArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    _education = [[NSString alloc] init];
    _maritalStatus = @"";
    _country = @"";
    _dateOfBirth = @"";
    isOK = NO;
    
    [UserDetailsNetWork userDetailsWithUserDeta:^(id json, NSError *error) {
        if (error == nil) {
            model = [[UserDetaModel alloc] initWithDictionary:json];
            _education = model.education;
            _maritalStatus = model.maritalStatus;
            _country = model.country;
            _dateOfBirth = model.dateOfBirth;
            userAvatar = [[UIImageView alloc] init];
//            [userAvatar sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
            [userAvatar sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"head"]];
            [self.tableView reloadData];
            isOK = YES;
        }
    }];
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 1;
}
#pragma mark - 表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserEditorTableViewCell * cell = nil;
    if (indexPath.row == 0) {
        static NSString * str = @"cell3";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserEditorTableViewCell" owner:nil options:nil]objectAtIndex:3];
        }
        cell.pictureLabel.text = titleArray[indexPath.row];
        cell.userImage.image = userAvatar.image;
    }else if(indexPath.row == 1){
        static NSString * str = @"cell0";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserEditorTableViewCell" owner:nil options:nil]objectAtIndex:0];
        }
        cell.userNameLabel.text = titleArray[indexPath.row];
        cell.userNameTF.text = model.name;
        _name = model.name;
        [cell.userNameTF addTarget:self action:@selector(userNameTFClick:) forControlEvents:UIControlEventAllEditingEvents];
    }else if(indexPath.row == 2){
        static NSString * str = @"cell1";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserEditorTableViewCell" owner:nil options:nil]objectAtIndex:1];
        }
//        cell.sex_boyButton.titleLabel.text = NSLocalizedString(@"EDIT_PROFILE_PAGE_MALE", nil);
//        cell.sex_girButton.titleLabel.text = NSLocalizedString(@"EDIT_PROFILE_PAGE_FEMALE", nil);
        cell.sexLabel.text = titleArray[indexPath.row];
        [cell.sex_boyButton setTitle:[NSString stringWithFormat:@" %@",NSLocalizedString(@"EDIT_PROFILE_PAGE_MALE", nil)] forState:UIControlStateNormal];
        [cell.sex_girButton setTitle:[NSString stringWithFormat:@" %@",NSLocalizedString(@"EDIT_PROFILE_PAGE_FEMALE", nil)] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (model.gender == 0) {
            [cell.sex_boyButton setImage:[UIImage imageNamed:@"icon_usereditor_off.png"] forState:UIControlStateNormal];
            [cell.sex_girButton setImage:[UIImage imageNamed:@"icon_usereditor_off.png"] forState:UIControlStateNormal];
        }
        if (model.gender == 1) {
            [cell.sex_boyButton setImage:[UIImage imageNamed:@"icon_usereditor_on.png"] forState:UIControlStateNormal];
            [cell.sex_girButton setImage:[UIImage imageNamed:@"icon_usereditor_off.png"] forState:UIControlStateNormal];
        }
        if (model.gender == 2) {
            [cell.sex_boyButton setImage:[UIImage imageNamed:@"icon_usereditor_off.png"] forState:UIControlStateNormal];
            [cell.sex_girButton setImage:[UIImage imageNamed:@"icon_usereditor_on.png"] forState:UIControlStateNormal];
        }
        [cell.sex_girButton addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.sex_boyButton addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [sexButtonArray addObject:cell.sex_boyButton];
        [sexButtonArray addObject:cell.sex_girButton];
    }else if (indexPath.row == titleArray.count){
        static NSString * str = @"cell4";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserEditorTableViewCell" owner:nil options:nil]objectAtIndex:4];
        }
        [cell.saveButton setTitle:NSLocalizedString(@"EDIT_PROFILE_PAGE_SAVEBTN", nil) forState:UIControlStateNormal];
        [cell.saveButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }else {
        static NSString * str = @"cell2";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UserEditorTableViewCell" owner:nil options:nil]objectAtIndex:2];
        }
        cell.titleLabel.text = titleArray[indexPath.row];
        if (indexPath.row == 3) {
            if ([model.dateOfBirth isEqualToString:@""]) {
                cell.userLabel.text = NSLocalizedString(@"EDIT_PROFILE_PAGE_FILL_IN", nil);
            }else {
                cell.userLabel.text = model.dateOfBirth;
                _dateOfBirth = model.dateOfBirth;
            }
        }
        if (indexPath.row == 4) {
            if ([model.country isEqualToString:@""]) {
                cell.userLabel.text = NSLocalizedString(@"EDIT_PROFILE_PAGE_FILL_IN", nil);
            }else {
                cell.userLabel.text = countryDic[model.country];
                _country = model.country;
            }
        }
        if (indexPath.row == 5) {
            if ([model.maritalStatus isEqualToString:@""]) {
                cell.userLabel.text = NSLocalizedString(@"EDIT_PROFILE_PAGE_FILL_IN", nil);
            }else {
                _maritalStatus = model.maritalStatus;
                cell.userLabel.text = maritalStatusDic[model.maritalStatus];
            }
        }
        if (indexPath.row == 6) {
            if ([model.education isEqualToString:@""]) {
                cell.userLabel.text = NSLocalizedString(@"EDIT_PROFILE_PAGE_FILL_IN", nil);
            }else {
                _education = model.education;
                cell.userLabel.text = educationDic[model.education];
            }
        }

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    }else if (indexPath.row == titleArray.count) {
        return 68;
    }else {
        return 50;
    }
}
/**
 *  <#Description#>
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row > 2) {
        PickerChoiceView *picker = [[PickerChoiceView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        picker.delegate = self;
        if (indexPath.row == 3) {
            picker.arrayType = DeteArray;
        }else if(indexPath.row == 4){
            picker.selectLb.text = NSLocalizedString(@"EDIT_PROFILE_PAGE_MARITAL_STATUS", nil);
//            NSArray * countryArray = [countryDic allValues];
            picker.customArr = countryValuArray;
        }else if(indexPath.row == 5) {
            picker.selectLb.text = NSLocalizedString(@"SYSTEM_SETTINGS_MARITAL_STATUS", nil);
            picker.customArr = maritalStatusValuArray;
        }else if(indexPath.row == 6) {
            picker.selectLb.text = NSLocalizedString(@"EDIT_PROFILE_PAGE_EDUCATION", nil);
            picker.customArr = educationValuArray;
        }
        [self.view addSubview:picker];
        indexPathNumber = indexPath.row;
    }
    if (indexPath.row == 0) {
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        UIImagePickerController * imagePickerController=[[UIImagePickerController alloc] init];
        imagePickerController.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePickerController.allowsEditing=YES;
        imagePickerController.delegate=self;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];

    }
    [self.view endEditing:YES];
}

#pragma mark - textField点击方法
-(void)userNameTFClick:(UITextField *)textField {
    _name = textField.text;
}

#pragma mark - 性别选择
-(void)sexButtonClick:(UIButton *)sender {
    for (int i = 0; i<sexButtonArray.count; i++) {
        UIButton * button = sexButtonArray[i];
        [button setImage:[UIImage imageNamed:@"icon_usereditor_off.png"] forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:@"icon_usereditor_on.png"] forState:UIControlStateNormal];
    if (sender.tag == 100) {
        model.gender = 1;
    }
    if (sender.tag == 200) {
        model.gender = 2;
    }
}




#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    userAvatar.image=image;
    [self dismissViewControllerAnimated:YES completion:nil];
    [_tableView reloadData];
}



#pragma mark -------- TFPickerDelegate

- (void)PickerSelectorIndixString:(NSString *)str{
    if (indexPathNumber == 3) {
        model.dateOfBirth = str;
        _dateOfBirth = str;
    }else if(indexPathNumber == 4) {
        NSArray * coystomKeyArr = [countryDic allKeys];
        model.country = countryKeyArray[[str intValue]];
        _country = countryKeyArray[[str intValue]];
    }else if(indexPathNumber == 5) {
        model.maritalStatus = maritalStatusKeyArray[[str intValue]];
        _maritalStatus = maritalStatusKeyArray[[str intValue]];
    }else if(indexPathNumber == 6) {
        model.education = educationKeyArray[[str intValue]];
        _education = educationKeyArray[[str intValue]];
    }
    [self.tableView reloadData];
    
}



#pragma mark - 获取国家名称
-(NSDictionary *)textWithJsonWithCountry:(NSString *)country {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:country ofType:@"txt"];
    if ([country isEqualToString:@"English"]) {
         NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //定义字符串接收从txt文件读取的内容
        NSString *str = [[NSString alloc] initWithContentsOfFile:plistPath encoding:gbk error:nil];
        //将字符串转为nsdata类型
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        //将nsdata类型转为NSDictionary
        NSDictionary *pDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        return pDic;
    }else {
         NSStringEncoding gbk = NSUTF8StringEncoding;
        //定义字符串接收从txt文件读取的内容
        NSString *str = [[NSString alloc] initWithContentsOfFile:plistPath encoding:gbk error:nil];
        //将字符串转为nsdata类型
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        //将nsdata类型转为NSDictionary
        NSDictionary *pDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        return pDic;
    }
    
    //gbk编码 如果txt文件为utf-8的则使用NSUTF8StringEncoding
//    NSStringEncoding gbk = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSStringEncoding gbk = NSUTF8StringEncoding;
    //定义字符串接收从txt文件读取的内容
//    NSString *str = [[NSString alloc] initWithContentsOfFile:plistPath encoding:gbk error:nil];
//    //将字符串转为nsdata类型
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    //将nsdata类型转为NSDictionary
//    NSDictionary *pDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *plistPath1 = [paths objectAtIndex:0];
//    //得到完整的文件名
//    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"English.plist"];
//    //输入写入
//    
//    [pDic writeToFile:filename atomically:YES];
//    
//    NSString * plistPathStr = [[NSBundle mainBundle]pathForResource:@"English" ofType:@"txt"];
    

//    return pDic;
}


#pragma mark - 导航按钮
-(void)gobackButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  发送用户信息
 */
-(void)rightButtonClick {
    if (isOK) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view endEditing:YES];
        //    NSLog(@"名字：%@\n教育程度：%@\n婚姻状况：%@\n国家：%@\n出生日期：%@\n性别：%d",_name,_education,_maritalStatus,_country,_dateOfBirth,model.gender);
        NSString * gender = [NSString stringWithFormat:@"%d",model.gender];
        //    NSData* data = UIImageJPEGRepresentation(userAvatar.image, 1.0);
        NSDictionary * dic = @{@"name":_name,@"education":_education,@"maritalStatus":_maritalStatus,@"country":_country,@"gender":gender,@"dateOfBirth":_dateOfBirth};
        NSArray * arr = @[userAvatar.image];
        if (dic == nil&&arr == nil) {
            
        }else {
            [UserDetailsNetWork PostRequestWithPicUrl:@"" WithDict:dic WithData:arr ReturnData:^(id json, NSError *error) {
                
                if (error == nil) {
                    self.navigationItem.rightBarButtonItem.enabled = YES;
                    [userDefaults setObject:json[@"name"] forKey:@"userName"];
                    [userDefaults setObject:json[@"avatar"] forKey:@"avatar"];
                    [userDefaults synchronize];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    MBProgressHUD *notice = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    notice.mode = MBProgressHUDModeText;
                    notice.labelText = NSLocalizedString(@"EDIT_PROFILE_PAGE_SAVED", nil);
                    notice.yOffset = -30;
                    [notice hide:YES afterDelay:1.5];
                    
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                
            }];
            
        }

    }
}


@end
