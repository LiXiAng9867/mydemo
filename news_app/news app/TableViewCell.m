//
//  TableViewCell.m
//  news app
//
//  Created by 李希昂 on 2017/5/22.
//  Copyright © 2017年 李希昂. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UIImageView *imageV = [[UIImageView alloc]init];
        [self.contentView addSubview:imageV];
        self.img = imageV;
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont fontWithName:@"Avenir" size:15];
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        self.title = titleLabel;
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.font = [UIFont fontWithName:@"Avenir" size:7];
        timeLabel.numberOfLines = 0;
        [self.contentView addSubview:timeLabel];
        self.time = timeLabel;
        
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}

-(void)setDataFrame:(newsFrame*)dataFrame
{
    _dataFrame = dataFrame;
    newsData *data = _dataFrame.newsData;
    
    //图片
//    [self.img sd_setImageWithURL:[NSURL URLWithString:data.picUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    self.imgDict = myDelegate.imgDict;
    self.operations = myDelegate.operations;
    self.queue = myDelegate.queue;
   
    UIImage *image = [self.imgDict objectForKey:self.dataFrame.newsData.imgurl];
    if (image) {
            self.img.image = image;//return image;
    
}
        else{
            NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingString:[self.dataFrame.newsData.imgurl lastPathComponent ]];
    
            NSData* ImgaeData = [NSData dataWithContentsOfFile:filePath];
            if (ImgaeData) {
                UIImage *img = [UIImage imageWithData:ImgaeData];
                self.img.image = img;//return img;
            }
        else{
                //self.img.image = [[UIImage alloc]init];//[UIImage imageNamed:@"placeholder.png"];
                self.img.image = [UIImage imageNamed:@"添加.png"];
                NSBlockOperation* operation = self.operations[self.dataFrame.newsData.imgurl];
            
            if (nil == operation) {
                    NSBlockOperation* operation = [NSBlockOperation blockOperationWithBlock:^{
                    NSURL* url = [NSURL URLWithString:self.dataFrame.newsData.imgurl];
                    NSData* data =  [NSData dataWithContentsOfURL:url];
                    UIImage* image = [UIImage imageWithData:data];
        
                if (image) {
                       NSData* ImageData = UIImagePNGRepresentation(image);
            
                       [ImageData writeToFile: [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[self.dataFrame.newsData.imgurl  lastPathComponent]] atomically:YES];
        }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSString *filePath =  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[self.dataFrame.newsData.imgurl lastPathComponent]];
            [self.imgDict setValue:filePath forKey:self.dataFrame.newsData.id];
            [self.operations removeObjectForKey:self.dataFrame.newsData.imgurl ];
            
                 if(image){
                    [self.imgDict setObject:image forKey:self.dataFrame.newsData.imgurl];
            }
            
            NSData *imgData = [NSData dataWithContentsOfFile:filePath];
            UIImage *tempImage = [UIImage imageWithData:imgData];
            self.img.image = tempImage;
            }];
                    }];
            
    [self.queue addOperation:operation];
    
    self.operations[self.dataFrame.newsData.imgurl] = operation;
}
    }
        }

    
    self.img.frame = CGRectMake(160, 25, 200, 100);//_dataFrame.picUrlF;

    //title
    self.title.text = data.title;
    self.title.frame = CGRectMake(25, 25, 100, 100);//_dataFrame.titleF;

    self.time.text = data.time;
    self.time.frame = CGRectMake(25, 125, 100, 20);

// CGSize textMaxSize = CGSizeMake(200, MAXFLOAT);
//  CGSize textRealSize = [self.title.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:textMaxSize].size;
    
    
    
    
}


#pragma mark 重画tableview的线

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
    
}


@end
