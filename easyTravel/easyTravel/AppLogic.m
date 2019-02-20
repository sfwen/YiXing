//
//  AppLogic.m
//  easyTravel
//
//  Created by apple on 15/7/22.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AppLogic.h"
#import "AFNetworking.h"
#import "AFAppDotNetAPIClient.h"
#import "Toast+UIView.h"
#import "AppDelegate.h"
#import "CommonUtil.h"
#import "HotelCellModel.h"


@implementation AppLogic

@synthesize isLogin;
@synthesize userInfo;
@synthesize ucode;
@synthesize goods_id;
@synthesize goods_name;
@synthesize order_number;
@synthesize myMoney;
@synthesize loginSuccessWillGoViewTag;
@synthesize head_img;
@synthesize vipFlag;
@synthesize phone;
@synthesize loginSucessPhone;
@synthesize loginSuccessPassword;

static AppLogic *sharedInstance = nil;



+(AppLogic *)sharedInstance{
    @synchronized(self) {
        if(sharedInstance == nil) {
            sharedInstance.isLogin = NO;
            sharedInstance = [[[self class] alloc] init]; //   assignment   not   done   here
        }
    }
    return sharedInstance;
}

-(void)makeToast:(NSString*)content{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window makeToast:content duration:1.0f position:@"center"];
}
-(void)initUserInfo{
    __weak AppLogic* logicSelf = self;
    double loginTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"loginTime"];
    double now = [[[NSDate alloc] init] timeIntervalSince1970];
    double diff = now - loginTime;
    bool ifMoreThanOneMonth = diff>(30*24*60*60);//自动登录超过1个月失效
    //bool ifMoreThanOneMonth = diff>(2);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"] && !ifMoreThanOneMonth) {
        NSDictionary *attributes = @{
                                     @"phone":[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"],
                                     @"password":[[NSUserDefaults standardUserDefaults] objectForKey:@"password"]
                                     };
        
        [logicSelf login:attributes success:^(){
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [app.window makeToast:[NSString stringWithFormat:@"欢迎回来,%@",[logicSelf.userInfo valueForKeyPath:@"real_name"]] duration:2.0f position:@"center"];
        } fail:^(NSString *message) {
            //AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            //[app.window makeToast:@"自动登录失败" duration:2.0f position:@"center"];
        }];
    }
    
}

-(void)checkPhone:(NSString*)phone success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,CHECK_PHONE];
    NSDictionary *parameters = @{@"phone":phone};
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:parameters success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"checkPhone_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        //NSLog(@"checkPhone_error_is:%@", error);
    }];
}


-(void)regist:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,REGIST];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"regist_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            [self login:attributtes success:^(){
                success();
                AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                [app.window makeToast:[NSString stringWithFormat:@"欢迎回来,%@",[logicSelf.userInfo valueForKeyPath:@"real_name"]] duration:2.0f position:@"center"];
            } fail:^(NSString *message) {
                //AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                //[app.window makeToast:@"自动登录失败" duration:2.0f position:@"center"];
            }];
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        //NSLog(@"regist_error_is:%@", error);
    }];
}


-(void)getShortMessageCode:(NSString*)phone success:(void (^)(NSInteger messageCode))success fail:(void (^)(NSString* message))fail{//status->code 为0表示正常
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_SHORT_MESSAGE_CODE];
    NSDictionary *parameters = @{@"phone":phone};
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:parameters success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"getShortMessageCode_response_is_%@",JSON);
         NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSInteger shortMessageCode = [[[JSON valueForKeyPath:@"data"] valueForKeyPath:@"code"] integerValue];
            success(shortMessageCode);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        //NSLog(@"getShortMessageCode_error_is:%@", error);
        [logicSelf doError:error];
    }];
}

-(void)getRegistMsgCode:(NSString*)phone success:(void (^)(NSInteger messageCode))success fail:(void (^)(NSString* message))fail{//status->code 为0表示正常
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_REGIST_MSG_CODE];
    NSDictionary *parameters = @{@"phone":phone};
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:parameters success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"getShortMessageCode_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSInteger shortMessageCode = [[[JSON valueForKeyPath:@"data"] valueForKeyPath:@"code"] integerValue];
            success(shortMessageCode);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        //NSLog(@"getShortMessageCode_error_is:%@", error);
        [logicSelf doError:error];
    }];
}

