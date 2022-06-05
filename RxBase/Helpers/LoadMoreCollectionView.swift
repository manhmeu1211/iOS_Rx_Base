//
//  LoadMoreCollectionView.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import UIKit

final class LoadMoreCollectionView: UICollectionView {
    
    private let _refreshControl = UIRefreshControl()
    
    var refreshTrigger: Driver<Void> {
        return _refreshControl.rx.controlEvent(.valueChanged).asDriver()
    }
    
    var isRefreshing: Binder<Bool> {
        return Binder(self) { tableView, loading in
            if loading {
                tableView._refreshControl.beginRefreshing()
            } else {
                if tableView._refreshControl.isRefreshing {
                    tableView._refreshControl.endRefreshing()
                }
            }
        }
    }
    
    var loadMoreTrigger: Driver<Void> {
        rx.reachedRight().asDriver()
    }
    
    var loadMoreBottomTrigger: Driver<Void> {
        rx.reachedBottom().asDriver()
    }
}
