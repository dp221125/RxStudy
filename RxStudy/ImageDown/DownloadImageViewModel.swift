//
//  DownloadImageViewModel.swift
//  RxStudy
//
//  Created by Milkyo on 31/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import Foundation
import RxSwift

class DownloadImagViewModel {
    var disposeBag = DisposeBag()
    var imagePubliser = PublishSubject<UIImage>()

    func downImage() {
        Observable.just("1920x1080")
            .map { $0.replacingOccurrences(of: "x", with: "/") }
            .map { "https://picsum.photos/\($0)/?random" }
            .map { URL(string: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .map { try Data(contentsOf: $0) }
            .map { UIImage(data: $0) }
            .filter { $0 != nil }
            .map { $0! }
            .bind(onNext: self.imagePubliser.onNext)
            .disposed(by: self.disposeBag)
    }

    deinit {
        self.disposeBag = DisposeBag()
    }
}
