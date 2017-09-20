
//
//  ViewController.m
//  news app
//
//  Created by 李希昂 on 2017/5/21.
//  Copyright © 2017年 李希昂. All rights reserved.
//
#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)
#import "ViewController.h"
#import "FMDB.h"
#import "webViewController.h"
@interface ViewController ()
@property(strong,nonatomic) NSMutableArray *buttonArray;
@property(strong,nonatomic) NSMutableArray *buttonTextArray;
@property(strong,nonatomic) NSMutableArray *temp;
@property(strong,nonatomic) UISearchBar *searchBar;
@end

@implementation ViewController
bool isSearch ;

- (void)viewDidLoad {
    [super viewDidLoad];
    [fmdbTool initialize];
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    myDelegate.buttonArray = self.buttonArray;
    self.buttonTextArray = myDelegate.buttonTextArray;
    self.internetState = [ViewController isExistenceNetwork];
    
    [self initTableView];// init tableview
   
    if (self.internetState) {
        [self internetDownload];  //judge internet state
        self.tableview.tableFooterView = self.tabelViewFooterView;
    }
    
    NSArray* DbArray = [fmdbTool statusesWithParams:self.presentContent];
    NSInteger DbArraycount = DbArray.count;
    
    self.dataArray = [[NSMutableArray alloc]init];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableview setRefreshControl:refreshControl];
    myDelegate.buttonArray =self.buttonArray;
    isSearch = NO;
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 15)];
    self.searchBar.delegate = self;
    UINavigationController *nav = myDelegate.navController;
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"timg.jpeg"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.searchBar];
    
    
    if(self.internetState == NO && DbArraycount == 0){
        UIView *noInternetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height-300)];
        UILabel* noInternetLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-300, SCREEN_WIDTH, 70)];
        noInternetLabel.text = @"    咦，调皮的志浩干扰了您的互联网连接哦～";
        [noInternetLabel setFont:[UIFont systemFontOfSize:24]];
        self.tableview.tableFooterView = noInternetView;
        [noInternetView addSubview:noInternetLabel];
        [noInternetView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"志浩.jpg"]]];
        [self.tableview reloadData];
    }

    if(self.internetState == NO && DbArraycount != 0){
        if([self.presentContent isEqualToString:@"war"]){
            self.temp = self.war;
        }
        if([self.presentContent isEqualToString:@"gupiao"]){
            self.temp = self.gupiao;
        }
        if([self.presentContent isEqualToString:@"ent"]){
            self.temp = self.ent;
        }
        if([self.presentContent isEqualToString:@"edu"]){
            self.temp = self.edu;
        }
        if([self.presentContent isEqualToString:@"lady"]){
            self.temp = self.lady;
        }
        if([self.presentContent isEqualToString:@"tech"]){
            self.temp = self.tech;
        }
        if([self.presentContent isEqualToString:@"travel"]){
            self.temp = self.travel;
        }
        if([self.presentContent isEqualToString:@"money"]){
            self.temp = self.money;
        }
        if([self.presentContent isEqualToString:@"sport"]){
            self.temp = self.sport;
        }
        
        int pageNamber = [self.page intValue];
        for(NSMutableDictionary *dictionary in DbArray)
        {
            newsData *data = [[newsData alloc] initWithDict:dictionary];
            
            newsFrame *dataFrame = [[newsFrame alloc]init];
            [dataFrame setNewsData:data];
            [self.temp addObject:dataFrame];
        }
        int i;
        NSMutableArray *array= [[NSMutableArray alloc]init];
        for(i=10*(pageNamber - 1);i<pageNamber * 10 ;i++){
            [array addObject:self.temp[i]];
        }
        //                    [self.temp subarrayWithRange:NSMakeRange(10*(pageNamber - 1), pageNamber * 10 -1 )];
        self.totalArray = [NSMutableArray arrayWithArray:array];
        [self.tableview reloadData];
       
        
    }

    }

