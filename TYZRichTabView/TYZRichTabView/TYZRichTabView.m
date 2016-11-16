//
//  TYZRichTabView.m
//  Test
//
//  Created by Tywin on 2016/11/11.
//  Copyright © 2016年 Tywin. All rights reserved.
//

#import "TYZRichTabView.h"

@implementation TYZRichTabView
{
    CGRect _viewFrame;
    UIScrollView *_mainScrollView;
    NSMutableArray *_viewArray;
    UIView *_mainHeaderView;
    UIView *_tabBar;
    NSMutableArray *_tabButtonArray;
    NSInteger _currentIndex;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewFrame = frame;
        _viewArray = [NSMutableArray array];
        _currentIndex = 0;
    }
    return self;
}

- (UIView *)viewForIndex:(NSInteger)index
{
    if (_viewArray.count>0 && _viewArray.count-1>=index) {
        return [_viewArray objectAtIndex:index];
    }else{
        return nil;
    }
}

- (void)reloadForIndex:(NSInteger)index
{
    UITableView *tableView = (UITableView *)[self viewForIndex:index];
    [tableView reloadData];
}

- (void)setDelegate:(id<TYZRichTabViewDelegate>)delegate
{
    _delegate = delegate;
    [self setupViews];
}

- (void)setupViews
{
    NSInteger subViewCount = [self.delegate numberOfSubViews];
    CGFloat viewWidth = _viewFrame.size.width;
    CGFloat viewHeight = _viewFrame.size.height;
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.contentSize = CGSizeMake(viewWidth*subViewCount, viewHeight);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    
    for (int i = 0; i< subViewCount; i++) {
        id subView = [self.delegate richTabView:self viewForIndex:i];
        UITableView *subTBView = [self resetupTableView:subView index:i];
        NSAssert(subView!=nil, @"断在这里说明viewForIndex方法返回的是nil");
        subTBView.frame = CGRectMake(viewWidth*i, 0, viewWidth, viewHeight);
        [_viewArray addObject:subTBView];
        [_mainScrollView addSubview:subTBView];
    }
    [self addSubview:_mainScrollView];
    _mainHeaderView = [self.delegate headerView];
    [self addSubview:_mainHeaderView];
    [self setupTabBar];
    [self addSubview:_tabBar];
}

- (UITableView *)resetupTableView:(UIView *)view index:(NSInteger)index
{
    UITableView *tableView = nil;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _viewFrame.size.width, [self.delegate heightOfHeaderView]+44)];
    if (![view isKindOfClass:[UITableView class]]) {
        tableView = [[UITableView alloc] init];
        tableView.tableHeaderView = headerView;
        tableView.delegate = self;
        UIView *footerView = view;
        if (footerView.frame.size.height < _viewFrame.size.height) {
            CGRect footerFrame = footerView.frame;
            footerFrame.size.height = _viewFrame.size.height;
            footerView.frame = footerFrame;
        }
        tableView.tableFooterView = footerView;
    }else{
        tableView = (UITableView *)view;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableHeaderView = headerView;
        
        if (tableView.contentSize.height < _viewFrame.size.height + [self.delegate heightOfHeaderView]) {
            UIView *footerView = [[UIView alloc] init];
            footerView.frame = CGRectMake(0, 0, _viewFrame.size.width, _viewFrame.size.height + [self.delegate heightOfHeaderView] - tableView.contentSize.height);
            tableView.tableFooterView = footerView;
        }
    }
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    return tableView;
}

- (void)setupTabBar
{
    NSArray *_titleArray = [self.delegate tabTitles];
    NSAssert(_titleArray.count == [self.delegate numberOfSubViews], @"检查下titles与列表数量是否一致");
    NSAssert(_titleArray.count <= 4, @"目前最多数量限制为4");
    if (_titleArray.count > 0) {
        _tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, [self.delegate heightOfHeaderView], _viewFrame.size.width, 44.0f)];
        _tabBar.backgroundColor = [UIColor whiteColor];
        CGFloat button_w = _viewFrame.size.width/_titleArray.count;
        _tabButtonArray = [NSMutableArray array];
        for (int i = 0; i<_titleArray.count; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(button_w*i, 0, button_w, 44)];
            [button setTitle:_titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:i == 0?[UIColor redColor]:[UIColor grayColor] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_tabButtonArray addObject:button];
            [_tabBar addSubview:button];
        }
    }
}

- (void)buttonAction:(UIButton *)sender
{
    for (int i = 0; i<_tabButtonArray.count; i++) {
        UIButton *button = _tabButtonArray[i];
        [button setTitleColor:i == sender.tag?[UIColor redColor]:[UIColor grayColor] forState:UIControlStateNormal];
    }
    [_mainScrollView scrollRectToVisible:CGRectMake(sender.tag*_viewFrame.size.width, 0, _viewFrame.size.width, _viewFrame.size.height) animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.delegate richTabView:self numberOfSectionsInTableView:tableView index:_currentIndex];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate richTabView:self tableView:tableView numberOfRowsInSection:section index:_currentIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate richTabView:self tableView:tableView heightForRowAtIndexPath:indexPath index:_currentIndex];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.delegate richTabView:self tableView:tableView cellForRowAtIndexPath:indexPath index:_currentIndex];
}


#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _mainScrollView) {
        
    }else{
        if (scrollView.contentOffset.y < [self.delegate heightOfHeaderView]) {
            _mainHeaderView.frame = CGRectMake(0, 0-scrollView.contentOffset.y, _viewFrame.size.width, [self.delegate heightOfHeaderView]);
            _tabBar.frame = CGRectMake(0, [self.delegate heightOfHeaderView]-scrollView.contentOffset.y, _viewFrame.size.width, 44.0f);
            for (UIView *flagView in _viewArray) {
                UITableView *flagTableView = (UITableView *)flagView;
                if (flagTableView != scrollView) {
                    flagTableView.contentOffset = scrollView.contentOffset;
                }
            }
            
        }else{
            _mainHeaderView.frame = CGRectMake(0, -[self.delegate heightOfHeaderView], _viewFrame.size.width, [self.delegate heightOfHeaderView]);
            _tabBar.frame = CGRectMake(0, 0, _viewFrame.size.width, 44.0f);
            for (UIView *flagView in _viewArray) {
                UITableView *flagTableView = (UITableView *)flagView;
                if (flagTableView != scrollView) {
                    if (flagTableView.contentOffset.y < [self.delegate heightOfHeaderView]) {
                        flagTableView.contentOffset = CGPointMake(0, [self.delegate heightOfHeaderView]);
                    }
                }
            }
        }
        [self.delegate richTabView:self tableView:scrollView scrollWithIndex:_currentIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _mainScrollView) {
        _currentIndex = scrollView.contentOffset.x / _viewFrame.size.width;
        for (int i = 0; i<_tabButtonArray.count; i++) {
            UIButton *button = _tabButtonArray[i];
            [button setTitleColor:i == _currentIndex?[UIColor redColor]:[UIColor grayColor] forState:UIControlStateNormal];
        }
        [self.delegate richTabView:self scrollTo:_currentIndex];
    }
}
@end
