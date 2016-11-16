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
    return S_W*0.73;
}

- (NSArray *)tabTitles
{
    return @[@"我的",@"你的",@"他的"];
}

- (UIView *)headerView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, S_W, S_W*0.73)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:headerView.frame];
    imageView.image = [UIImage imageNamed:@"header.png"];
    [headerView addSubview:imageView];
    return headerView;
}

- (id)richTabView:(TYZRichTabView *)richTabView viewForIndex:(NSInteger)index
{
    if (index == 0) {
        UIView *view = [richTabView viewForIndex:index];
        if (!view) {
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, S_W, S_W)];
            NSString *content = @"皑如山上雪，皎若云间月。\n闻君有两意，故来相决绝。\n今日斗酒会，明旦沟水头。\n躞蹀御沟上，沟水东西流。\n凄凄复凄凄，嫁娶不须啼。\n愿得一人心，白首不相离。\n竹竿何袅袅，鱼尾何簁簁！\n男儿重意气，何用钱刀为！";
            UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, S_W, S_H)];
            tv.text = content;
            tv.backgroundColor = [UIColor clearColor];
            tv.textAlignment = NSTextAlignmentCenter;
            tv.font = [UIFont systemFontOfSize:18.0f];
            tv.scrollEnabled = NO;
            tv.editable = NO;
            tv.textColor = [UIColor blackColor];
            view.backgroundColor = [UIColor lightGrayColor];
            [view addSubview:tv];
        }
        
        return view;
    }else{
        UIView *view = [richTabView viewForIndex:index];
        if (!view) {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, S_W, S_H) style:UITableViewStylePlain];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
        cell.textLabel.text = @"这是第二个TableView";
        
    }else{
        cell.textLabel.text = @"这是第三个TableView";
    }
    
    return cell;
}

- (void)richTabView:(TYZRichTabView *)richTabView tableView:(UIScrollView *)tableView scrollWithIndex:(NSInteger)index
{
    
}
@end
