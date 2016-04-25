//
//  BigViewController.m
//  PrivacyPhotos
//
//  Created by zhangjianhua on 15/4/20.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "BigViewController.h"
#import "BigViewCollectionViewCell.h"
#import "VIPhotoView.h"

@interface BigViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UICollectionView *collectionView;
@end

@implementation BigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(WIDTH, HEIGHT - 64);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.contentOffset = CGPointMake(WIDTH * _index, 0);
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[BigViewCollectionViewCell class] forCellWithReuseIdentifier:@"big"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.title = [NSString stringWithFormat:@"%.f / %ld", scrollView.contentOffset.x / WIDTH + 1, self.arr.count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BigViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"big" forIndexPath:indexPath];
    NSString *path = [_documentPath stringByAppendingFormat:@"/%@/%@", _fileName, [self.arr objectAtIndex:indexPath.item]];
    cell.imagePath = path;
    return cell;
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
