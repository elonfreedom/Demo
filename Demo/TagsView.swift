import UIKit
import SnapKit
import JKSwiftExtension

class TagsView: UIView, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let scrollToEndButton = UIButton()

    var labelTitles: [String] = [] {
        didSet {
            updateView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
        setupStackView()
        setupScrollToEndButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScrollView()
        setupStackView()
        setupScrollToEndButton()
    }

    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // 设置 UIScrollView 的属性
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = true

        // 设置代理
        scrollView.delegate = self
    }

    private func setupStackView() {
        scrollView.addSubview(stackView)

        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview().priority(.low)
        }
    }

    private func setupScrollToEndButton() {
        // 添加滚动到底部的按钮
        addSubview(scrollToEndButton)
        scrollToEndButton.backgroundColor = .blue // 透明背景
        scrollToEndButton.addTarget(self, action: #selector(scrollToEnd), for: .touchUpInside)
        
        // 将按钮置于右侧
        scrollToEndButton.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(30) // 按钮宽度，可以根据需要调整
        }
    }

    @objc private func scrollToEnd() {
        let rightOffset = CGPoint(x: scrollView.contentSize.width - scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(rightOffset, animated: true)
    }

    private func createLabel(withTitle title: String) -> UIView {
        let label = InsetLabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.backgroundColor = UIColor(white: 0.9, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return label
    }

    private func updateView() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        labelTitles.forEach { title in
            let labelContainer = createLabel(withTitle: title)
            stackView.addArrangedSubview(labelContainer)
        }

        scrollView.layoutIfNeeded()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxOffset = scrollView.contentSize.width - scrollView.bounds.width
        scrollToEndButton.isHidden = scrollView.contentOffset.x >= maxOffset-30
    }
}
