//
//  YKSectionTableView.swift
//  YKSwiftSectionViewModel
//
//  Created by edward on 2022/1/22.
//

import UIKit

public class YKSectionTableView: UITableView {
    
    private lazy var loading:Bool = false
    private var objcs:[String] = []
    
    private lazy var _nodataView:YKSectionNoDataView = {
        let view = YKSectionNoDataView.init(frame: self.bounds)
        view.isHidden = true
        view.reloadCallBack = { [weak self] in
            guard let weakself = self else { return }
            weakself.refreshData(mode: .Header)
        }
        return view
    }()
    
    private lazy var datas:[YKSectionTableViewProtocol] = []
    
    public var outTime:Double = 15
    
    private var errorCallBack:((_ error:Error) -> Void)?
    
    private var handleViewController:((_ controller:UIViewController, _ type:YKSectionViewModelPushType, _ animated:Bool) -> Void)?
    
    private var endRefresh:((_ isNoMoreData:Bool) -> Void)?
    
    private var loadingCallBack:((_ isLoading:Bool) -> Void)?
    
    private var isNoMoreData:Bool = false
    
    private var afterReloadData:Bool = false
    
    public init(frame:CGRect, datas:[YKSectionTableViewProtocol], style:UITableView.Style = .plain) {
        super.init(frame: frame, style: style)
        self.datas = datas
        self.setupUI()
        self.bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - reloadData
    public override func reloadData() {
        
        super.reloadData()
        
        
        var haveData = false
        for vm in self.datas {
            haveData = haveData || (vm.yksc_numberOfItem() > 0)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let weakself = self else { return }
            weakself.endRefresh?(weakself.isNoMoreData)
        }
        self._nodataView.isHidden = !(self.afterReloadData && !haveData)
        
    }
    

}

//MARK: - publich func
public extension YKSectionTableView {
    
    func resetViewModels(datas:[YKSectionTableViewProtocol]) -> Void {
        self.datas = datas
        self.initData()
        self.reloadData()
    }
    
    func refreshData(mode:YKSectionViewModelRefreshMode) -> Void {
        
        if self.loading {
            //已经加载中
            return
        }else {
            //开始加载
            self.loading = true
            self.isNoMoreData = false
            self.afterReloadData = false
            self.loadingCallBack?(true)
            self.startTimer()
        }
        if self.datas.count <= 0 {
            self.loading = false
            self.afterReloadData = true
            self.isNoMoreData = false
            self.loadingCallBack?(false)
            self.stopTimer()
            self.reloadData()
            return
        }
        
        var refreshList:[YKSectionTableViewProtocol] = []
        
        for data in self.datas {
            if mode == .Footer {
                
                if let beIn = data.yksc_isRefreshFooter?()
                {
                    if beIn {
                        refreshList.append(data)
                    }else {
                        continue
                    }
                }else {
                    refreshList.append(data)
                }
                
            }else {
                refreshList.append(data)
            }
        }
        
        let reloadBlock = { [weak self] (obj:YKSectionTableViewProtocol, isNoMoreData:Bool) in
            guard let weakself = self else { return }
            let objcName = "d\(Unmanaged.passUnretained(obj).toOpaque())"
            
            weakself.isNoMoreData = weakself.isNoMoreData && isNoMoreData
            if weakself.objcs.count > 0 {
                weakself.objcs.remove(at: weakself.objcs.firstIndex(of: objcName)!)
            }
            if weakself.objcs.count <= 0 {
                weakself.afterReloadData = true
                if weakself.loading {
                    weakself.loading = false
                    weakself.loadingCallBack?(false)
                    weakself.stopTimer()
                    weakself.reloadData()
                }else {
                    weakself.reloadData()
                }
            }
        }
        for obj in refreshList {
            let objcName = "d\(Unmanaged.passUnretained(obj).toOpaque())"
            self.objcs.append(objcName)
            
        }
        
        for obj in refreshList {
            obj.yksc_beginToReloadData(mode: mode) { isNoMoreData in
                reloadBlock(obj,isNoMoreData)
            } errorCallBack: { [weak self] error in
                guard let weakself = self else { return }
                weakself.errorCallBack?(error)
            }


        }
    }
    
    func setNoDataViewTip(tip:String, font:UIFont) -> Void {
        self._nodataView.tipLabel.text = tip
        self._nodataView.tipLabel.font = font
    }
    
    func setNoDataViewImage(image:UIImage?) -> Void {
        self._nodataView.tipImageView.image = image
    }
    
    func toSetErrorCallBack(errorCallBack:@escaping (_ error:Error) -> Void) {
        if self.errorCallBack == nil {
            self.errorCallBack = errorCallBack
        }else {
            #if DEBUG
            print("❌ errorCallBack已设置，请勿重新设置")
            #endif
        }
    }
    
