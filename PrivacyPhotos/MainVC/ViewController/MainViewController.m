//
//  MainViewController.m
//  PrivacyPhotos
//
//  Created by zhangjianhua on 15/4/18.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MainViewController.h"
#import "MainCollectionViewCell.h"
#import "PhotoListViewController.h"
#import "NumLockViewController.h"

@interface MainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, RESideMenuDelegate>

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *fileArr;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) UIAlertView *deleteAlert;

@property (nonatomic, assign) BOOL deleteOpen;
@property (nonatomic, retain) NSString *documentPath;
@property (nonatomic, assign) NSInteger objFile;

@property (nonatomic, retain) NSUserDefaults *user;

@end

@implementation MainViewController

+ (MainViewController *)standardMainViewController
{
    // 单例方法的实现
    static MainViewController *mainVC = nil;
    
    // 当静态的指针为空的时候, 创建一个对象
    if (mainVC == nil) {
        mainVC = [[MainViewController alloc] init];
    }
    return mainVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"小久久";
    
    self.user = [NSUserDefaults standardUserDefaults];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
   // backImageView.image = [UIImage imageNamed:@"005.jpg"];
    [self.view addSubview:backImageView];
    self.documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", _documentPath);
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-shezhichilun.png"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editCollectionView:)];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.itemSize = CGSizeMake((WIDTH - 20 - 25) / 3, (WIDTH - 20 - 20) / 3 + 20);
//    flowLayout.itemSize = CGSizeMake((WIDTH - 20 - 20) / 3, (WIDTH - 20 - 20) / 3 + 20);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:@"mainCell"];
    
    self.alert = [[UIAlertView alloc] initWithTitle:@"添加新相册" message:@"输入相册名字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    _alert.delegate = self;
    [self.view addSubview:_alert];
    
    self.deleteAlert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"删除该相册\n将删除相册内所有照片\n确认操作?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", @"不再提醒", nil];
    _deleteAlert.delegate = self;
    [self.view addSubview:_deleteAlert];
}

- (void)presentLeftMenuViewController:(UIBarButtonItem *)bar
{
    if ([_user boolForKey:@"first"]) {
        NumLockViewController *numLockVC = [[NumLockViewController alloc] init];
        [self presentViewController:numLockVC animated:YES completion:^{
            [_user setBool:NO forKey:@"first"];
        }];
    }
    [self.sideMenuViewController presentLeftMenuViewController];
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

#pragma mark - 编辑模式
- (void)editCollectionView:(UIBarButtonItem *)barButton
{
    self.deleteOpen = !self.deleteOpen;
    if (self.deleteOpen) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        [UIView animateWithDuration:0.4 animations:^{
            self.collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        }];
    } else {
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        [UIView animateWithDuration:0.4 animations:^{
            self.collectionView.backgroundColor = [UIColor clearColor];
        }];
    }
    [self.collectionView reloadData];
}

#pragma mark - collectionView协议方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray  *arr = [fileManager contentsOfDirectoryAtPath:_documentPath error:nil];
    self.fileArr = [NSMutableArray arrayWithArray:arr];
    return self.fileArr.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainCell" forIndexPath:indexPath];
    cell.photo.image = nil;
    if (indexPath.item == 0) {
        cell.photo.image = [UIImage imageNamed:@"add"];
        cell.label.text = @"创建相册";
        cell.label.textColor = [UIColor whiteColor];
        cell.button.hidden = YES;
    } else {
        NSString *str = [self.fileArr objectAtIndex:indexPath.item - 1];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *fileCount = [[self.fileArr objectAtIndex:indexPath.item - 1] stringByAppendingString:@"_count"];
        NSString *labelstr = str;
        if ([labelstr hasPrefix:@"."]) {
            labelstr = [labelstr substringFromIndex:1];
            cell.label.textColor = [UIColor lightGrayColor];
        } else {
            cell.label.textColor = [UIColor whiteColor];
        }
        if ([user objectForKey:fileCount] != nil && ![[user objectForKey:fileCount] isEqualToNumber:@(0)]) {
            labelstr = [labelstr stringByAppendingFormat:@"(%@)", [user objectForKey:fileCount]];
        }
        cell.label.text = labelstr;
        if ([[user objectForKey:str] length] != 0) {
            cell.photo.image = [UIImage imageWithData:[user objectForKey:str]];
        } else {
            cell.photo.image = [UIImage imageNamed:@"zhanwei"];
        }
        cell.button.tag = indexPath.item + 100;
        cell.button.hidden = !self.deleteOpen;
        [cell.button addTarget:self action:@selector(deleteFile:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self editCollectionView:nil];
}


#pragma mark - 删除文件夹及内部照片
- (void)deleteFile:(UIButton *)button
{
    self.objFile = button.tag - 100 - 1;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"warning"] == NO) {
        [_deleteAlert show];
    } else {
        [self deleteFile];
    }
}
- (void)deleteFile
{
    NSString *fileName = [self.fileArr objectAtIndex:self.objFile];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", _documentPath, fileName];
    [self.fileArr removeObjectAtIndex:self.objFile];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager removeItemAtPath:filePath error:nil];
    if (res) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user removeObjectForKey:fileName];
        [self.collectionView reloadData];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
         _alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [self.alert textFieldAtIndex:0];
        textField.text = @"";
        [_alert show];
    } else {
        PhotoListViewController *photoListVC = [[PhotoListViewController alloc] init];
        photoListVC.fileName = [self.fileArr objectAtIndex:indexPath.item - 1];
        photoListVC.documentPath = self.documentPath;
        [self.navigationController pushViewController:photoListVC animated:YES];
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.deleteOpen;
}

// create directory in the caches directory
bool createDirInCache(NSString *dirName)
{
    NSString *imageDir;
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    bool isCreated = false;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return isCreated;
}

#pragma mark - alert协议方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
        if (buttonIndex == 1 ) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
#warning 此处设置文件夹是否隐藏
            NSString *name = [NSString stringWithFormat:@"/.%@", [[alertView textFieldAtIndex:0] text]];
            NSString *patha = [_documentPath stringByAppendingString:name];
            BOOL create = [fileManager createDirectoryAtPath:patha withIntermediateDirectories:YES attributes:nil error:nil];
            if (create) {
                [self.collectionView reloadData];
            }
        }
    }else {
        if (buttonIndex == 1) {
            [self deleteFile];
        } else if (buttonIndex == 2) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setBool:YES forKey:@"warning"];
        }
        
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
        if ([self.fileArr containsObject:[[alertView textFieldAtIndex:0] text]]) {
            NSString *str = [NSString stringWithFormat:@"已存在\"%@\"文件夹",[[alertView textFieldAtIndex:0] text]];
            alertView.message = str;
            return NO;
        } else
        {
            alertView.message = @"创建相册";
            return YES;
        }
    }
    return YES;
}



- (void)menuButtonClicked:(NSInteger)index
{
    NSLog(@"点击%ld", index);
}


- (void)viewWillAppear:(BOOL)animated
{
    self.sideMenuViewController.delegate = self;
    [self.collectionView reloadData];
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
