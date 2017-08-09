//
//  ViewController.m
//  LYLDragAndDropTableView
//
//  Created by 李灯涛 on 2017/7/28.
//  Copyright © 2017年 李灯涛. All rights reserved.
//

#import "ViewController.h"
#import "LYLDragAndDropTableView.h"
#import "LYLlistModel.h"
#import "LYLDataModel.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak) LYLDragAndDropTableView * tableView;

@property(nonatomic, strong) NSMutableArray * dataSource;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    for (int i = 0; i < 10; i++) {
        LYLlistModel *listModel = [LYLlistModel new];
        listModel.title = [NSString stringWithFormat:@"section%d", i + 1];
        
        NSMutableArray *tmpModels = [NSMutableArray array];
        
        for (int j = 0; j < 10; j++) {
            LYLDataModel *dataModel = [LYLDataModel new];
            dataModel.title = [NSString stringWithFormat:@"sourceSection:%d row%d", i + 1, j + 1];
            dataModel.message = [NSString stringWithFormat:@"msg%d", j + 1];
            
            [tmpModels addObject:dataModel];
            
        }
        
        listModel.dataModels = [NSMutableArray arrayWithArray:tmpModels];
        
        [self.dataSource addObject:listModel];
    }
    
    [self.view addSubview:self.tableView];
    
    [self.tableView setFrame:self.view.bounds];
}


#pragma mark --UITableViewDelegate,UITableViewDataSource方法--
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LYLlistModel *listModel = self.dataSource[section];
    
    return listModel.dataModels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"testCell"];
    }
        
    LYLlistModel *listModel = self.dataSource[indexPath.section];
    LYLDataModel * dataModel = listModel.dataModels[indexPath.row];
    
    [cell.textLabel setText:dataModel.title];
    [cell.detailTextLabel setText:dataModel.message];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    LYLlistModel *listModel = self.dataSource[section];
    return listModel.title;
}

#pragma mark --可拖拽设置--
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    LYLlistModel *sourceListModel = [self.dataSource objectAtIndex:sourceIndexPath.section];
    
    LYLDataModel *dataModel = sourceListModel.dataModels[sourceIndexPath.row];
    
    [sourceListModel.dataModels removeObjectAtIndex:sourceIndexPath.row];
    
    LYLlistModel *desListModel = [self.dataSource objectAtIndex:destinationIndexPath.section];
    
    [desListModel.dataModels insertObject:dataModel atIndex:destinationIndexPath.row];
}

#pragma mark --DragAndDropTableViewDataSource--

-(BOOL)canCreateNewSection:(NSInteger)section
{
    return NO;
}

#pragma mark DragAndDropTableViewDelegate

//开始拖拽的方法
-(void)tableView:(UITableView *)tableView willBeginDraggingCellAtIndexPath:(NSIndexPath *)indexPath placeholderImageView:(UIImageView *)placeHolderImageView
{
    // this is the place to edit the snapshot of the moving cell
    // add a shadow
    //被拖拽快照的透明度
    placeHolderImageView.layer.shadowOpacity = .8;
    placeHolderImageView.layer.shadowRadius = 10;
    
    
}

//移动完以后的调用方法
-(void)tableView:(LYLDragAndDropTableView *)tableView didEndDraggingCellAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)toIndexPath placeHolderView:(UIImageView *)placeholderImageView
{
    // The cell has been dropped. Remove all empty sections (if you want to)
    
}


-(CGFloat)tableView:tableView heightForEmptySection:(int)section
{
    return 0.0;
}

#pragma make --懒加载--

-(LYLDragAndDropTableView *)tableView
{
    if(_tableView == nil) {
        
        LYLDragAndDropTableView *tableView = [LYLDragAndDropTableView new];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setTableFooterView:[UIView new]];
        
        _tableView = tableView;
        
        return tableView;
        
    }
    
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if(_dataSource == nil) {
        
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}


@end
