//
//  CityViewController.m
//  TableViewGrouped
//
//  Created by laijiawei on 14-10-10.
//
//

#import "CityViewController.h"
#import "ZhongWenToPinyin.h"
#import "AppLogic.h"
#import "CommonUtil.h"
#import "City.h"
#import "Common.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
@interface CityViewController ()

@end

@implementation CityViewController
@synthesize tableViewDic;
@synthesize sortArray;
@synthesize searchBar;
@synthesize cityDic;
@synthesize cityarray;
@synthesize cityTableView;
@synthesize hotcityarray;

- (void)viewDidLoad
{
    
    //self.isBackButton=YES;

    [super viewDidLoad];

    searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-40, 44)];
    [searchBar setBackgroundColor:[UIColor grayColor]];
    searchBar.autocorrectionType=UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType=UITextAutocapitalizationTypeNone;
    searchBar.keyboardType=UIKeyboardTypeDefault;
    searchBar.placeholder=[NSString stringWithCString:"输入城市名字"  encoding: NSUTF8StringEncoding];
    searchBar.delegate=self;
    
    UIView *tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [tableHeaderView addSubview:searchBar];
    [self.view insertSubview:tableHeaderView aboveSubview:self.cityTableView];
     self.cityTableView.tableHeaderView=tableHeaderView;
    
     _btnAccessoryView=[[UIButton alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, self.view.bounds.size.height)];
    [_btnAccessoryView setBackgroundColor:[UIColor blackColor]];
    [_btnAccessoryView setAlpha:0.0f];
    
    [_btnAccessoryView addTarget:self action:@selector(ClickControlAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_btnAccessoryView];
    
    hotcityarray=[[NSMutableArray  alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hotCity" ofType:@"plist"]];
    //cityarray=[[NSMutableArray  alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"]];
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    cityarray=app.xmlParser.cityArray;
    
    cityDic=[[NSMutableDictionary alloc]init];
    
    NSString * pinyin=nil;
    
    NSMutableArray *arr=nil;
    
    for (City * city in cityarray){
        pinyin=[[ZhongWenToPinyin pinyinFromZhongWenString:city.name] substringToIndex:1];
        //NSLog(@"pinyin__%@___city.name___%@",pinyin,city.name);
        //如果包含key
        if([[cityDic allKeys]containsObject:pinyin]){
            arr=[cityDic objectForKey:pinyin];
            [arr addObject:city];
            [cityDic setObject:arr forKey:pinyin];
        }else{
            arr= [[NSMutableArray alloc]initWithObjects:city, nil];
            [cityDic setObject:arr forKey:pinyin];
        }
    }
    
    sortArray=[[NSMutableArray alloc]initWithObjects:@"热门", nil];
    //sortArray=[[NSMutableArray alloc] init];
    sortArray= [sortArray arrayByAddingObjectsFromArray:[[cityDic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //[cityDic setObject:hotcityarray forKey:@"热门"];
    [cityDic setObject:@[@"热门"] forKey:@"热门"];
    
    tableViewDic=cityDic;
    
    
    
//    NSDictionary *data = @{@"Local":@"zh_CN",@"Request":@{@"ArrivalDate":@"2015-11-03T00:00:00+08:00",@"CityId":@"6140856",@"CustomerType":@"0",@"DepartureDate":@"2015-11-04T00:00:00+08:00",@"DistrictId":@"0101",@"Facilities":@"1,2",@"GroupId":@10101129,@"HighRate":@400,@"LowRate":@200,@"PageIndex":@1,@"PageSize":@2,@"PaymentType":@"SelfPay",@"ResultType":@"1,2,3",@"Sort":@"DistanceAsc",@"StarRate":@"2,3,4",@"ThemeIds":@"1,2"},@"Version":@2.0};
//    
//    NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.list"};
//    
//    [[AppLogic sharedInstance] getHotelList:postDatas success:^(NSDictionary *data) {
//        
//    } fail:^(NSString *message) {
//        
//    }];

    
    
    
}

#pragma mark UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (self.searchBar.text.length==0) {
        [_btnAccessoryView setAlpha:0.7f];
        self.searchBar.showsCancelButton=YES;//是否显示取消按钮
        for(id cc in [self.searchBar subviews])
        {
            if([cc isKindOfClass:[UIButton class]])
            {
                UIButton *btn = (UIButton *)cc;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
            }
        }
    }
    return YES;
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchBar resignFirstResponder];
    [self controlAccessoryView:0];
}

// 当搜索内容变化时,执行该方法.很有用,可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (self.searchBar.text.length==0) {
        [_btnAccessoryView setAlpha:0.7f];
        self.searchBar.showsCancelButton=YES;//是否显示取消按钮
        
        
        
        
        
        
        
        sortArray=[[NSMutableArray alloc]initWithObjects:@"热门", nil];
        [cityDic removeObjectForKey:@"热门"];
        sortArray= [sortArray arrayByAddingObjectsFromArray:[[cityDic allKeys] sortedArrayUsingSelector:@selector(compare:)]];
        [cityDic setObject:@[@"热门"] forKey:@"热门"];
        tableViewDic=cityDic;
        
        
        
        
        
        
        
        
        
        
        
        
        
        [cityTableView reloadData];
        
        
        
        
        
        
        
        
        
        
    }else{
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        for(City * city in cityarray){
            if([city.name hasPrefix:searchText]){
                [arr addObject:city];
            }
        }
        tableViewDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:arr,@"结果",nil];
        sortArray=[[NSMutableArray alloc]initWithObjects:@"结果", nil];
        [cityTableView reloadData];
        [UIView animateWithDuration:0.2 animations:^{
            //动画代码
            [self.btnAccessoryView setAlpha:0];
        }completion:^(BOOL finished){
                [self.searchBar setShowsCancelButton:NO animated:YES];
                [self.navigationController setNavigationBarHidden:NO animated:YES];
        }];
    }
}