    func toSetHandleViewController(handleViewController:@escaping ((_ controller:UIViewController, _ type:YKSectionViewModelPushType, _ animated:Bool) -> Void)) {
        if self.handleViewController == nil {
            self.handleViewController = handleViewController
        }else {
            #if DEBUG
            print("❌ handleViewController已设置，请勿重新设置")
            #endif
        }
    }
    
    func toSetEndRefresh(endRefresh:@escaping ((_ isNoMoreData:Bool) -> Void)) {
        if self.endRefresh == nil {
            self.endRefresh = endRefresh
        }else {
            #if DEBUG
            print("❌ endRefresh已设置，请勿重新设置")
            #endif
        }
    }
    
    func toSetLoadingCallBack(loadingCallBack:@escaping ((_ isLoading:Bool) -> Void)) {
        if self.loadingCallBack == nil {
            self.loadingCallBack = loadingCallBack
        }else {
            #if DEBUG
            print("❌ loadingCallBack已设置，请勿重新设置")
            #endif
        }
    }
    
    func handleRouter(eventName:String, userInfo:Dictionary<String,Any>) -> Bool {
        var result = false
        for obj in self.datas {
            if let resultP = obj.yksc_handleRouterEvent?(eventName: eventName, userInfo: userInfo, contentView: self, callBack: self.handleViewController ?? { _,_,_ in
                
            }) {
                result = (result || resultP)
            }
        }
        return result
    }
}


//MARK: - delegate
extension YKSectionTableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.datas[indexPath.section]
        obj.yksc_didSelectItem?(at: indexPath, contentView: self, callBack: { [weak self] viewcontroller, type, animate in
            guard let weakSelf = self else { return }
            weakSelf.handleViewController?(viewcontroller,type,animate)
        })
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let obj = self.datas[indexPath.section]
        return obj.yksc_heightOfRow(at: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let obj = self.datas[indexPath.section]
        return obj.yksc_estimatedHeightOfRow?(at: indexPath.row) ?? 0.01
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let obj = self.datas[section]
        let isShowHeaderFooter:Bool = obj.yksc_noDataShowHeaderFooter?() ?? true
        let num = obj.yksc_numberOfItem()
        if (num > 0 || isShowHeaderFooter)  {
            if let headerId = obj.yksc_idForHeader?() {
                if headerId.count > 0 {
                    guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) else { return nil }
                    
                    if let yk_headerView = headerView as? YKSectionTableViewHeaderFooterView {
                        
                        yk_headerView.toSetClickEvent { [weak self] eventName, userInfo in
                            guard let weakself = self else { return }
                            let model = weakself.datas[section]
                            let _ = model.yksc_handleRouterEvent?(eventName: eventName, userInfo: userInfo ?? [:], contentView: weakself, callBack: weakself.handleViewController ?? { _,_,_ in
                                
                            })
                        }
                    }
                    
                    if let headerViewP = headerView as? YKSectionViewModelResuseProtocol {
                        headerViewP.loadDataWithIndexPath?(obj, at: IndexPath.init(row: 0, section: section))
                    }else {
                        #if DEBUG
                        print("❌ \(headerView)未继承'YKSectionViewModelResuseProtocol'协议")
                        #endif
                    }
                    return headerView
                }
            }
        }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "YKSectionTableViewHeaderFooterView")
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let obj = self.datas[section]
        return obj.yksc_estimatedHeightOfHeader?() ?? 0.00001
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let obj = self.datas[section]
        
        let num = obj.yksc_numberOfItem()
        let isShowHeaderFooter = obj.yksc_noDataShowHeaderFooter?() ?? false
        
        if num > 0 || isShowHeaderFooter {
            return obj.yksc_heightOfHeader?() ?? 0.00001
        }
        return 0.00001
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let obj = self.datas[section]
        let isShowHeaderFooter:Bool = obj.yksc_noDataShowHeaderFooter?() ?? true
        let num = obj.yksc_numberOfItem()
        if (num > 0 || isShowHeaderFooter)  {
            if let footerId = obj.yksc_idForFooter?() {
                if footerId.count > 0 {
                    
                    guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: footerId) else { return nil }
                    
                    if let yk_footerView = footerView as? YKSectionTableViewHeaderFooterView {
                        yk_footerView.toSetClickEvent { [weak self] eventName, userInfo in
                            guard let weakself = self else { return }
                            let model = weakself.datas[section]
                            let _ = model.yksc_handleRouterEvent?(eventName: eventName, userInfo: userInfo ?? [:], contentView: weakself, callBack: weakself.handleViewController ?? { _,_,_ in
                                
                            })
                        }
                    }
                    
                    if let footerViewP = footerView as? YKSectionViewModelResuseProtocol {
                        footerViewP.loadDataWithIndexPath?(obj, at: IndexPath.init(row: 0, section: section))
                    }else {
                        #if DEBUG
                        print("❌ \(footerView)未继承'YKSectionViewModelResuseProtocol'协议")
                        #endif
                    }
                    
                    return footerView
                }
            }
        }
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "YKSectionTableViewHeaderFooterView")
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        let obj = self.datas[section]
        return obj.yksc_estimatedHeightOfFooter?() ?? 0.00001
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        
        let obj = self.datas[section]
        
        let num = obj.yksc_numberOfItem()
        let isShowHeaderFooter = obj.yksc_noDataShowHeaderFooter?() ?? false
        
        if num > 0 || isShowHeaderFooter {
            return obj.yksc_heightOfFooter?() ?? 0.00001
        }
        return 0.00001
    }
    
    
    
}

