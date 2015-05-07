//
//  PhotoListViewController.m
//  PrivacyPhotos
//
//  Created by zhangjianhua on 15/4/18.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "PhotoListViewController.h"
#import "PhotoCollectionViewCell.h"
#import "BigViewController.h"

@interface PhotoListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, QBImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *fileArr;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIBarButtonItem *remBarButton;
@property (nonatomic, retain) UIBarButtonItem *addBarButton;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, assign) BOOL deleteOpen;
@property (nonatomic, assign) BOOL returnOpen;
@property (nonatomic, assign) BOOL actionSheetNumber;
@property (nonatomic, retain) NSCountedSet *set;
@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.fileName hasPrefix:@"."]) {
        self.title = [self.fileName substringFromIndex:1];
    } else {
        self.title = self.fileName;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.addBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jiahao.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addPhotos:)];
    self.remBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"iconfont-jianhao.png"] style:UIBarButtonItemStylePlain target:self action:@selector(remPhotos:)];
    self.navigationItem.rightBarButtonItems = @[_addBarButton, _remBarButton];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.itemSize = CGSizeMake((WIDTH - 20 - 25) / 3, (WIDTH - 20 - 20) / 3);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photosCell"];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT)];
    _imageView.image = [UIImage imageNamed:@"list_blank.png"];
    [self.view addSubview:_imageView];
    [self documentFolderPath];
}

#pragma mark - 添加照片方法
- (BOOL)addPhotos:(UIBarButtonItem *)barButton
{
    if (_deleteOpen) {
        [self deletePhoto];
        return NO;
    }
    if (_returnOpen) {
        [self returnPhoto];
        return NO;
    }
    self.actionSheetNumber = YES;
    //在这里呼出下方菜单按钮项
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:@"从照相机添加",@"从手机相册添加", nil];
    [myActionSheet showInView:self.view];
        
    
    return YES;
}

- (BOOL)remPhotos:(UIBarButtonItem *)barButton
{
    if (_deleteOpen) {
        [self deletePhoto];
        return NO;
    }
    if (_returnOpen) {
        [self returnPhoto];
        return NO;
    }
    self.actionSheetNumber = NO;
    //在这里呼出下方菜单按钮项
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:@"删除某张照片", @"放回手机相册", nil];
    [myActionSheet showInView:self.view];
    
    
    return YES;
}

//下拉菜单的点击响应事件
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == actionSheet.cancelButtonIndex){
        NSLog(@"取消");
    }
    if (_actionSheetNumber) {
        switch (buttonIndex) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self localPhoto];
                break;
            default:
                break;
        }
    } else {
        switch (buttonIndex) {
            case 0:
                [self deletePhoto];
                break;
            case 1:
                [self returnPhoto];
                break;
            default:
                break;
        }
    }
}

// 打开摄像头
- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:^{
            
        }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该设备没有相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

// 打开相册
- (void)localPhoto
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

// 删除照片
- (void)deletePhoto
{
    if (_deleteOpen == NO) {
        [self.remBarButton setImage:[UIImage imageNamed:@"iconfont-duihao.png"]];
        _addBarButton.enabled = NO;
    } else {
        [self.remBarButton setImage:[UIImage imageNamed:@"iconfont-jianhao.png"]];
        _addBarButton.enabled = YES;
    }
    _deleteOpen = !_deleteOpen;
    [self.collectionView reloadData];
}

// 放回系统相册
- (void)returnPhoto
{
    if (_returnOpen == NO) {
        [self.remBarButton setImage:[UIImage imageNamed:@"iconfont-duihao.png"]];
        _addBarButton.enabled = NO;
    } else {
        [self.remBarButton setImage:[UIImage imageNamed:@"iconfont-jianhao.png"]];
        _addBarButton.enabled = YES;
    }
    _returnOpen = !_returnOpen;
    [self.collectionView reloadData];
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = nil;
    if ([imageName hasSuffix:@".png"]) {
        imageData = UIImagePNGRepresentation(tempImage);
    } else {
        imageData = UIImageJPEGRepresentation(tempImage, 0);
    }
    NSString *path = [_documentPath stringByAppendingFormat:@"/%@/", _fileName];
    // Now we get the full path to the file
    NSString* fullPathToFile = [path stringByAppendingPathComponent:imageName];
    // and then we write it out
    //  imageData = [GTMBase64 encodeData:imageData];
    [imageData writeToFile:fullPathToFile atomically:NO];
}

- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateFormat:@"yyyyMMddhhmmss"];
        NSString *localDateStr = [formatter1 stringFromDate:date];
        NSString* filename = [NSString stringWithFormat:@"%@.jpg", localDateStr];
        
        [self saveImage:image WithName:filename];
        [self documentFolderPath];
        [self dismissViewControllerAnimated:YES completion:^{
            self.imagePicker.sourceType = 0;
        }];
    } else if(imagePickerController.allowsMultipleSelection) {
        UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
        UCZProgressView *progressView = [[UCZProgressView alloc] initWithFrame:self.view.bounds];
        progressView.indeterminate = NO;
        progressView.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        progressView.showsText = YES;
        progressView.tintColor = [UIColor blueColor];
        progressView.usesVibrancyEffect = NO;
        progressView.textColor = [UIColor blueColor];
        progressView.radius = WIDTH / 6;
        progressView.lineWidth = 4;
        [window addSubview:progressView];
        
        self.set = [NSCountedSet set];
        [_set addObjectsFromArray:self.fileArr];
        // 多线程
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_queue_t myQueue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
        NSArray *mediaInfoArray = (NSArray *)info;
        dispatch_async(myQueue, ^{
            for (NSInteger i = 0 ; i < mediaInfoArray.count; i++   ) {
                @autoreleasepool {
                    ALAsset *asset = [mediaInfoArray objectAtIndex:i];
                    ALAssetRepresentation* representation = [asset defaultRepresentation];
                    //获取资源图片的名字
                    NSString* filename = [representation filename];
                    [_set addObject:filename];
                    //获取资源图片的高清图
                    CGImageRef thum = [representation fullScreenImage];
                    UIImage *image = [UIImage imageWithCGImage:thum];
                    [self saveImage:image WithName:filename];
                    // 异步分发任务
                    dispatch_async(mainQueue, ^{
                        [progressView setProgress:(CGFloat) i / (mediaInfoArray.count - 1)  animated:YES];
                    });
                }
            }
            NSString *message = [NSString stringWithFormat:@"选择%ld,成功%ld,重复%ld个", mediaInfoArray.count, _set.count - self.fileArr.count, self.fileArr.count + mediaInfoArray.count - _set.count];
            dispatch_async(mainQueue, ^{
                [progressView setProgress:1  animated:YES];
                [self documentFolderPath];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"addPhoto"] == NO) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:@"您现在可以把手机相册内的\n相同图片删除咯! 快去保护隐私吧~" delegate:self cancelButtonTitle:@"不再提醒" otherButtonTitles:@"确认", nil];
                        alert.delegate = self;
                        [alert show];
                    }
                }];
            });
        });
    } else {
    }
}

#pragma mark - alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addPhoto"];
    }
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"点击全部选中";
}

- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"点击全部取消";
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"共有%ld张照片", numberOfPhotos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"共有%ld个视频", numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"照片%ld张、视频%ld个", numberOfPhotos, numberOfVideos];
}

#pragma mark - collectionView协议方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_fileArr.count == 0) {
        _imageView.hidden = NO;
    } else {
        _imageView.hidden = YES;
    }
    return self.fileArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photosCell" forIndexPath:indexPath];
    NSString *path = [_documentPath stringByAppendingFormat:@"/%@/%@", _fileName, [self.fileArr objectAtIndex:indexPath.item]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    cell.imageView.image = [UIImage imageWithData:data];
    
    cell.button.tag = indexPath.item + 1000;
    cell.button.hidden = !self.deleteOpen && !self.returnOpen;
    if (_deleteOpen) {
        [cell.button addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button setBackgroundImage:[UIImage imageNamed:@"delete-circular.png"] forState:UIControlStateNormal];
    } else if (_returnOpen) {
        [cell.button addTarget:self action:@selector(returnPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button setBackgroundImage:[UIImage imageNamed:@"iconfont-fanhui.png"] forState:UIControlStateNormal];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BigViewController *bigVC = [[BigViewController alloc] init];
    bigVC.arr = self.fileArr;
    bigVC.index = indexPath.item;
    bigVC.fileName = self.fileName;
    bigVC.documentPath = self.documentPath;
    [self.navigationController pushViewController:bigVC animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.deleteOpen && !self.returnOpen;
}

#pragma mark - 删除照片

- (void)deletePhoto:(UIButton *)button
{
    NSString *photoName = [self.fileArr objectAtIndex:button.tag - 1000];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@", _documentPath, _fileName, photoName];
    [self.fileArr removeObjectAtIndex:button.tag - 1000];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager removeItemAtPath:filePath error:nil];
    if (res) {
        [self.collectionView reloadData];
    }
}

#pragma mark - 放回照片
- (void)returnPhoto:(UIButton *)button
{
    NSString *photoName = [self.fileArr objectAtIndex:button.tag - 1000];
    NSString *path = [_documentPath stringByAppendingFormat:@"/%@/%@", _fileName, photoName];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], self, nil, nil);
    [self deletePhoto:button];
}

//实现代理方法
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark 从文档目录下获取Documents路径
- (void)documentFolderPath
{
    NSString *path = [_documentPath stringByAppendingFormat:@"/%@", _fileName];
    NSArray* filename = [self getFilenamelistOfType:nil fromDirPath:path];
    self.fileArr = [NSMutableArray arrayWithArray:filename];
    [self.collectionView reloadData];
}

-(NSArray *) getFilenamelistOfType:(NSString *)type fromDirPath:(NSString *)dirPath

{
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:nil];
    return fileList;
}

#pragma mark - 文件夹海报图片
- (void)viewWillDisappear:(BOOL)animated
{
    NSString *path = [_documentPath stringByAppendingFormat:@"/%@/%@", _fileName, [self.fileArr lastObject]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:data forKey:self.fileName];
    NSString *fileCount = [_fileName stringByAppendingString:@"_count"];
    [user setValue:@(self.fileArr.count) forKey:fileCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"警告");
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
