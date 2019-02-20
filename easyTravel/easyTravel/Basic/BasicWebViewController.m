//
//  BasicWebViewController.m
//  easyTravel
//
//  Created by Land on 2019/2/20.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "BasicWebViewController.h"

@interface BasicWebViewController () <WKNavigationDelegate,UIScrollViewDelegate, WKUIDelegate>

@property (strong, nonatomic) NSString * url;
@property (strong, nonatomic) NSString * navigationTitle;
@property (strong, nonatomic) NSDictionary * parameters;

@end

@implementation BasicWebViewController

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params postMethod:(BOOL)postMethod {
    if (postMethod || !([params isKindOfClass:[NSDictionary class]] && params.count > 0)) {
        return baseURL;
    }
    
    NSURL * parsedURL = [NSURL URLWithString:baseURL];
    NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString * query = [self stringFromDictionary:params];
    
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

+ (NSString *)stringFromDictionary:(NSDictionary *)dict {
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [dict keyEnumerator]) {
        NSString * val = [dict valueForKey:key];
        if (!([val isKindOfClass:[NSString class]])) {
            if ([val isKindOfClass:[NSNumber class]]) {
                val = [(NSNumber*)val stringValue];
            } else continue;
        }
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [self URLEncodedString:val]]];
    }
    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)URLEncodedString:(NSString*)string {
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8 string:string];
}

+ (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding string:(NSString*)string {
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding));
}

- (id)initWithURL:(NSString*)url title:(NSString*)title {
    if (self = [self initWithURL:url title:title parameters:nil]) {
        //
    }
    return self;
}

- (id)initWithURL:(NSString*)url title:(NSString*)title parameters:(NSDictionary*)params {
    if (self = [super init]) {
        self.url = url;
        self.navigationTitle = title.length > 0 ? title : @"";
        self.parameters = params;
//        self.updateTitle = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reLayout {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    
    // 支持内嵌视频播放，不然网页中的视频无法播放
    config.allowsInlineMediaPlayback = YES;
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    _webView.navigationDelegate = self;
    _webView.scrollView.delegate = self;
    _webView.UIDelegate = self;
    
    if ([_url isKindOfClass:[NSString class]] && _url.length > 0) {
        NSString * urlFinal = [BasicWebViewController serializeURL:_url params:_parameters postMethod:_postMethod];
        
        NSURL * requestURL =  [NSURL URLWithString:[urlFinal stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:requestURL cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:10];
        if (_postMethod) {
            [request setHTTPMethod:@"POST"];
            if ([_parameters isKindOfClass:[NSDictionary class]] && _parameters.count > 0) {
                NSMutableData * body = [NSMutableData data];
                [body appendData:[[BasicWebViewController stringFromDictionary:_parameters] dataUsingEncoding:NSUTF8StringEncoding]];
                [request setHTTPBody:body];
            }
        } else {
            [request setHTTPMethod:@"GET"];
        }
        
        [self.view addSubview:_webView];
        [_webView loadRequest:request];
    }
}

#pragma mark - WKNavigationDelegate
// 开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didStartProvisionalNavigation   ====    %@", navigation);
}

// 页面加载完调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didFinishNavigation   ====    %@", navigation);
}

// 类似 UIWebView 的 -webView: shouldStartLoadWithRequest: navigationType:
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    // 电话
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    urlString = [urlString stringByRemovingPercentEncoding];// 解析url
    if ([urlString hasPrefix:@"tel"]) { // 截获电话请求
        // 取消WKWebView 打电话请求
        decisionHandler(WKNavigationActionPolicyCancel);
        // 用openURL 这个API打电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: urlString]];
    } else if ([urlString isEqualToString:@"https://m.ly.com/home/index.html"] || [urlString isEqualToString:@"https://m.ly.com/"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);// 允许其他请求
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"didFailProvisionalNavigation   ====    %@\nerror   ====   %@", navigation, error);
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription] message:nil delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"OK", nil) otherButtonTitles:nil, nil];
    [alertView show];
}

// 内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"didCommitNavigation   ====    %@", navigation);
}

//HTTPS认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)dealloc {
//    if (self.updateTitle) [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"UniversalWeb"];
    self.webView.navigationDelegate = nil;
    self.webView.scrollView.delegate = nil;
    self.webView = nil;
//    self.updateTitle = NO;
}

@end
