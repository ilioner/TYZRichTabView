//
//  TYZRichTabView.h
//  Test
//
//  Created by Tywin on 2016/11/11.
//  Copyright © 2016年 Tywin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TYZRichTabViewDelegate;
@interface TYZRichTabView : UIView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, weak) id<TYZRichTabViewDelegate> delegate;

- (UIView *)viewForIndex:(NSInteger)index;
- (void)reloadForIndex:(NSInteger)index;

@end

@protocol TYZRichTabViewDelegate <NSObject>

#pragma mark -TYZRichTabViewDelegate
- (NSInteger)numberOfSubViews;
- (CGFloat)heightOfHeaderView;
- (UIView *)headerView;
- (NSArray *)tabTitles;
- (id)richTabView:(TYZRichTabView *)richTabView viewForIndex:(NSInteger)index;
- (void)richTabView:(TYZRichTabView *)richTabView scrollTo:(NSInteger)index;

#pragma mark -ContentTableView
- (NSInteger)richTabView:(TYZRichTabView *)richTabView numberOfSectionsInTableView:(UITableView *)tableView index:(NSInteger)index;

- (NSInteger)richTabView:(TYZRichTabView *)richTabView tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section index:(NSInteger)index;

- (CGFloat)richTabView:(TYZRichTabView *)richTabView tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index;

- (UITableViewCell *)richTabView:(TYZRichTabView *)richTabView tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath index:(NSInteger)index;

- (void)richTabView:(TYZRichTabView *)richTabView tableView:(UIScrollView *)tableView scrollWithIndex:(NSInteger)index;
@end