//    int i;
//    NSMutableArray *text = [[NSMutableArray alloc]init];
//    for(i=0;i<self.buttonTextArray.count;i++){
//        NSString *string =[[NSString alloc]init];
//        string = [string initWithFormat:@"%@",self.buttonTextArray[i]];
//        [text addObject:string];
//    }
//    self.buttonTextArray = text;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [TableViewCell cellWithTableView:tableView];
    cell.backgroundColor = [UIColor whiteColor];
    cell.dataFrame = self.totalArray[indexPath.row];
    return cell;
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!isSearch){
    return self.totalArray.count;
    }
    else{
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    newsFrame *dataframe = self.totalArray[indexPath.row];
    
    return 150;//dataframe.cellH;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)internetDownload{
    
    if([self.presentContent isEqualToString:@"war"]){
        self.temp = self.war;
    }
    if([self.presentContent isEqualToString:@"gupiao"]){
        self.temp = self.gupiao;
    }
    if([self.presentContent isEqualToString:@"ent"]){
        self.temp = self.ent;
    }
    if([self.presentContent isEqualToString:@"edu"]){
        self.temp = self.edu;
    }
    if([self.presentContent isEqualToString:@"lady"]){
        self.temp = self.lady;
    }
    if([self.presentContent isEqualToString:@"tech"]){
        self.temp = self.tech;
    }
    if([self.presentContent isEqualToString:@"travel"]){
        self.temp = self.travel;
    }
    if([self.presentContent isEqualToString:@"money"]){
        self.temp = self.money;
    }
    if([self.presentContent isEqualToString:@"sport"]){
        self.temp = self.sport;
    }
    
    int pageNamber = [self.page intValue];
    if(self.temp.count/10 < pageNamber){
    
    NSString *urlString = [NSString stringWithFormat:@"http://wangyi.butterfly.mopaasapp.com/news/api?type=%@&page=%@&limit=10",self.presentContent,self.page];
    NSURL *url = [ NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data && !error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
         //   [self.war addObjectsFromArray:[dict objectForKey:@"list"]];
            NSLog(@"%@",dict);
                    

            NSMutableArray *arrays = [dict objectForKey:@"list"];
                    
            for(NSMutableDictionary *dictionary in arrays)
            {
                newsData *data = [[newsData alloc] initWithDict:dictionary];
//                for (NSDictionary *status in statuses) {
                    // NSDictionary --> NSData
//                    NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:status];
//                    [_db executeUpdateWithFormat:@"INSERT INTO t_status(status, idstr) VALUES (%@, %@);", statusData, status[@"idstr"]];
//                }  将数据存入数据库
                newsFrame *dataFrame = [[newsFrame alloc]init];
                [dataFrame setNewsData:data];
                [self.temp addObject:dataFrame];//data[@"channelname"] isequalto ?? [self.?? addobject ]
                
//                self.totalArray = self.temp;
                
            }
                    int i;
                    NSMutableArray *array= [[NSMutableArray alloc]init];
                    for(i=10*(pageNamber - 1);i<pageNamber * 10 ;i++){
                        [array addObject:self.temp[i]];
                    }
//                    [self.temp subarrayWithRange:NSMakeRange(10*(pageNamber - 1), pageNamber * 10 -1 )];
                self.totalArray = [NSMutableArray arrayWithArray:array];
                [self.tableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    [fmdbTool initialize];
                    [fmdbTool saveStatuses:self.totalArray];
                    [fmdbTool count];

                }
        
    }] resume];
        [self.tableview performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }
    else{
        self.totalArray = self.temp;
    }
    //加个过场动画让tableview在刷新之前不会惦记新的button
}