-(void)findPassword:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,FIND_PASSWORD];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"findPassword_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *attributes = @{
                                        @"phone":[[JSON valueForKeyPath:@"data"] valueForKeyPath:@"phone"],
                                        @"password":[[JSON valueForKeyPath:@"data"] valueForKeyPath:@"password"],
                                        };
            [self login:attributes success:^{
                success();
            } fail:^(NSString *message) {
                [self makeToast:message];
            }];
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        //NSLog(@"findPassword_error_is:%@", error);
    }];
}


-(void)login:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,LOGIN];
    //AFHTTPResponseSerializer *serializer = [AFAppDotNetAPIClient sharedClient].responseSerializer;
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"login_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            logicSelf.isLogin = YES;
            logicSelf.userInfo = [JSON valueForKeyPath:@"data"];
            logicSelf.head_img = [userInfo valueForKeyPath:@"head_img"];
            logicSelf.phone = [userInfo valueForKeyPath:@"phone"];
            logicSelf.real_name = [userInfo valueForKeyPath:@"real_name"];
            logicSelf.myMoney = [[userInfo valueForKeyPath:@"money"] doubleValue];
            logicSelf.ucode = [[JSON valueForKeyPath:@"data"] valueForKey:@"ucode"];
            logicSelf.vipFlag = [[[JSON valueForKeyPath:@"data"] valueForKey:@"is_vip"] intValue];
            logicSelf.loginSucessPhone = [attributtes valueForKeyPath:@"phone"];
            logicSelf.loginSuccessPassword = [attributtes valueForKeyPath:@"password"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:nil];
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
    }];
}

-(void)doError:(NSError *)error{
    __weak AppLogic* logicSelf = self;
    if([[[error valueForKeyPath:@"_userInfo"] valueForKeyPath:@"_kCFStreamErrorDomainKey"] intValue]==12&&[[[error valueForKeyPath:@"_userInfo"] valueForKeyPath:@"_kCFStreamErrorCodeKey"] intValue]==8){
        [logicSelf makeToast:@"你的网络出了点问题,请检测网络或重试一下！"];
    }else{
        //[self makeToast:@"请求服务器接口出错!"];
        [logicSelf makeToast:[[[error valueForKeyPath:@"_userInfo"] valueForKeyPath:@"NSLocalizedDescription"] description]];
        //NSLocalizedDescription
    }
}

-(void)exit{
    isLogin = NO;
    userInfo = nil;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoLogin"];
    //[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"phone"];
    //[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self makeToast:@"已退出!"];
}

-(void)modifyPassword:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
     NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,MODIFY_PASSWORD];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"modifyPassword_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        //NSLog(@"modifyPassword_error_is:%@", error);
    }];
}

-(void)getMessageList:(NSDictionary*)attributtes success:(void (^)(NSArray *listData))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_MESSAGE_LIST];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"getMessageList_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSMutableArray *mutableData = [[NSMutableArray alloc] init];
            NSArray *data = [JSON valueForKeyPath:@"data"];
            if([data isKindOfClass:[NSArray class]]){
                for(int i=0;i<[data count];i++){
                    NSDictionary *eachData = [data objectAtIndex:i];
                    Msg *message = [[Msg alloc] init];
                    
                    message.create_time = [eachData valueForKeyPath:@"create_time"];
                    message.title = [eachData valueForKeyPath:@"title"];
                    message.content = [eachData valueForKeyPath:@"content"];
                    message.is_read = [[eachData valueForKeyPath:@"is_read"] intValue];
                    message.id = [[eachData valueForKeyPath:@"id"] intValue];

                    [mutableData addObject:message];
                }
            }
            success(mutableData);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        //NSLog(@"getMessageList_error_is:%@", error);
    }];
}
-(void)getMessageDetail:(NSDictionary*)attributtes success:(void (^)(NSDictionary *messageData))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_MESSAGE_DETAIL];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getMessageDetail_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getMessageDetail_error_is:%@", error);
    }];
}

-(void)getVipLobbyList:(NSDictionary*)attributtes success:(void (^)(NSArray *listData))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_VIP_LOBBY_LIST];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"getVipLobbyList_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSArray *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        //NSLog(@"getVipLobbyList_error_is:%@", error);
    }];
}

-(void)getVIpLobbyDetail:(NSDictionary*)attributtes success:(void (^)(NSDictionary *goodsInfo))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_VIP_LOBBY_DETAIL];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"getVIpLobbyDetail_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        //NSLog(@"getVIpLobbyDetail_error_is:%@", error);
    }];
}

