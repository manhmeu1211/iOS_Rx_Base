//
//  LoadMoreTableView.swift
//  BaseRxSwift
//
//  Created by Lương Mạnh on 14/03/2022.
//

import Foundation

class LoadMoreTableView: UITableView {
    
    // MARK: - Reload
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
    
    // MARK: - Load More
    private lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 60))
        let activityIndicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .medium)
        } else {
            activityIndicator = UIActivityIndicatorView(style: .gray)
        }
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        return view
    }()
    
    open var loadMoreTrigger: Driver<Void> {
        rx.reachedBottom(offset: 0.0).asDriver()
    }
    
    open var isLoadingMore: Binder<Bool> {
        return Binder(self) { tableView, loading in
            tableView.tableFooterView = loading ? tableView.footerView : nil
        }
    }
    
    // MARK: - Life cycle
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configViews()
    }
    
    // MARK: - Function
    private func configViews() {
        addRefreshControl()
    }
    
    open func addRefreshControl() {
        if #available(iOS 10.0, *) {
            self.refreshControl = _refreshControl
        } else {
            guard !self.subviews.contains(_refreshControl) else { return }
            self.addSubview(_refreshControl)
        }
    }

    open func removeRefreshControl() {
        if #available(iOS 10.0, *) {
            self.refreshControl = nil
        } else {
            _refreshControl.removeFromSuperview()
        }
    }
}