- (void)initTableView
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    self.buttonTextArray = myDelegate.buttonTextArray;
    if(!self.tableview){
    UITableView *tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, SCREEN_HEIGHT)];// - 49 - 64)];
    tableview.backgroundColor = [UIColor whiteColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    self.tableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/15)];
    self.tableview.tableFooterView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/10)];
    self.tableview.tableHeaderView.backgroundColor = [UIColor lightGrayColor];
    self.tableview.tableHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timg.jpeg"]];
    self.tableview.tableFooterView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timg.jpeg"]];
        self.tabelViewFooterView = self.tableview.tableFooterView;
        self.buttonArray = [[NSMutableArray alloc]init];
        int i;
        for(i=0;i<5;i++){
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(60*i, 0, 55, 50)];
            [self.tableview.tableHeaderView addSubview:button];
            button.tag = i;
            [button setTintColor:[UIColor blackColor]];
          //  [button setTitle:self.buttonTextArray[i] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"按钮2.png"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.buttonArray addObject:button];
        }
    
        UIButton *changeSubscription =[[UIButton alloc]initWithFrame:CGRectMake(350, 5, 50, 40)];
        [self.tableview.tableHeaderView addSubview:changeSubscription];
        [changeSubscription addTarget:self action:@selector(turnToChangeView) forControlEvents:UIControlEventTouchUpInside];
        [changeSubscription setTitle:@"订阅" forState:UIControlStateNormal];
        [changeSubscription setBackgroundImage:[UIImage imageNamed:@"按钮2.png"] forState:UIControlStateNormal];        self.page = @"1";
        if([self.buttonTextArray[0] isEqualToString:@"军事"]){
            self.presentContent =@"war";
        }
        if([self.buttonTextArray[0] isEqualToString:@"股票"]){
           self.presentContent =@"gupiao";
        }
        if([self.buttonTextArray[0] isEqualToString:@"娱乐"]){
            self.presentContent =@"ent";
        }
        if([self.buttonTextArray[0] isEqualToString:@"教育"]){
            self.presentContent =@"edu";
        }
        if([self.buttonTextArray[0] isEqualToString:@"旅游"]){
            self.presentContent =@"travel";
        }
        if([self.buttonTextArray[0] isEqualToString:@"女性"]){
            self.presentContent =@"lady";
        }
        if([self.buttonTextArray[0] isEqualToString:@"经济"]){
            self.presentContent =@"money";;
        }
        if([self.buttonTextArray[0] isEqualToString:@"体育"]){
            self.presentContent =@"sport";
        }
        if([self.buttonTextArray[0] isEqualToString:@"科技"]){
            self.presentContent =@"tech";
        }

        UILabel *page = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 10 , 15, 30, 30)];
        page.text = self.page;
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"map_icon_label.png"]];
        [page setBackgroundColor:color];
        self.pages = page;
        [self.tableview.tableFooterView addSubview:page];

        
        for(i = 0;i < self.buttonTextArray.count;i++){
            
            if([self.buttonTextArray[i] isEqualToString:@"军事"]){
                [self.buttonArray[i] setUserInteractionEnabled:YES];
                [self.buttonArray[i] setTitle:@"军事" forState:UIControlStateNormal];
            }
            if([self.buttonTextArray[i] isEqualToString:@"股票"]){
                [self.buttonArray[i] setUserInteractionEnabled:YES];
                [self.buttonArray[i] setTitle:@"股票" forState:UIControlStateNormal];
            }
            if([self.buttonTextArray[i] isEqualToString:@"娱乐"]){
                [self.buttonArray[i] setUserInteractionEnabled:YES];
                [self.buttonArray[i] setTitle:@"娱乐" forState:UIControlStateNormal];
            }
            if([self.buttonTextArray[i] isEqualToString:@"教育"]){
               [self.buttonArray[i] setUserInteractionEnabled:YES];
                [self.buttonArray[i] setTitle:@"教育" forState:UIControlStateNormal];
            }
            if([self.buttonTextArray[i] isEqualToString:@"旅游"]){
                [self.buttonArray[i] setUserInteractionEnabled:YES];
                [self.buttonArray[i] setTitle:@"旅游" forState:UIControlStateNormal];
            }
            if([self.buttonTextArray[i] isEqualToString:@"女性"]){
                [self.buttonArray[i] setUserInteractionEnabled:YES];
                [self.buttonArray[i] setTitle:@"女性" forState:UIControlStateNormal];
            }
            if([self.buttonTextArray[i] isEqualToString:@"经济"]){
                [self.buttonArray[i] setUserInteractionEnabled:YES];
                [self.buttonArray[i] setTitle:@"经济" forState:UIControlStateNormal];
            }
            if([self.buttonTextArray[i] isEqualToString:@"体育"]){
                [self.buttonArray[i] setUserInteractionEnabled:YES];
                [self.buttonArray[i] setTitle:@"体育" forState:UIControlStateNormal];
            }
            if([self.buttonTextArray[i] isEqualToString:@"科技"]){
                [self.buttonArray[i] setUserInteractionEnabled:YES];
                [self.buttonArray[i] setTitle:@"科技" forState:UIControlStateNormal];
            }
            
            
            
            UIButton *nextPageButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 15, 5, 50, 50)];
            
            [nextPageButton setBackgroundImage:[UIImage imageNamed:@"下一页.png"]  forState:UIControlStateNormal];
            [nextPageButton addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
            [self.tableview.tableFooterView addSubview:nextPageButton];
            
            UIButton *previousPageButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 80, 5, 50, 50)];
            
            [previousPageButton setBackgroundImage:[UIImage imageNamed:@"上一页.png"] forState:UIControlStateNormal];
            [previousPageButton addTarget:self action:@selector(previousPage:) forControlEvents:UIControlEventTouchUpInside];
            [self.tableview.tableFooterView addSubview:previousPageButton];
            
        }

    }
}