-(void)getCommentList:(NSDictionary*)attributtes success:(void (^)(NSArray *listData))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_COMMENT_LIST];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"getCommentList_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSArray *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        //NSLog(@"getCommentList_error_is:%@", error);
    }];
}

-(void)addComment:(NSData*)imageData1 :(NSData*)imageData2 :(NSData*)imageData3:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,ADD_COMMENT];
    
    
    /*
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
    NSLog(@"addComment_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"addComment_error_is:%@", error);
     }];*/
    
    
    
    
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes constructingBodyWithBlock:^(id<AFMultipartFormData>formData){
        
        if(imageData1!=nil){
            [formData appendPartWithFileData:imageData1 name:@"sevaluation_image1" fileName:@"sevaluation_image1.jpg" mimeType:@"image/jpeg"];
        }
        if(imageData2!=nil){
            [formData appendPartWithFileData:imageData2 name:@"sevaluation_image2" fileName:@"sevaluation_image2.jpg" mimeType:@"image/jpeg"];
        }
        if(imageData3!=nil){
            [formData appendPartWithFileData:imageData3 name:@"sevaluation_image3" fileName:@"sevaluation_image3.jpg" mimeType:@"image/jpeg"];
        }
        
        
        
    } success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"addComment_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"addComment_error_is:%@", error);
    }];
}



-(void)getUserInfo:(NSDictionary*)attributtes success:(void (^)(NSDictionary*personInfo))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_USER_INFO];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getUserInfo_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *info = [JSON valueForKeyPath:@"data"];
            logicSelf.vipFlag = [[info valueForKeyPath:@"is_vip"] intValue];
            success(info);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getUserInfo_error_is:%@", error);
    }];

}

-(void)updateUserInfo:(NSData*)imageData:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,UPDATE_USER_INFO];
    
    /*
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"updateUserInfo_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"updateUserInfo_error_is:%@", error);
    }];*/
    
    
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes constructingBodyWithBlock:^(id<AFMultipartFormData>formData){
        
        if(imageData!=nil){
            [formData appendPartWithFileData:imageData name:@"head_img" fileName:@"head_img.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"updateUserInfo_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"updateUserInfo_error_is:%@", error);
    }];
    
    
    
}


-(void)addOrder:(NSDictionary*)attributtes success:(void (^)(NSDictionary* orderData))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,ADD_ORDER];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"addOrder_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *data = [JSON valueForKeyPath:@"data"];
            NSString *oId = [data valueForKeyPath:@"order_number"];
            logicSelf.order_number = oId;
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        //NSLog(@"addOrder_error_is:%@", error);
    }];
}

-(void)cancelOrder:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,ORDER_CANCEL];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        //NSLog(@"cancelOrder_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        //NSLog(@"cancelOrder_error_is:%@", error);
    }];
}

-(void)hideOrder:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,ORDER_HIDE];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"hideOrder_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"hideOrder_error_is:%@", error);
    }];
}


-(void)getOrderByType:(enum ORDER_MODE)orderMode:(NSDictionary*)attributtes success:(void (^)(NSArray *listData))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = nil;
    
    switch (orderMode) {
        case ORDER_ALL:
            urlString = [NSString stringWithFormat:@"%@%@",HOST,ORDER_LIST_ALL];
            break;
        case ORDER_NO_PAY:
            urlString = [NSString stringWithFormat:@"%@%@",HOST,ORDER_LIST_NO_PAY];
            break;
        case ORDER_NO_GET:
            urlString = [NSString stringWithFormat:@"%@%@",HOST,ORDER_LIST_NO_GET];
            break;
        case ORDER_NO_COMMENTS:
            urlString = [NSString stringWithFormat:@"%@%@",HOST,ORDER_LIST_NO_COMMENTS];
            break;
        case ORDER_IS_OVER:
            urlString = [NSString stringWithFormat:@"%@%@",HOST,ORDER_LIST_IS_OVER];
            break;
        default:
            break;
    }
    
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getOrderByType_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSArray *data = [JSON valueForKeyPath:@"data"];
            if(![data isKindOfClass:[NSArray class]]){
                success(@[]);
            }else{
                success(data);
            }
            
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getOrderByType_error_is:%@", error);
    }];
}


