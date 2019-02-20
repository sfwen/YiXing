//
//  CityViewController.h
//  TableViewGrouped
//
//  Created by laijiawei on 14-10-10.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AppDelegate.h"

@protocol CitySelectDelegate <NSObject>
@optional
-(void)selectCity:(NSString*)name cityCode:(NSString*)cityCode;
@end


@interface CityViewController : BaseViewController<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (strong, nonatomic)  NSArray * sortArray;
@property (copy, nonatomic)  UIButton * btnAccessoryView;
@property (copy, nonatomic)  UISearchBar *searchBar;
@property (strong, nonatomic)  NSMutableArray *cityarray;
@property (strong, nonatomic)  NSMutableDictionary * tableViewDic;
@property (strong, nonatomic)  NSMutableDictionary * cityDic;
@property (strong, nonatomic)  NSMutableArray *hotcityarray;


@property (nonatomic, assign) id<CitySelectDelegate> delegate;

@end
