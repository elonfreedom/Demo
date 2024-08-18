//
//  InsetLabel.swift
//  Demo
//
//  Created by elonfreedom on 2024/8/17.
//

import UIKit

class InsetLabel: UILabel {
    var insets: UIEdgeInsets = .zero {
        didSet {
            // 当 insets 变化时，重新布局
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + insets.left + insets.right, height: size.height + insets.top + insets.bottom)
    }
}