-(void)confirmUseOrder:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,CONFIRM_USE_ORDER];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"confirmUseOrder_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"confirmUseOrder_error_is:%@", error);
    }];
}


-(void)getMoneyBack:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_MONEY_BACK];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getMoneyBack_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getMoneyBack_error_is:%@", error);
    }];
}

-(void)withDrawCash:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,WITH_DRAW_CASH];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"withDrawCash_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"withDrawCash_error_is:%@", error);
    }];
}

-(void)leftPay:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,LEFT_PAY];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"leftPay_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"leftPay_error_is:%@", error);
    }];
}

-(void)inCharge:(NSDictionary*)attributtes success:(void (^)(NSDictionary *chargeData))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,IN_CHARTE];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"inCharge_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"inCharge_error_is:%@", error);
    }];
}

/**
 * 微信充值
 */
- (void)weChatInCharge:(NSDictionary *)attributtes success:(void(^)(NSDictionary *chargeData))success fail:(void(^)(NSString *message))fail {
    __weak AppLogic *weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@Userwithdrawals/wxpay",HOST];
    [[AFAppDotNetAPIClient sharedClient] POST:urlStr parameters:attributtes success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"*****%@",responseObject);
        NSInteger status = [[[responseObject valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if (status == 0) {
            NSDictionary *data = [responseObject valueForKeyPath:@"data"];
            success(data);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf doError:error];
    }];
}

/**
 * 微信支付
 */
- (void)weChatNormalPay:(NSDictionary *)attributtes success:(void(^)(NSDictionary *data))success fail:(void(^)(NSString *message))fail {
    __weak AppLogic *weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@Pay/wxpay",HOST];
    [[AFAppDotNetAPIClient sharedClient] POST:urlStr parameters:attributtes success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"****%@",responseObject);
        NSInteger status = [[[responseObject valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if (status == 0) {
            NSDictionary *data = [responseObject valueForKeyPath:@"data"];
            success(data);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf doError:error];
    }];
}

/**
 * 微信VIP支付
 */
- (void)wechatVipPay:(NSDictionary *)attributtes success:(void(^)(NSDictionary *data))success fail:(void(^)(NSString *message))fail {
    __weak AppLogic *weakSelf = self;
    NSString *urlStr = [NSString stringWithFormat:@"%@uservip/wxpay",HOST];
    [[AFAppDotNetAPIClient sharedClient] POST:urlStr parameters:attributtes success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"****%@",responseObject);
        NSInteger status = [[[responseObject valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if (status == 0) {
            NSDictionary *data = [responseObject valueForKeyPath:@"data"];
            success(data);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf doError:error];
    }];
}


-(void)getMoneyBackList:(NSDictionary*)attributtes success:(void (^)(NSArray *listData))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,MONEY_BACK_LIST];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getMoneyBackList_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSArray *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getMoneyBackList_error_is:%@", error);
    }];
}


-(void)getMoney:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_MONEY];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getMoney_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            logicSelf.myMoney = [[[JSON valueForKeyPath:@"data"] valueForKeyPath:@"money"] doubleValue];
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getMoney_error_is:%@", error);
    }];
}

-(void)getBankPayTN:(NSDictionary*)attributtes success:(void (^)(NSString* tn))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,BANK_PAY];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getBankPayTN_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSString *tn = [[[JSON valueForKeyPath:@"data"] valueForKeyPath:@"orderId"] description];
            success(tn);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getBankPayTN_error_is:%@", error);
    }];
}

-(void)inChargeFromBank:(NSDictionary*)attributtes success:(void (^)(NSDictionary *chargeData))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,IN_CHARTE_FROM_BANK];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"inChargeFromBank_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"inChargeFromBank_error_is:%@", error);
    }];
}

-(void)buyVipWithAlipay:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,BUY_VIP_WITH_ALIPAY];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"buyVipWithAlipay_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"buyVipWithAlipay_error_is:%@", error);
    }];

}
-(void)buyVipWithBank:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,BUY_VIP_WITH_BANK];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"buyVipWithBank_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"buyVipWithBank_error_is:%@", error);
    }];
}
//512071
-(void)buyVipWithLeftMoney:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,BUY_VIP_WITH_LEFT_MONEY];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"buyVipWithLeftMoney_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"buyVipWithLeftMoney_error_is:%@", error);
    }];
}

