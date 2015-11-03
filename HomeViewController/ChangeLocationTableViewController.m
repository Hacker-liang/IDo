//
//  ChangeLocationTableViewController.m
//  IDo
//
//  Created by liangpengshuai on 10/5/15.
//  Copyright © 2015 com.Yinengxin.xianne. All rights reserved.
//

#import "ChangeLocationTableViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface ChangeLocationTableViewController () <UISearchBarDelegate, AMapSearchDelegate> {
    AMapSearchAPI *_searchApi;
}

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UISearchBar *searchBar;


@end

@implementation ChangeLocationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [AMapSearchServices sharedServices].apiKey = @"6a7ece2e9426d1dba4deea411bf64dcc";
    _searchApi = [[AMapSearchAPI alloc] init];
    _searchApi.delegate = self;
    
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchBar.delegate = self;
    _searchBar.returnKeyType = UIReturnKeyDone;
    [_searchBar setPlaceholder:@"请输入地址"];
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.showsCancelButton = YES;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    [_searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"icon_search_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
    [_searchBar setTranslucent:YES];
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.navigationItem.titleView = _searchBar;
    UIImageView *imageBg = [[UIImageView alloc]initWithFrame:CGRectMake((kWindowWidth - 210)/2, 68, 210, 130)];
    imageBg.image = [UIImage imageNamed:@"search_default_background"];
    [_searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    AMapPOI *poi = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = poi.name;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    NSString *str = [NSString stringWithFormat:@"%@%@",  poi.city, poi.district];
    cell.detailTextLabel.text = str;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapPOI *poi = [self.dataSource objectAtIndex:indexPath.row];
   
    NSString *str = [NSString stringWithFormat:@"%@%@%@",  poi.city, poi.district, poi.name];
    [_delegate didChangeAddress:poi.location.latitude lng:poi.location.longitude address:str];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    [self.dataSource removeAllObjects];
    for (AMapPOI *poi in response.pois) {
        [self.dataSource addObject:poi];
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        return;
    }
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = searchText;
    request.city = _cityCode;
    request.requireExtension = YES;
    [_searchApi AMapPOIKeywordsSearch:request];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}
@end