- (NSMutableArray *)totalArray
{
    if (!_totalArray) {
        _totalArray = [[NSMutableArray alloc]init];
//        newsFrame *dataFrame = [[newsFrame alloc]init];
//        newsData *data = [[newsData alloc]init];
//        data.id = @"00";
//        data.imgurl = @"00";
//        data.docurl = @"00";
//        data.has_content = NO;
//        data.time = @"00";
//        data.channelname = @"00";
//        data.title = @"00";
//        dataFrame.newsData = data;
//        [_totalArray addObject:dataFrame];
    }
    return _totalArray;
}

- (NSMutableArray *)war
{
    if (!_war) {
        _war = [[NSMutableArray alloc]init];
    }
    return _war;
}

- (NSMutableArray *)tech
{
    if (!_tech) {
        _tech = [[NSMutableArray alloc]init];
    }
    return _tech;
}

- (NSMutableArray *)ent
{
    if (!_ent) {
        _ent = [[NSMutableArray alloc]init];
    }
    return _ent;
}

- (NSMutableArray *)edu
{
    if (!_edu) {
        _edu= [[NSMutableArray alloc]init];
    }
    return _edu;
}

- (NSMutableArray *)sport
{
    if (!_sport) {
        _sport = [[NSMutableArray alloc]init];
    }
    return _sport;
}

- (NSMutableArray *)travel
{
    if (!_travel) {
        _travel= [[NSMutableArray alloc]init];
    }
    return _travel;
}

- (NSMutableArray *)lady
{
    if (!_lady) {
        _lady = [[NSMutableArray alloc]init];
    }
    return _lady;
}

- (NSMutableArray *)money
{
    if (!_money) {
        _money= [[NSMutableArray alloc]init];
    }
    return _money;
}

