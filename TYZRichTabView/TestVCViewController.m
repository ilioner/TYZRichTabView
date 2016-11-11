//
//  TestVCViewController.m
//  Test
//
//  Created by Tywin on 2016/11/11.
//  Copyright © 2016年 Tywin. All rights reserved.
//

#import "TestVCViewController.h"
#import "TYZRichTabView.h"

#define S_W [UIScreen mainScreen].bounds.size.width
#define S_H [UIScreen mainScreen].bounds.size.height

@interface TestVCViewController ()<TYZRichTabViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    TYZRichTabView *_richTabView;
}
@end

@implementation TestVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _richTabView = [[TYZRichTabView alloc] initWithFrame:CGRectMake(0, 0, S_W, S_H)];
    _richTabView.delegate = self;
    [self.view addSubview:_richTabView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSubViews
{
    return 3;
}

- (CGFloat)heightOfHeaderView
{
    return S_W/2;
}

- (NSArray *)tabTitles
{
    return @[@"我的",@"你的",@"他的"];
}

- (UIView *)headerView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, S_W, S_W/2)];
    headerView.backgroundColor = [UIColor redColor];
    return headerView;
}

- (id)richTabView:(TYZRichTabView *)richTabView viewForIndex:(NSInteger)index
{
    if (index == 0) {
        UIView *view = [richTabView viewForIndex:index];
        if (!view) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, S_W, S_W)];
            UIImageView *imageView = [[UIImageView alloc] init];
            UIImage *image = [UIImage imageNamed:@"pic_001"];
            imageView.image = image;
            imageView.frame = CGRectMake(0, 0, S_W, S_W);
            [view addSubview:imageView];
        }
        
        return view;
    }else{
        UIView *view = [richTabView viewForIndex:index];
        if (!view) {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, S_W, S_H) style:UITableViewStylePlain];
            tableView.tag = index;
            view = tableView;
        }
        return view;
    }
}

- (void)richTabView:(TYZRichTabView *)richTabView scrollTo:(NSInteger)index
{
    NSLog(@"");
}

- (NSInteger)richTabView:(TYZRichTabView *)richTabView numberOfSectionsInTableView:(UITableView *)tableView index:(NSInteger)index
{
    return 1;
}

- (NSInteger)richTabView:(TYZRichTabView *)richTabView tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section index:(NSInteger)index
{
    if (tableView.tag == 1) {
        return 2;
    }
    return 20;
}

- (CGFloat)richTabView:(TYZRichTabView *)richTabView tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index
{
    if (tableView.tag == 1) {
        return 50.0f;
    }
    return 70.0f;
}

- (UITableViewCell *)richTabView:(TYZRichTabView *)richTabView tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index
{
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (tableView.tag == 1) {
        cell.backgroundColor = [UIColor yellowColor];
        
    }else{
        cell.backgroundColor = [UIColor grayColor];
    }
    cell.textLabel.text = indexPath.description;
    return cell;
}

- (void)richTabView:(TYZRichTabView *)richTabView tableView:(UIScrollView *)tableView scrollWithIndex:(NSInteger)index
{
    
}
@end
