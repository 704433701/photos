//
//  MoreViewController.m
//  PrivacyPhotos
//
//  Created by lanou3g on 15/4/27.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"

@interface MoreViewController ()<RESideMenuDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSUserDefaults *user;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    self.sideMenuViewController.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhichilun.png"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[MoreTableViewCell class] forCellReuseIdentifier:@"moreCell"];
    self.user = [NSUserDefaults standardUserDefaults];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *arr = @[@"更多功能", @"帮助"];
    return [arr objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
            
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = @[@"温馨提醒", @"文件夹隐藏", @"帮助"];
    if (indexPath.section == 0) {
          MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moreCell"];
        cell.label.text = [arr objectAtIndex:indexPath.row];
        [cell.mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell.mySwitch.tag = 400 + indexPath.row;
        if (indexPath.row == 0) {
            if (![_user boolForKey:@"addPhoto"] && ![_user boolForKey:@"warning" ]) {
                [cell.mySwitch setOn:YES];
            }
        }
        if (indexPath.row == 1) {
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray  *arr = [fileManager contentsOfDirectoryAtPath:documentPath error:nil];
            for (NSString *fileName in arr) {
                if (![fileName hasPrefix:@"."]) {
                    [cell.mySwitch setOn:NO];
                    continue;
                }
                [cell.mySwitch setOn:YES];
            }
        }
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = @"首先感谢您对小久久私密相册的支持!\n请牢记您的密码!\n\n01.如何添加照片?\n您需要点击 创建相册->右上角'+'号, 可以选择从相机添加和相册添加.\n\n02.如何从电脑导入和导出到电脑?\n 小久久已开启文件共享功能, (1)当您的手机与电脑用USB数据线连接成功之后, 打开iTunes\n(2)设备->应用程序->文件共享->小久久\n(3)点击'添加',同样您可以将小久久中得照片导入到电脑中,只需要点击'存储到'即可.\n(4)注意:导入时, 请将需要导入的照片放在创建的文件夹内再导入,且不要与现有文件夹重名.\n\n03.文件夹隐藏有什么用?\n为了保护您的隐私不再电脑端被查看, 当开启文件夹隐藏功能之后, 您的照片不会在iTunes文件共享中显示出来, 当您需要将照片导出到电脑时,需要关闭文件夹隐藏功能.\n\n04.为什么我的相册名颜色不一样?\n相册名有灰色和白色, 灰色表示该相册是隐藏状态, 新创建的相册默认为隐藏状态, 您可以通过关闭文件夹隐藏功能来使他们变成白色并在文件共享中可见\n\n05.忘记密码怎么办?\n抱歉, 小久久暂不支持密码找回功能, 所以请务必记牢您的密码!!!";
    return cell;
}

- (void)switchAction:(UISwitch *)switc
{
    switch (switc.tag) {
        case 400:
        {
            [_user setBool:!switc.on forKey:@"warning"];
            [_user setBool:!switc.on forKey:@"addPhoto"];
            [_user setBool:!switc.on forKey:@"firstCalulator"];
        }
            break;
        case 401:
        {
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray  *arr = [fileManager contentsOfDirectoryAtPath:documentPath error:nil];
            NSError *error;
            BOOL isSuccess;
            if (switc.on) {
                for (NSString *fileName in arr) {
                    if (![fileName hasPrefix:@"."]) {
                        NSString *toPath = [NSString stringWithFormat:@"%@/.%@",documentPath, fileName];
                        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentPath, fileName];
                        [fileManager createDirectoryAtPath:[toPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
                        isSuccess = [fileManager moveItemAtPath:filePath toPath:toPath error:&error];
                    }
                }
            } else
            {
                for (NSString *fileName in arr) {
                    if ([fileName hasPrefix:@"."]) {
                        NSString *newFile = [fileName substringFromIndex:1];
                        NSString *toPath = [NSString stringWithFormat:@"%@/.%@",documentPath, newFile];
                        NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentPath, newFile];
                        [fileManager createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
                        isSuccess = [fileManager moveItemAtPath:toPath toPath:filePath error:&error];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {

        UITextView *view = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0)];
        view.text = @"首先感谢您对小久久私密相册的支持!\n请牢记您的密码!\n\n01.如何添加照片?\n您需要点击 创建相册->右上角'+'号, 可以选择从相机添加和相册添加.\n\n02.如何从电脑导入和导出到电脑?\n 小久久已开启文件共享功能, (1)当您的手机与电脑用USB数据线连接成功之后, 打开iTunes\n(2)设备->应用程序->文件共享->小久久\n(3)点击'添加',同样您可以将小久久中得照片导入到电脑中,只需要点击'存储到'即可.\n(4)注意:导入时, 请将需要导入的照片放在创建的文件夹内再导入,且不要与现有文件夹重名.\n\n03.文件夹隐藏有什么用?\n为了保护您的隐私不再电脑端被查看, 当开启文件夹隐藏功能之后, 您的照片不会在iTunes文件共享中显示出来, 当您需要将照片导出到电脑时,需要关闭文件夹隐藏功能.\n\n04.为什么我的相册名颜色不一样?\n相册名有灰色和白色, 灰色表示该相册是隐藏状态, 新创建的相册默认为隐藏状态, 您可以通过关闭文件夹隐藏功能来使他们变成白色并在文件共享中可见\n\n05.忘记密码怎么办?\n抱歉, 小久久暂不支持密码找回功能, 所以请务必记牢您的密码!!!";
        [view sizeToFit];
        return view.frame.size.height + 19 * 20;
    }
    return 44;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    [UIView animateWithDuration:1 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    }];
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    [UIView animateWithDuration:1 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