- (NSMutableArray *)gupiao
{
    if (!_gupiao) {
        _gupiao = [[NSMutableArray alloc]init];
    }
    return _gupiao;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (void)refresh:(id)sender
{
    [self.tableview reloadData];
    [(UIRefreshControl *)sender endRefreshing];
}

-(void)turnToChangeView{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    UINavigationController *nav = myDelegate.navController;
    changeViewController *changeController = [[changeViewController alloc]init];
    [nav pushViewController:changeController animated:YES ];
    
}

-(void)buttonAction:(UIButton*)sender{
    if([sender.titleLabel.text isEqualToString: @"军事"]){
        self.presentContent = @"war";
    }
    if([sender.titleLabel.text isEqualToString:  @"科技"]){
        self.presentContent = @"tech";
    }
    if([sender.titleLabel.text isEqualToString:  @"教育"]){
        self.presentContent = @"edu";
    }
    if([sender.titleLabel.text isEqualToString:  @"娱乐"]){
        self.presentContent = @"ent";
    }
    if([sender.titleLabel.text isEqualToString:  @"体育"]){
        self.presentContent = @"sport";
    }
    if([sender.titleLabel.text isEqualToString:  @"财经"]){
        self.presentContent = @"money";
    }
    if([sender.titleLabel.text isEqualToString:  @"股票"]){
        self.presentContent = @"gupiao";
    }
    if([sender.titleLabel.text isEqualToString:  @"旅游"]){
        self.presentContent = @"travel";
    }
    if([sender.titleLabel.text isEqualToString:  @"女性"]){
        self.presentContent = @"lady";
    }
    
    NSLog(@"reloadData");
        self.internetState = [ViewController isExistenceNetwork];
    if (self.internetState) {
        self.tableview.tableFooterView = self.tabelViewFooterView;
        self.page = @"1";
         [self.tableview reloadData];
        
        [self.totalArray removeAllObjects];
        [self.war removeObjectsInArray:[fmdbTool statusesWithParams:@"war"]];
        [self.tech removeObjectsInArray:[fmdbTool statusesWithParams:@"tech"]];
        [self.travel removeObjectsInArray:[fmdbTool statusesWithParams:@"travel"]];
        [self.edu removeObjectsInArray:[fmdbTool statusesWithParams:@"edu"]];
        [self.ent removeObjectsInArray:[fmdbTool statusesWithParams:@"ent"]];
        [self.money removeObjectsInArray:[fmdbTool statusesWithParams:@"money"]];
        [self.lady removeObjectsInArray:[fmdbTool statusesWithParams:@"lady"]];
        [self.sport removeObjectsInArray:[fmdbTool statusesWithParams:@"sport"]];
        [self.gupiao removeObjectsInArray:[fmdbTool statusesWithParams:@"gupiao"]];
       
        [self internetDownload];
       
    }
    
    NSArray* DbArray = [fmdbTool statusesWithParams:self.presentContent];
    NSInteger DbArraycount = DbArray.count;
    
    if(self.internetState ==NO && DbArraycount ==0  ){
        UIView *noInternetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height-300)];
        UILabel* noInternetLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-300, SCREEN_WIDTH, 70)];
        noInternetLabel.text = @"    咦，调皮的志浩干扰了您的互联网连接哦～";
        [noInternetLabel setFont:[UIFont systemFontOfSize:24]];
        self.tableview.tableFooterView = noInternetView;
        [noInternetView addSubview:noInternetLabel];
        [noInternetView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"志浩.jpg"]]];
        [self.totalArray removeAllObjects];
        [self.tableview reloadData];
    }

    if(self.internetState == NO && DbArraycount != 0){
        self.tableview.tableFooterView = self.tabelViewFooterView;       
        self.page = @"1";
        if([self.presentContent isEqualToString:@"war"]){
            self.temp = self.war;
        }
        if([self.presentContent isEqualToString:@"gupiao"]){
            self.temp = self.gupiao;
        }
        if([self.presentContent isEqualToString:@"ent"]){
            self.temp = self.ent;
        }
        if([self.presentContent isEqualToString:@"edu"]){
            self.temp = self.edu;
        }
        if([self.presentContent isEqualToString:@"lady"]){
            self.temp = self.lady;
        }
        if([self.presentContent isEqualToString:@"tech"]){
            self.temp = self.tech;
        }
        if([self.presentContent isEqualToString:@"travel"]){
            self.temp = self.travel;
        }
        if([self.presentContent isEqualToString:@"money"]){
            self.temp = self.money;
        }
        if([self.presentContent isEqualToString:@"sport"]){
            self.temp = self.sport;
        }
        
        int pageNamber = [self.page intValue];
        for(NSMutableDictionary *dictionary in DbArray)
        {
            newsData *data = [[newsData alloc] initWithDict:dictionary];
            
            newsFrame *dataFrame = [[newsFrame alloc]init];
            [dataFrame setNewsData:data];
            [self.temp addObject:dataFrame];
        }
        int i;
        NSMutableArray *array= [[NSMutableArray alloc]init];
        for(i=10*(pageNamber - 1);i<pageNamber * 10 ;i++){
            [array addObject:self.temp[i]];
        }
        //                    [self.temp subarrayWithRange:NSMakeRange(10*(pageNamber - 1), pageNamber * 10 -1 )];
        self.totalArray = [NSMutableArray arrayWithArray:array];
        [self.tableview reloadData];
        
        
    }

   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    webViewController *webController = [[webViewController alloc]init];
    UIWebView *web = [[UIWebView alloc]initWithFrame:webController.view.frame];
    newsFrame *frame= self.totalArray[indexPath.row];
    newsData *data =frame.newsData;
    NSURL *url = [NSURL URLWithString:data.docurl];//[self.totalArray[indexPath.row]objectForKey:@""]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    [webController.view addSubview:web];
    UINavigationController *nav = myDelegate.navController;
    [nav pushViewController:webController animated:YES ];
}

