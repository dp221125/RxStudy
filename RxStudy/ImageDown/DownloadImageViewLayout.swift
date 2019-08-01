//
//  ImageDownView.swift
//  RxStudy
//
//  Created by Milkyo on 31/07/2019.
//  Copyright © 2019 MilKyo. All rights reserved.
//

import UIKit

class DownloadImageViewLayout: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    let downloadIndicator: UIActivityIndicatorView = {
        let downloadIndicator = UIActivityIndicatorView()
        downloadIndicator.hidesWhenStopped = true
        downloadIndicator.color = .white
        downloadIndicator.backgroundColor = UIColor(white: 0.3, alpha: 0.8)
        downloadIndicator.layer.cornerRadius = 10
        downloadIndicator.clipsToBounds = true
        return downloadIndicator
    }()

    let downLoadbutton: UIButton = {
        UIButton()
    }()

    let cancelButton: UIButton = {
        UIButton()
    }()

    let buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.axis = NSLayoutConstraint.Axis.horizontal
        buttonStackView.distribution = UIStackView.Distribution.fillEqually
        return buttonStackView
    }()

    func makeImageViewConstraint() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    func makeButtonStackViewConsraint() {
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
            buttonStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonStackView.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    func makeDownloadIndicatorConstraint() {
        self.downloadIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            downloadIndicator.widthAnchor.constraint(equalToConstant: 60),
            downloadIndicator.heightAnchor.constraint(equalTo: downloadIndicator.widthAnchor),
            downloadIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            downloadIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }

    func makeDefaultButton(_ targetButton: UIButton, buttonTitle: String) {
        targetButton.setTitle(buttonTitle, for: .normal)
        targetButton.setTitleColor(.black, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        makeSubViews()
        mkaeSubViewConstraint()
        makeStackViewItem()

        self.makeDefaultButton(self.downLoadbutton, buttonTitle: "Download")
        self.makeDefaultButton(self.cancelButton, buttonTitle: "Cancel")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension DownloadImageViewLayout: ViewItemProtocl {
    func makeSubViews() {
        addSubview(self.imageView)
        addSubview(self.buttonStackView)
        addSubview(self.downloadIndicator)
    }

    func mkaeSubViewConstraint() {
        self.makeImageViewConstraint()
        self.makeButtonStackViewConsraint()
        self.makeDownloadIndicatorConstraint()
    }
}

extension DownloadImageViewLayout: StackViewItemProtocol {
    func makeStackViewItem() {
        self.buttonStackView.addArrangedSubview(self.downLoadbutton)
        self.buttonStackView.addArrangedSubview(self.cancelButton)
    }
}
