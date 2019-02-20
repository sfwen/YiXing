//
//  Common.h
//  easyTravel
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef easyTravel_Common_h
#define easyTravel_Common_h


#define LIST_PAGE_SIZE 5
#define LOBBY_LIST_PAGE_SIZE 10
#define ORDER_LIST_PAGE_SIZE 10

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define pId @"2088711072657400"
#define sId @"18180775559@163.com"
#define pKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMDX7t998O+CUaNB\
wusn1A6rd0NFcfCgT/2wRUxYPu8oZNTbqdL1mK7+hJUYPBLe9f4Pt+fv1syAeXmp\
cvlZ2FRZ0SjDojo2MrmtApVP8P4sEoznvpFcgHn2Mk/L41Im6k0jNPoeiom1YoZj\
gyfCAAHLYaqVbgnG6vLnciECdj87AgMBAAECgYBgkIAz94ubU2Vv27EwMbx1MBVD\
YVXhyVTk0syQoyu4dECxeeF7GrI/BoH7aqxCQtVpSBOuF6I2uyqY6moBRKUXD1Nc\
xVVjMKTaVm3pePNei3GR5AbSIDybz9AkNCe8iGSUrIZ3vuA21SakFCLAq/4m1zH9\
+kZZNJBNSlQiQDGcSQJBAP8F819loGf2TpQ4MTprUaEyTYfnqrIBmePoycDDR/Lk\
N3g36pp9DTG5gu27S5LVNUtZOLSrOFK1RGC7PxJQK2cCQQDBlQPxxhofDWUigivt\
S2PdEo1ywjxFnAbQnMIlhg3GZdLiV5ZRwtGuU7ult9izAq4w8Q58RqIIieKVhl1a\
P70NAkAFzUnbKsG6e8UP5DNig9yIkU9oPyIICLdKkxo783Volj6Y0pTYzO2G6xSK\
eg9fGNCslSwQGDEg2JTkqn3l2cMTAkEArUNVDndDNfvlQ2fDLVbHAT3zwH09OQiX\
yOwlkTRU6/iDMfc3IeL/jcqAL6lHmaGSi1eWoYEO0hmn5jEnKPnXmQJBAIkq9wh1\
B3krbkOZAHkSCIVMm5gxko7dV+m7clW9LSvOG2Y3WjDFPp5xuqp7uHftBTOINK4N\
RAl8m8mEANr/8ZU="

#define HOST @"http://yixing.zgcom.cn/api.php/"
#define IMAGE_HOST @"http://yixing.zgcom.cn/"

#define CHECK_PHONE @"regist/check_phone"
#define REGIST @"regist/regist"
#define GET_SHORT_MESSAGE_CODE @"useredit/password_code"
#define FIND_PASSWORD @"useredit/find_password"
#define LOGIN @"login/login"
#define MODIFY_PASSWORD @"useredit/edit_password"

#define GET_REGIST_MSG_CODE @"regist/code"



//user
#define GET_USER_INFO @"userinfo/my"
#define UPDATE_USER_INFO @"useredit/edit_info"


//message
#define GET_MESSAGE_LIST @"leavemsg/msg"
#define GET_MESSAGE_DETAIL @"leavemsg/info"




//goods

#define GET_VIP_LOBBY_LIST @"goodslists/lists"
#define GET_VIP_LOBBY_DETAIL @"goodsinfo/info"






//comment
#define GET_COMMENT_LIST @"Goodsevaluation/lists"
#define ADD_COMMENT @"Goodsevaluationadd/add_eval"



enum ORDER_MODE{
    ORDER_NO_PAY = 0,
    ORDER_NO_GET = 1,
    ORDER_NO_COMMENTS = 2,
    ORDER_IS_OVER = 3,
    ORDER_ALL = 4,
};



//order
#define ADD_ORDER @"orderadd/add"
#define ORDER_LIST_ALL @"orderlists/all"
#define ORDER_CANCEL @"orderstatus/order_cancel"
#define ORDER_LIST_NO_PAY @"orderlists/no_pay"
#define ORDER_LIST_NO_GET @"orderlists/no_get"
#define ORDER_LIST_NO_COMMENTS @"orderlists/no_contents"
#define ORDER_LIST_IS_OVER @"orderlists/is_over"
#define ORDER_LIST_IS_OVER @"orderlists/is_over"
#define CONFIRM_USE_ORDER @"orderlists/order_confirm"
#define GET_MONEY_BACK @"orderapply/applying"

#define ORDER_HIDE @"orderstatus/hide"


//pay
#define ALI_PAY @"pay/alipay"//普通订单未使用此接口
#define ALI_PAY_CALLBACK @"pay/notifyurl"
#define LEFT_PAY @"orderadd/balance_pay"
#define IN_CHARTE @"userwithdrawals/recharge"
#define CHARGE_CALL_BACK @"userwithdrawals/notifyurl"

//获取银联tn接口
//#define BANK_PAY @"pay/uniopay"
#define BANK_PAY @"payu/do_pay"
#define IN_CHARTE_FROM_BANK @"Userwithdrawals/uniopay"

//提现
#define WITH_DRAW_CASH  @"userwithdrawals/add"

//退款列表
#define MONEY_BACK_LIST @"refundlists/all"


//查询余额
#define GET_MONEY @"/userinfo/mymoney"






typedef NS_ENUM(NSInteger,PAY_TYPE) {
    PAY_TYPE_NORMAL = 0,//贵宾厅普通订单
    PAY_TYPE_VIP = 1,//购买VIP订单
};
typedef NS_ENUM(NSInteger,VIP_TYPE) {
    VIP_TYPE_NORMAL = 1,//普通VIP
    VIP_TYPE_DIAMOND = 3,//砖石VIP
};
//VIP相关
#define BUY_VIP_WITH_ALIPAY  @"uservip/recharge"
#define BUY_VIP_ALIPAY_CALLBACK  @"uservip/notifyurl"
#define BUY_VIP_WITH_BANK  @"uservip/uniopay"
#define BUY_VIP_WITH_LEFT_MONEY  @"uservip/balance_pay_vip"
#define GET_VIP_MONEY @"userviplist/vipmoney"


#define GET_LEVEL_UP_ORDER_LIST @"userviplist/lists"




//积分
#define  GET_MY_SCORE @"userintegral/myintegral"
#define  GET_SCORE_LIST @"userintegral/lists"


//关于内容
#define  GET_ABOUT_INFO @"about/infos"

//banner
#define GET_BANNER_CONTENT @"banner/infos"




#endif
