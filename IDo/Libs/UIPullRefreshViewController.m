//
//  UIPullRefreshViewController.m
//  iTings
//
//  Created by Tan Anzhen on 11-8-16.
//  Copyright 2011 autoradio. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIPullRefreshViewController.h"

#define REFRESH_HEADER_HEIGHT 70.0f
#define HEADER_HEIGHT 300.0f
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]

@implementation UIPullRefreshViewController

@synthesize refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner,lastUpdatedLabel;
@synthesize tableView;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	//	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	//	imageView.image = UIImageLoad(@"Background");
	//	[self.view addSubview:imageView];
	//	[imageView release];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 333) style:UITableViewStylePlain];
	
	[self.view addSubview:self.tableView]; 
	[self addPullToRefreshHeader];
}

- (void)addPullToRefreshHeader
{
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,-HEADER_HEIGHT, Width(320), HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
	
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 240.0f, Width(320), 20.0f)];
	refreshLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	refreshLabel.font = [UIFont systemFontOfSize:13.0f];
	refreshLabel.textColor = TEXT_COLOR;
	refreshLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
	refreshLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	refreshLabel.backgroundColor = [UIColor clearColor];
	refreshLabel.textAlignment = 1;
	
	lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 255.0f, Width(320), 35.0f)];
	lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	lastUpdatedLabel.font = [UIFont boldSystemFontOfSize:13.0f];
	lastUpdatedLabel.textColor = TEXT_COLOR;
	lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
	lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	lastUpdatedLabel.backgroundColor = [UIColor clearColor];
	lastUpdatedLabel.textAlignment = 1;
	
	
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow"]];
    refreshArrow.frame = CGRectMake(22.0f, 240.0f, 27.0f, 44.0f);
	
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(25.0f, 255.0f, 20.0f, 20.0f);
    refreshSpinner.hidesWhenStopped = YES;
	
    [refreshHeaderView addSubview:refreshLabel];
	[refreshHeaderView addSubview:lastUpdatedLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self.tableView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    if (isUIPullRefreshLoading) 
        return;
    isDragging = YES;
}
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView
{
	if (isUIPullRefreshLoading) 
    {
		// Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } 
    else if (isDragging && scrollView.contentOffset.y < 0) 
    {
		// Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
		//		refreshLabel.textColor = [UIColor whiteColor];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT)
        {
			// User is scrolling above the header
            refreshLabel.text = @"轻放刷新...";
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } 
        else
        { // User is scrolling somewhere within the header
			refreshLabel.text = @"下拉刷新...";
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
		NSDate *date = [NSDate date];//[_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		lastUpdatedLabel.text = [NSString stringWithFormat:@"最近更新日期: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        [UIView commitAnimations];
    }
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    if (isUIPullRefreshLoading) 
    {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } 
    else if (isDragging && scrollView.contentOffset.y < 0) 
    {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
		//		refreshLabel.textColor = [UIColor whiteColor];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT)
        {
            // User is scrolling above the header
            refreshLabel.text = @"轻放刷新...";
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } 
        else
        { // User is scrolling somewhere within the header
			refreshLabel.text = @"下拉刷新...";
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
		NSDate *date = [NSDate date];//[_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		
		lastUpdatedLabel.text = [NSString stringWithFormat:@"最近更新日期: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
    if (isUIPullRefreshLoading) 
        return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) 
    {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading 
{
    isUIPullRefreshLoading = YES;
	
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
	refreshLabel.text = @"数据加载中...";
	//	refreshLabel.textColor = [UIColor whiteColor];
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
	
    // Refresh action!
    [self refresh];
}

- (void)stopLoading 
{
    isUIPullRefreshLoading = NO;
	
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    // Reset the header
	refreshLabel.text = @"下拉刷新...";
	//	refreshLabel.textColor = [UIColor whiteColor];
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh 
{
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.tableView = nil;
}


//- (void)dealloc 
//{
//    [refreshHeaderView release];
//    [refreshLabel release];
//    [refreshArrow release];
//    [refreshSpinner release];
//	[tableView release];
//	[lastUpdatedLabel release];
//    [super dealloc];
//}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    // Return the number of rows in the section.
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)stableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [stableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

@end