// 遮罩层（按钮）-点击处理事件
- (void) ClickControlAction:(id)sender{
    [self controlAccessoryView:0];
}


// 控制遮罩层的透明度
- (void)controlAccessoryView:(float)alphaValue{
    
    [UIView animateWithDuration:0.2 animations:^{
        //动画代码
        [self.btnAccessoryView setAlpha:alphaValue];
    }completion:^(BOOL finished){
        if (alphaValue<=0) {
            [self.searchBar resignFirstResponder];
            [self.searchBar setShowsCancelButton:NO animated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }];
}


#pragma mark Table View Data Source Methods
//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSMutableArray *array=[tableViewDic objectForKey:[sortArray objectAtIndex:section]];
    City *city = [array objectAtIndex:row];
    if([_delegate respondsToSelector:@selector(selectCity:cityCode:)]){
        [_delegate selectCity:city.name cityCode:city.cID];
    }
    //NSLog(@"%@",[array objectAtIndex:row]);
    //[[NSUserDefaults  standardUserDefaults]setObject:[array objectAtIndex:row] forKey:@"city"];
    //[[NSUserDefaults  standardUserDefaults]synchronize];
    [searchBar resignFirstResponder];
    [self back:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return [sortArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return [[tableViewDic objectForKey:[sortArray objectAtIndex:section]]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //这个方法用来告诉某个分组的某一行是什么数据，返回一个UITableViewCell
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    if(self.searchBar.text.length==0){
        if(section==0){
            static NSString *GroupedTableIdentifierHot = @"hot";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     GroupedTableIdentifierHot];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:GroupedTableIdentifierHot];
            }
            
            
            if(IS_IPHONE_5){
                float cellWidth = cell.frame.size.width/5;
                for(int i=0;i<[hotcityarray count];i++){
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.layer.borderColor = [CommonUtil getColor:@"E6E6E6"].CGColor;
                    button.layer.borderWidth = 1.0f;
                    [button setTitle:[hotcityarray objectAtIndex:i] forState:UIControlStateNormal];
                    [button setTitleColor:[CommonUtil getColor:@"191919"] forState:UIControlStateNormal];
                    button.frame = CGRectMake(10+(i%4)*(cellWidth+5), (i/4)*40, cellWidth, 30);
                    [button addTarget:self action:@selector(hotCityClick:) forControlEvents:UIControlEventTouchDown];
                    [cell.contentView addSubview:button];
                }
            }else if(IS_IPHONE_6||IS_IPHONE_6P){
                float cellWidth = cell.frame.size.width/4;
                for(int i=0;i<[hotcityarray count];i++){
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.layer.borderColor = [CommonUtil getColor:@"E6E6E6"].CGColor;
                    button.layer.borderWidth = 1.0f;
                    [button setTitle:[hotcityarray objectAtIndex:i] forState:UIControlStateNormal];
                    [button setTitleColor:[CommonUtil getColor:@"191919"] forState:UIControlStateNormal];
                    button.frame = CGRectMake(10+(i%4)*(cellWidth+5), (i/4)*40, cellWidth, 30);
                    [button addTarget:self action:@selector(hotCityClick:) forControlEvents:UIControlEventTouchDown];
                    [cell.contentView addSubview:button];
                }

            }
            
            
            
            return cell;
            
        }else{
            static NSString *GroupedTableIdentifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     GroupedTableIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:GroupedTableIdentifier];
            }
            
            NSMutableArray *array=[tableViewDic objectForKey:[sortArray objectAtIndex:section]];
            
            //给Label附上城市名称  key 为：C_Name
            cell.textLabel.text = ((City*)[array objectAtIndex:row]).name;
            cell.textLabel.textColor = [CommonUtil getColor:@"191919"];
            
            return cell;
        }
        
    }else{
        static NSString *GroupedTableIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 GroupedTableIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:GroupedTableIdentifier];
        }
        
        NSMutableArray *array=[tableViewDic objectForKey:[sortArray objectAtIndex:section]];
        
        //给Label附上城市名称  key 为：C_Name
        cell.textLabel.text = ((City*)[array objectAtIndex:row]).name;
        cell.textLabel.textColor = [CommonUtil getColor:@"191919"];
        
        return cell;
    }
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //这个方法用来告诉表格第section分组的名称
    return [sortArray objectAtIndex:section];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.searchBar.text.length==0){
        if(indexPath.section==0){
            return 200;
        }
        return 40.0f;
    }else{
        return 40.0f;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //返回省份的数组
    return sortArray;
}