-(void)nextPage:(id)sender{
    self.internetState = [ViewController isExistenceNetwork];
    if (self.internetState) {
    int pagenamber = [self.page intValue];
    pagenamber++;
    self.page = [NSString stringWithFormat:@"%i",pagenamber];
    [self internetDownload];
    if(self.temp.count >= pagenamber * 10){
    int i;
    NSMutableArray *array= [[NSMutableArray alloc]init];
    for(i=10*(pagenamber - 1);i<pagenamber * 10 -1;i++){
        [array addObject:self.temp[i]];
    }
    //                    [self.temp subarrayWithRange:NSMakeRange(10*(pageNamber - 1), pageNamber * 10 -1 )];
    self.totalArray = [NSMutableArray arrayWithArray:array];
    }
    self.pages.text = self.page;
    //[self.tableview reloadData];
    [self.tableview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if(self.internetState == NO){
        UIView *noInternetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height-300)];
        UILabel* noInternetLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-300, SCREEN_WIDTH, 70)];
        noInternetLabel.text = @"    咦，调皮的志浩干扰了您的互联网连接哦～";
        [noInternetLabel setFont:[UIFont systemFontOfSize:24]];
        self.tableview.tableFooterView = noInternetView;
        [noInternetView addSubview:noInternetLabel];
        [noInternetView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"志浩.jpg"]]];
        [self.totalArray removeAllObjects];
        [self.tableview reloadData];
    }

}

-(void)previousPage:(id)sender{
    self.internetState = [ViewController isExistenceNetwork];
    if (self.internetState) {
    int pagenamber = [self.page intValue];
    if(![self.page isEqualToString:@"1"]){
    pagenamber--;
    self.page = [NSString stringWithFormat:@"%i",pagenamber];
    }
    int i;
    NSMutableArray *array= [[NSMutableArray alloc]init];
    for(i=10*(pagenamber - 1);i<pagenamber * 10 -1;i++){
        [array addObject:self.temp[i]];
    }
    //                    [self.temp subarrayWithRange:NSMakeRange(10*(pageNamber - 1), pageNamber * 10 -1 )];
    self.totalArray = [NSMutableArray arrayWithArray:array];
    self.pages.text = self.page;
    [self.tableview reloadData];
    [self.tableview setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if(self.internetState == NO){
        UIView *noInternetView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height-300)];
        UILabel* noInternetLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-300, SCREEN_WIDTH, 70)];
        noInternetLabel.text = @"    咦，调皮的志浩干扰了您的互联网连接哦～";
        [noInternetLabel setFont:[UIFont systemFontOfSize:24]];
        self.tableview.tableFooterView = noInternetView;
        [noInternetView addSubview:noInternetLabel];
        [noInternetView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"志浩.jpg"]]];
        [self.totalArray removeAllObjects];
        [self.tableview reloadData];
    }

}


-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    isSearch = NO;
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
    [self.tableview reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self filterBySubstring:searchBar.text];
    [self.searchBar resignFirstResponder];
    
}

-(void)filterBySubstring:(NSString*) subStr{
    isSearch = YES;
    NSInteger i;
//    NSMutableArray *data = [[NSMutableArray alloc]init];
    [self.dataArray removeAllObjects];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@",subStr];
    for (i=0; i<self.totalArray.count; i++) {
         newsFrame *frame = self.totalArray[i];
        if([pred evaluateWithObject:frame.newsData]){
            [self.dataArray addObject:frame];
        }
        
            
    }
   
//    NSArray *predata;
//    predata = [data filteredArrayUsingPredicate:pred];
//    for (i=0; i<self.totalArray.count; i++ ) {
//        newsFrame *frame = self.totalArray[i];
//        if ([predata[i] isEqualToString:frame.newsData.title]) {
//            [self.dataArray addObject:self.totalArray[i]];
//        }
//    }
    
    
    [self.tableview reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;       //显示“取消”按钮
    for(id cc in [self.searchBar subviews])
    {
        for (UIView *view in [cc subviews]) {
            if ([NSStringFromClass(view.class)                 isEqualToString:@"UINavigationButton"])
            {
                UIButton *btn = (UIButton *)view;
                [btn setTitle:@"cancel" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
    
}

-(void) save{
    NSMutableArray *newsDataArray = [[NSMutableArray alloc]init];
    NSInteger i;
    for( i=0 ; i < self.totalArray.count ; i++ ){
        newsFrame *tempFrame = self.totalArray[i];
        [newsDataArray addObject:tempFrame.newsData];
    }
    [fmdbTool saveStatuses:newsDataArray];
    NSArray *a = [fmdbTool statusesWithParams:self.presentContent];
    NSLog(@"%@数据库保存完成",a);

}

+ (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch([reachability currentReachabilityStatus]){
        case NotReachable: isExistenceNetwork = NO;
            break;
        case ReachableViaWWAN: isExistenceNetwork = YES;
            break;
        case ReachableViaWiFi: isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}

@end
