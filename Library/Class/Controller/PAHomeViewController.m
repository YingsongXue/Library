//
//  PAHomeViewController.m
//  Library
//
//  Created by 薛 迎松 on 14/11/2.
//  Copyright (c) 2014年 薛 迎松. All rights reserved.
//

#import "PAHomeViewController.h"
#import "PABarCodeViewController.h"
#import "PACollectionViewCell.h"

@interface PAHomeViewController ()
    <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, retain) UICollectionView *collectionView;
@end

@implementation PAHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"LibraryTitle", @"");
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(scanBarCode)];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout] ;
    //注册
    [collectionView registerClass:[PACollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    
    //设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSDictionary *viewsDic = NSDictionaryOfVariableBindings(collectionView);
    NSDictionary *metrics = @{@"Padding":@0};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-Padding-[collectionView]-Padding-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:viewsDic]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-Padding-[collectionView]-Padding-|" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:viewsDic]];
    
}

- (void)scanBarCode
{
    PABarCodeViewController *barCodeViewController = [[PABarCodeViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:barCodeViewController];
    [self presentViewController:navigation animated:YES completion:nil];
}

#pragma mark CollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    PACollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = @"hello world";
    int num1 = arc4random()%255;
    int num2 = arc4random()%255;
    int num3 = arc4random()%255;
    cell.backgroundColor = [UIColor colorWithRed:(num1 / 255.0) green:(num2/255.0) blue:(num3/255.0) alpha:1.0f];
    return cell;
}

#pragma mark CollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark CollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(96, 96*1.4);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