//点击返回按钮
-(void)back:(UIButton *) button
{
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-50, 7, 50, 30)];
        t.font = [UIFont systemFontOfSize:16];
        t.textColor = [UIColor whiteColor];
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = NSTextAlignmentCenter;
        
        t.text =@"目的地";
        
        self.navigationItem.titleView = t;
        
        self.hidesBottomBarWhenPushed=YES;
        // 下一个界面的返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
        backButton.frame = CGRectMake(0.0, 0.0, 40.0, 27.0);
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateSelected];
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        temporaryBarButtonItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem=temporaryBarButtonItem;
        
    }
    
    
    
    
    return self;
}

//- (void)back:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
//}

-(City*)findCity:(NSString*)name{
    for(int i=0;i<[cityarray count];i++){
        City* city = [cityarray objectAtIndex:i];
        if([city.name isEqualToString:name]){
            return city;
        }
    }
    return nil;
}
-(void)hotCityClick:(UIButton*)sender{
    City* city = [self findCity:sender.titleLabel.text];
    //NSLog(@"name_%@__code___%@",city.name,city.cID);
    if([_delegate respondsToSelector:@selector(selectCity:cityCode:)]){
        [_delegate selectCity:city.name cityCode:city.cID];
    }
    [self back:nil];
}

@end
