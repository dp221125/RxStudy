//
//  ObservableViewController.swift
//  RxStudy
//
//  Created by Milkyo on 31/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class DownloadImageViewController: UIViewController {
    var downloadImagViewModel = DownloadImagViewModel()
    var disposeBag = DisposeBag()

    var downloadOwnView: DownloadImageView {
        return self.view as! DownloadImageView
    }

    override func loadView() {
        let view = DownloadImageView()
        self.view = view
    }

    override func viewDidLoad() {
        self.bind()
    }

    override func viewWillDisappear(_: Bool) {
        self.disposeBag = DisposeBag()
    }

    func bind() {
        self.downloadOwnView.downLoadbutton.rx.tap
            .do(onNext: self.downloadOwnView.downloadIndicator.startAnimating)
            .bind(onNext: self.downloadImagViewModel.downImage)
            .disposed(by: self.disposeBag)

        self.downloadOwnView.cancelButton.rx.tap
            .do(onNext: self.downloadOwnView.downloadIndicator.stopAnimating)
            .bind(onNext: self.cancelImageDown)
            .disposed(by: self.disposeBag)

        self.downloadImagViewModel.imagePubliser
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ -> Void in
                self?.downloadOwnView.downloadIndicator.stopAnimating()
            })
            .bind(to: self.downloadOwnView.imageView.rx.image)
            .disposed(by: self.disposeBag)
    }

    func cancelImageDown() {
        self.downloadImagViewModel.disposeBag = DisposeBag()
    }
}