-(void)getVipMoney:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_VIP_MONEY];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getVipMoney_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getVipMoney_error_is:%@", error);
    }];
}

-(void)getLevelUpOrderList:(NSDictionary*)attributtes success:(void (^)(NSArray *data))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_LEVEL_UP_ORDER_LIST];
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getLevelUpOrderList_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSArray *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getLevelUpOrderList_error_is:%@", error);
    }];
}

-(void)getScore:(NSDictionary*)attributtes success:(void (^)(NSString* score))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_MY_SCORE];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getScore_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSString *user_integral = [[JSON valueForKeyPath:@"data"] valueForKeyPath:@"user_integral"];
            success(user_integral);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getScore_error_is:%@", error);
    }];
}

-(void)getScoreList:(NSDictionary*)attributtes success:(void (^)(NSArray* scoreData))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_SCORE_LIST];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getScoreList_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSArray *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getScoreList_error_is:%@", error);
    }];
}


-(void)getAboutInfo:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_ABOUT_INFO];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getAboutInfo_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getAboutInfo_error_is:%@", error);
    }];
}

-(void)getBannerContent:(NSDictionary*)attributtes success:(void (^)(NSDictionary *data))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,GET_BANNER_CONTENT];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        NSLog(@"getBannerContent_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            NSDictionary *data = [JSON valueForKeyPath:@"data"];
            success(data);
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getBannerContent_error_is:%@", error);
    }];
}


//-(void)getHotelList:(NSDictionary*)attributtes success:(void (^)(NSArray *data))success fail:(void (^)(NSString* message))fail;{
//    //加密服务器转参数
//    //POST - http://yixing.zgcom.cn/api.php/Curl/sendGetData
//    __weak AppLogic* logicSelf = self;
//    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Curl/sendGetData";
//    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
//    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON){
//        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            //[AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
//            NSString *string = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
//            NSRange range = [string rangeOfString:@"{"];
//            int location = range.location;
//            NSDictionary *dic = [CommonUtil dictionaryWithJsonString:[string substringFromIndex:location]];
//            
//            //NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//            NSArray *Hotels = [[dic objectForKey:@"Result"] objectForKey:@"Hotels"];
//            NSMutableArray* hotelIDS = [[NSMutableArray alloc] init];
//            for(int i=0;i<[Hotels count];i++){
//                //HotelCellModel *model = [[HotelCellModel alloc] init];
//                //model.HotelId=[[Hotels objectAtIndex:i] objectForKey:@"HotelId"];
//                //model.LowRate=[[Hotels objectAtIndex:i] objectForKey:@"LowRate"];
//                //[resultArray addObject:model];
//                //if(i==0){
//                    [hotelIDS addObject:[[Hotels objectAtIndex:i] objectForKey:@"HotelId"]];
//                //}
//                
//            }
//            
//            NSString *hotelIDStr = [hotelIDS componentsJoinedByString:@","];
//            
//            
//            NSDictionary *data = @{
//                                   @"Local": @"zh_CN",
//                                   @"Request": @{
//                                           @"ArrivalDate": _ArrivalDate,
//                                           @"DepartureDate":_DepartureDate,
//                                           @"HotelIds": hotelIDStr,
//                                           @"Options": @"1,2,3,4,5",
//                                    },
//                                   @"Version": @1.1
//                                   };
//            NSDictionary *postDatas = @{@"data":[CommonUtil getJSONString:data],@"method":@"hotel.detail"};
//            
//            
//            [[AppLogic sharedInstance] getHotelDetail:postDatas success:^(NSDictionary *data) {
//                //NSLog(@"获取到数据了");
//                NSArray *hotels = [[data objectForKey:@"Result"] objectForKey:@"Hotels"];
//                 NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//                for(int i=0;i<[hotels count];i++){
//                    HotelCellModel *model = [[HotelCellModel alloc] init];
//                    model.HotelId=[[hotels objectAtIndex:i] objectForKey:@"HotelId"];
//                    model.LowRate=[[hotels objectAtIndex:i] objectForKey:@"LowRate"];
//                    model.HotelName = [[[hotels objectAtIndex:i] objectForKey:@"Detail"] objectForKey:@"HotelName"];
//                    [resultArray addObject:model];
//                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    success(resultArray);
//                });
//            } fail:^(NSString *message) {
//                //NSLog(@"获取数据失败了");
//            }];
//
//            
//            
//            
//            
//            
//            
//            
//            
//            
////            dispatch_async(dispatch_get_main_queue(), ^{
////                success(resultArray);
////            });
//            
//            
//            //NSLog(@"getHotelList_response_is_%@",dic);
//        });
//        
//    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//        //[AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
//        [logicSelf doError:error];
//        NSLog(@"getHotelList_error_is:%@", error);
//    }];
//}




