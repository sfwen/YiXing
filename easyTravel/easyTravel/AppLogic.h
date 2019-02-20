//
//  AppLogic.h
//  easyTravel
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Msg.h"

@interface AppLogic : NSObject

@property(assign,nonatomic) BOOL isLogin;
@property(strong,nonatomic) NSDictionary *userInfo;
@property(copy,nonatomic) NSString *ucode;
@property(copy,nonatomic) NSString *goods_id;
@property(copy,nonatomic) NSString *goods_name;
@property(copy,nonatomic) NSString *order_number;
@property(copy,nonatomic) NSString *head_img;
@property(copy,nonatomic) NSString *phone;
@property(assign,nonatomic) double myMoney;
@property(assign,nonatomic) int loginSuccessWillGoViewTag;//登录成功之后将跳往的界面
@property(assign,nonatomic) int vipFlag;
@property(copy,nonatomic)NSString *real_name;
@property(copy,nonatomic)NSString *loginSucessPhone;
@property(copy,nonatomic)NSString *loginSuccessPassword;

@property(nonatomic,copy)NSString* ArrivalDate;
@property(nonatomic,copy)NSString* DepartureDate;

+(AppLogic *)sharedInstance;

-(void)initUserInfo;
-(void)makeToast:(NSString*)content;


-(void)checkPhone:(NSString*)phone success:(void (^)())success fail:(void (^)(NSString* message))fail;

-(void)regist:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;

-(void)getShortMessageCode:(NSString*)phone success:(void (^)(NSInteger messageCode))success fail:(void (^)(NSString* message))fail;

-(void)findPassword:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;

-(void)login:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;

-(void)exit;

-(void)modifyPassword:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;

-(void)getMessageList:(NSDictionary*)attributtes success:(void (^)(NSArray *listData))success fail:(void (^)(NSString* message))fail;
-(void)getMessageDetail:(NSDictionary*)attributtes success:(void (^)(NSDictionary *messageData))success fail:(void (^)(NSString* message))fail;
-(void)getVipLobbyList:(NSDictionary*)attributtes success:(void (^)(NSArray *listData))success fail:(void (^)(NSString* message))fail;
-(void)getVIpLobbyDetail:(NSDictionary*)attributtes success:(void (^)(NSDictionary *goodsInfo))success fail:(void (^)(NSString* message))fail;

-(void)getCommentList:(NSDictionary*)attributtes success:(void (^)(NSArray *listData))success fail:(void (^)(NSString* message))fail;




-(void)addComment:(NSData*)imageData1 :(NSData*)imageData2 :(NSData*)imageData3 :(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;

-(void)getUserInfo:(NSDictionary*)attributtes success:(void (^)(NSDictionary*personInfo))success fail:(void (^)(NSString* message))fail;
-(void)updateUserInfo:(NSData*)imageData:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;



-(void)addOrder:(NSDictionary*)attributtes success:(void (^)(NSDictionary* orderData))success fail:(void (^)(NSString* message))fail;
-(void)cancelOrder:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;
-(void)hideOrder:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;
-(void)getOrderByType:(enum ORDER_MODE)orderMode:(NSDictionary*)attributtes success:(void (^)(NSArray *listData))success fail:(void (^)(NSString* message))fail;

-(void)confirmUseOrder:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;


-(void)getMoneyBack:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;

-(void)withDrawCash:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;

-(void)leftPay:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;

-(void)inCharge:(NSDictionary*)attributtes success:(void (^)(NSDictionary *chargeData))success fail:(void (^)(NSString* message))fail;
//微信充值
- (void)weChatInCharge:(NSDictionary *)attributtes success:(void(^)(NSDictionary *chargeData))success fail:(void(^)(NSString *message))fail;
//微信支付
- (void)weChatNormalPay:(NSDictionary *)attributtes success:(void(^)(NSDictionary *data))success fail:(void(^)(NSString *message))fail;
//微信vip支付
- (void)wechatVipPay:(NSDictionary *)attributtes success:(void(^)(NSDictionary *data))success fail:(void(^)(NSString *message))fail;

-(void)getMoneyBackList:(NSDictionary*)attributtes success:(void (^)(NSArray *listData))success fail:(void (^)(NSString* message))fail;

-(void)getMoney:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;


-(void)getBankPayTN:(NSDictionary*)attributtes success:(void (^)(NSString* tn))success fail:(void (^)(NSString* message))fail;

-(void)inChargeFromBank:(NSDictionary*)attributtes success:(void (^)(NSDictionary *chargeData))success fail:(void (^)(NSString* message))fail;

//vip相关

-(void)buyVipWithAlipay:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail;
-(void)buyVipWithBank:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail;
-(void)buyVipWithLeftMoney:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail;
-(void)getVipMoney:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail;

-(void)getLevelUpOrderList:(NSDictionary*)attributtes success:(void (^)(NSArray *data))success fail:(void (^)(NSString* message))fail;

-(void)getRegistMsgCode:(NSString*)phone success:(void (^)(NSInteger messageCode))success fail:(void (^)(NSString* message))fail;



-(void)getScore:(NSDictionary*)attributtes success:(void (^)(NSString* score))success fail:(void (^)(NSString* message))fail;

-(void)getScoreList:(NSDictionary*)attributtes success:(void (^)(NSArray* scoreData))success fail:(void (^)(NSString* message))fail;

-(void)getAboutInfo:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail;

-(void)getBannerContent:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail;


-(void)getHotelList:(NSDictionary*)attributtes success:(void (^)(NSArray *data))success fail:(void (^)(NSString* message))fail;


-(void)gethotelCellNameAndImage:(NSDictionary*)attributtes row:(int)row success:(void (^)(NSString *name,int row,NSString *thumbImage))success fail:(void (^)(NSString* message))fail;

-(void)getHotelDetail:(NSDictionary*)attributtes success:(void (^)(NSDictionary* data))success fail:(void (^)(NSString* message))fail;

-(void)createHotelOrder:(NSDictionary*)attributtes success:(void (^)(NSDictionary* data))success fail:(void (^)(NSString* message))fail;

-(void)getHotelOrderList:(NSDictionary*)attributtes success:(void (^)(NSDictionary* data))success fail:(void (^)(NSString* message))fail;

-(void)cancelHotelOrder:(NSDictionary*)attributtes success:(void (^)(NSDictionary* data))success fail:(void (^)(NSString* message))fail;

-(void)sendSms:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail;

//获取推荐文章列表
-(void)getRecommendArtcleListSuccess:(void(^)(NSArray *data))success fail:(void(^)(NSString *message))fail;

//获取文章列表
- (void)getarticleListWithAttributtes:(NSDictionary *)attributtes success:(void(^)(NSArray *data))sucess fail:(void(^)(NSString *message))fail;
//文章详细
- (void)getArticleDetailWithAttributtes:(NSString *)attributtes success:(void(^)(NSDictionary *data))success fail:(void(^)(NSString *message))fail;

//搜索
- (void)searchArticleWithAttributtes:(NSDictionary *)attributtes success:(void(^)(NSArray *data))success fail:(void(^)(NSString *message))fail;

@end
