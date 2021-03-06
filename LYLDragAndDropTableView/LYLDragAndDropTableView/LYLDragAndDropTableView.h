//
//  LYLDragAndDropTableView.h
//  LYLDragAndDropTableView
//
//  Created by 李灯涛 on 28/7/17.
//   Copyright © 2017年 李灯涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@class ProxyDataSource;
@class ProxyDelegate;
@class LYLDragAndDropTableView;

@protocol LYLDragAndDropTableViewDataSource <NSObject>
@optional
/**
 Asks the datasource if new sections can be created by dragging the cell outside of the table view. At the moment there is only support for appending new sections to the end of the table. If the method is not implemented the table view will assume that no new sections should be created.
 
 @param section The section index which will be created if YES is returned.
 */
-(BOOL)canCreateNewSection:(NSInteger)section;

/**
 Asks the datasource if cells should be animated from their old position after they are dragged. Default is YES.
 
 @param tableView The table view providing this information.
 */
-(BOOL)tableViewShouldAnimateDraggedCells:(LYLDragAndDropTableView *)tableView;
@end

@protocol LYLDragAndDropTableViewDelegate <NSObject>
@optional
/** 
 Tells the delegate that the table view cell is about to be moved. The cell is actually hidden and instead a snapshot of the cell is moved which is provided by the placeholderImageView.
 
 @param tableView The table view providing this information.
 @param indexPath The indexpath of the cell which is about to be moved.
 @param placeHolderImageView The snapshot of the cell.
*/
-(void)tableView:(LYLDragAndDropTableView *)tableView willBeginDraggingCellAtIndexPath:(NSIndexPath *)indexPath placeholderImageView:(UIImageView *)placeHolderImageView;
/**
 Tells the delegate that the dragged table view cell has been dropped.
 
 @param tableView The table view providing this information.
 @param sourceIndexPath The initial indexpath of the cell.
 @param toIndexPath The destination indexpath where the cell was dropped.
 @param placeholderImageView The snapshot of the cell.
*/
-(void)tableView:(LYLDragAndDropTableView *)tableView didEndDraggingCellAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)toIndexPath placeHolderView:(UIImageView *)placeholderImageView;

/**
 Tells the delegate that the dragged table view cell has been dropped. 
 @deprecated This method is deprecated, please use tableView:didEndDraggingCellAtIndexPath:toIndexPath:placeHolderView:
 
 @param tableView The table view providing this information.
 @param toIndexPath The new indexpath where the cell was dropped.
 @param placeholderImageView The snapshot of the cell.
 */
-(void)tableView:(LYLDragAndDropTableView *)tableView didEndDraggingCellToIndexPath:(NSIndexPath *)toIndexPath placeHolderView:(UIImageView *)placeholderImageView __deprecated;

/**
 Asks the delegate for the height of the distance between the header view and footer view of an empty section.
 
 @param tableView The table view requesting this information.
 @param section The location of the section
*/
-(CGFloat)tableView:(LYLDragAndDropTableView *)tableView heightForEmptySection:(NSInteger)section;
@end

@interface LYLDragAndDropTableView : UITableView<UITableViewDataSource>
{
    UIGestureRecognizer *_dndLongPressGestureRecognizer;
    
    NSIndexPath *_movingIndexPath;
    NSIndexPath *_originIndexPath;
    UIImageView *_cellSnapShotImageView;
    UIImageView *_tableViewSnapShotImageView;
    Method _originalSwizzledMethod;
    
    CGPoint _touchOffset;
    BOOL _lastIndexPathValid;
    NSIndexPath *_tempNewSectionIndexPath;
    
    ProxyDataSource *_proxyDataSource;
    ProxyDelegate *_proxyDelegate;
    
    CGFloat _autoscrollDistance;
    NSTimer *_autoscrollTimer;
    CGPoint _latestTouchPoint;
    
    NSMutableArray *_pendingInserts;
    NSMutableArray *_pendingDeletes;
    BOOL _isMoving;
}

@end