-(void)getHotelList:(NSDictionary*)attributtes success:(void (^)(NSArray *data))success fail:(void (^)(NSString* message))fail;{
    //加密服务器转参数
    //POST - http://yixing.zgcom.cn/api.php/Curl/sendGetData
    __weak AppLogic* logicSelf = self;
    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Curl/sendGetData";
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON){
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //[AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
            NSString *string = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
            NSRange range = [string rangeOfString:@"{"];
            int location = range.location;
            NSDictionary *dic = [CommonUtil dictionaryWithJsonString:[string substringFromIndex:location]];
            
            NSMutableArray *resultArray = [[NSMutableArray alloc] init];
            NSArray *Hotels = [[dic objectForKey:@"Result"] objectForKey:@"Hotels"];
            //NSMutableArray* hotelIDS = [[NSMutableArray alloc] init];
            for(int i=0;i<[Hotels count];i++){
                HotelCellModel *model = [[HotelCellModel alloc] init];
                model.HotelId=[[Hotels objectAtIndex:i] objectForKey:@"HotelId"];
                model.LowRate=[[Hotels objectAtIndex:i] objectForKey:@"LowRate"];
                [resultArray addObject:model];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                success(resultArray);
            });
            
            
            //NSLog(@"getHotelList_response_is_%@",dic);
        });
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        //[AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
        [logicSelf doError:error];
        NSLog(@"getHotelList_error_is:%@", error);
    }];
}



-(void)gethotelCellNameAndImage:(NSDictionary*)attributtes row:(int)row success:(void (^)(NSString *name,int row,NSString *thumbImage))success fail:(void (^)(NSString* message))fail{
    //加密服务器转参数
    //POST - http://yixing.zgcom.cn/api.php/Curl/sendGetData
    __weak AppLogic* logicSelf = self;
    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Curl/sendGetData";
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //[AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
            NSString *string = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
            NSRange range = [string rangeOfString:@"{"];
            int location = range.location;
            NSDictionary *dic = [CommonUtil dictionaryWithJsonString:[string substringFromIndex:location]];
            
            NSString *HotelName = [[[[[dic objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"HotelName"];
            NSString *ThumbNailUrl = [[[[[dic objectForKey:@"Result"] objectForKey:@"Hotels"] objectAtIndex:0] objectForKey:@"Detail"] objectForKey:@"ThumbNailUrl"];
            //NSLog(@"gethotelCellNameAndImage_response_is_%@",dic);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(HotelName,row,ThumbNailUrl);
            });
            
        });
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        //[AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
        [logicSelf doError:error];
        NSLog(@"gethotelCellNameAndImage_error_is:%@", error);
    }];
}


-(void)getHotelDetail:(NSDictionary*)attributtes success:(void (^)(NSDictionary* data))success fail:(void (^)(NSString* message))fail{
    //加密服务器转参数
    //POST - http://yixing.zgcom.cn/api.php/Curl/sendGetData
    __weak AppLogic* logicSelf = self;
    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Curl/sendGetData";
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //[AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
            NSString *string = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
            NSRange range = [string rangeOfString:@"{"];
            int location = range.location;
            NSDictionary *dic = [CommonUtil dictionaryWithJsonString:[string substringFromIndex:location]];
            
            
            NSLog(@"getHotelDetail_response_is_%@",dic);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(dic);
            });
            
        });
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        //[AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
        [logicSelf doError:error];
        NSLog(@"getHotelDetail_error_is:%@", error);
    }];
}


-(void)createHotelOrder:(NSDictionary*)attributtes success:(void (^)(NSDictionary* data))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Curl/sendGetData";
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *string = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
            NSRange range = [string rangeOfString:@"{"];
            int location = range.location;
            NSDictionary *dic = [CommonUtil dictionaryWithJsonString:[string substringFromIndex:location]];
            NSLog(@"createHotelOrder_response_is_%@",dic);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(dic);
            });
            
        });
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"createHotelOrder_error_is:%@", error);
    }];

}