//MARK: - dataSource
extension YKSectionTableView: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.datas.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let obj = self.datas[section]
        return obj.yksc_numberOfItem()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let obj = self.datas[indexPath.section]
        let Id = obj.yksc_idForItem(at: indexPath)
        if let myCell = tableView.dequeueReusableCell(withIdentifier: Id) {
            
            if let yk_tableViewCell = myCell as? YKSectionTableViewCell {
                yk_tableViewCell.toSetClickEvent { [weak self] eventName, userInfo in
                    guard let weakself = self else { return }
                    let model = weakself.datas[indexPath.section]
                    let _ = model.yksc_handleRouterEvent?(eventName: eventName, userInfo: userInfo ?? [:], contentView: weakself, callBack: weakself.handleViewController ?? { _,_,_ in
                        
                    })
                }
            }
            
            if let cellP = myCell as? YKSectionViewModelResuseProtocol {
                cellP.loadDataWithIndexPath?(obj, at: indexPath)
            }else {
                #if DEBUG
                print("❌ \(myCell)未继承'YKSectionViewModelResuseProtocol'协议")
                #endif
            }
            return myCell
        }else {
            return tableView.dequeueReusableCell(withIdentifier: "YKSectionTableViewCell") ?? YKSectionTableViewCell.init(style: .default, reuseIdentifier: "YKSectionTableViewCell")
        }
    }
    
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let obj = self.datas[indexPath.section]
        return obj.yksc_canEdit?(at: indexPath.row) ?? false
    }
    
    
}

//MARK: - private func
extension YKSectionTableView {
    
    private func setupUI() -> Void {
        self.isNoMoreData = false
        self.delegate = self
        self.dataSource = self
        self.alwaysBounceVertical = true
        self.alwaysBounceHorizontal = false
        self.backgroundColor = .clear
        self.separatorStyle = .none
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
        self.addNoDateView()
        self.initData()
        self.register(YKSectionTableViewCell.classForCoder(), forCellReuseIdentifier: "YKSectionTableViewCell")
        self.register(YKSectionTableViewHeaderFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: "YKSectionTableViewHeaderFooterView")
        self.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        self.register(UITableViewHeaderFooterView.classForCoder(), forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
        
    }
    
    private func bindData() -> Void {
        //不再初始化的时候进行刷新数据
    }
    
    private func initData() -> Void {
        for obj in self.datas {
            let models = obj.yksc_registItems()
            for model in models {
                self.register(model.className, forCellReuseIdentifier: model.classId)
            }
            
            if let headerModel = obj.yksc_registHeader?() {
                for model in headerModel {
                    self.register(model.className, forHeaderFooterViewReuseIdentifier: model.classId)
                }
            }
            
            if let footerModel = obj.yksc_registFooter?() {
                for model in footerModel {
                    self.register(model.className, forHeaderFooterViewReuseIdentifier: model.classId)
                }
            }
        }
    }
    
    private func startTimer() -> Void {
        self.perform(#selector(outTimeTodo), with: nil, afterDelay: self.outTime)
    }
    
    private func stopTimer() -> Void {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.outTimeTodo), object: nil)
    }
    
    @objc private func outTimeTodo() -> Void {
        self.loading = false
        self.loadingCallBack?(false)
        self.objcs.removeAll()
        self.reloadData()
        self.errorCallBack?(self.createError(errorMsg: "加载超时"))
    }
    
    private func addNoDateView() ->Void {
        self.addSubview(self._nodataView)
    }
    
    private func createError(errorMsg:String) ->NSError {
        let error = NSError.init(domain: "YKSwiftSectionViewModel", code: -1, userInfo: [
            NSLocalizedDescriptionKey:errorMsg,
            NSLocalizedFailureReasonErrorKey:errorMsg,
            NSLocalizedRecoverySuggestionErrorKey:"请检查内容",
        ])
        return error
    }
}