-(void)getHotelOrderList:(NSDictionary*)attributtes success:(void (^)(NSDictionary* data))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Curl/sendGetData";
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *string = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
            NSRange range = [string rangeOfString:@"{"];
            int location = range.location;
            NSDictionary *dic = [CommonUtil dictionaryWithJsonString:[string substringFromIndex:location]];
            NSLog(@"getHotelOrderList_response_is_%@",dic);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(dic);
            });
            
        });
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"getHotelOrderList_error_is:%@", error);
    }];

}





-(void)cancelHotelOrder:(NSDictionary*)attributtes success:(void (^)(NSDictionary* data))success fail:(void (^)(NSString* message))fail{
    __weak AppLogic* logicSelf = self;
    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Curl/sendGetData";
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *string = [[NSString alloc] initWithData:JSON encoding:NSUTF8StringEncoding];
            NSRange range = [string rangeOfString:@"{"];
            int location = range.location;
            NSDictionary *dic = [CommonUtil dictionaryWithJsonString:[string substringFromIndex:location]];
            NSLog(@"cancelHotelOrder_response_is_%@",dic);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(dic);
            });
            
        });
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [logicSelf doError:error];
        NSLog(@"cancelHotelOrder_error_is:%@", error);
    }];
    
}







-(void)sendSms:(NSDictionary*)attributtes success:(void (^)())success fail:(void (^)(NSString* message))fail{
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    __weak AppLogic* logicSelf = self;
    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Curl/sendSms";
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask * task, id JSON) {
        [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
        NSLog(@"sendSms_response_is_%@",JSON);
        NSInteger status = [[[JSON valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if(status==0){
            success();
        }else{
            fail([[JSON valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
        [logicSelf doError:error];
        NSLog(@"getBankPayTN_error_is:%@", error);
    }];
}


/**
 * 获取推荐文章列表
 */
-(void)getRecommendArtcleListSuccess:(void(^)(NSArray *data))success fail:(void(^)(NSString *message))fail {
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Document/getHotDocumednt";
    __weak AppLogic *weakSelf = self;
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSInteger status = [[[responseObject valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if (status == 0) {
            NSArray *arr = [responseObject valueForKey:@"data"];
            success(arr);
        } else {
            fail([[responseObject valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf doError:error];
    }];
}

/**
 * 获取文章列表
 */
- (void)getarticleListWithAttributtes:(NSDictionary *)attributtes success:(void(^)(NSArray *data))sucess fail:(void(^)(NSString *message))fail {
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Document/getDocumednt";
    __weak AppLogic *weakSelf = self;
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger status = [[[responseObject valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if (status == 0) {
            NSArray *arr = [responseObject valueForKey:@"data"];
            sucess(arr);
        } else {
            fail([[responseObject valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf doError:error];
    }];
}

/**
 * 获取文章详情
 */
- (void)getArticleDetailWithAttributtes:(NSString *)attributtes success:(void(^)(NSDictionary *data))success fail:(void(^)(NSString *message))fail {
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Document/info/did/";
//    NSString *urlString = [NSString stringWithFormat:@"http://yixing.zgcom.cn/api.php/Document/info/did/%@",attributtes];
    NSDictionary *parms = @{@"id":attributtes};
    __weak AppLogic *weakSelf = self;
//    [AFAppDotNetAPIClient sharedClient] GET:<#(NSString *)#> parameters:<#(id)#> success:<#^(NSURLSessionDataTask *task, id responseObject)success#> failure:<#^(NSURLSessionDataTask *task, NSError *error)failure#>
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:parms success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf doError:error];
    }];
}

/**
 * 搜索
 */
- (void)searchArticleWithAttributtes:(NSDictionary *)attributtes success:(void(^)(NSArray *data))success fail:(void(^)(NSString *message))fail {
    [AFAppDotNetAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *urlString = @"http://yixing.zgcom.cn/api.php/Document/documedntSearch";
    __weak AppLogic *weakSelf = self;
    [[AFAppDotNetAPIClient sharedClient] POST:urlString parameters:attributtes success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger status = [[[responseObject valueForKeyPath:@"status"] valueForKeyPath:@"code"] integerValue];
        if (status == 0) {
            NSArray *arr = [responseObject valueForKey:@"data"];
            success(arr);
        } else {
            fail([[responseObject valueForKeyPath:@"status"] valueForKeyPath:@"msg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf doError:error];
    }];
}
@end
