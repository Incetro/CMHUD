//
//  ViewController.swift
//  Example
//
//  Created by incetro on 5/21/21.
//

import UIKit
import Toast
import CMHUD
import Layout
import Lottie
import AloeStackView
import HapticFeedback

// MARK: - ViewController

final class ViewController: UIViewController {

    // MARK: - Properties

    /// Progress indicator timer
    private var progressTimer: Timer?

    /// HapticFeedback instance
    private let hapticFeedback = HapticFeedback()

    /// AloeStackView instance
    private let stackView = AloeStackView()

    /// HUD appearance instance
    private let hudAppearance = CMHUDAppearance(
        backgroundColor: UIColor(hexString: "9ba4b4").withAlphaComponent(0.38),
        centralViewBackgroundColor: UIColor(hexString: "394867"),
        centralViewContentColor: UIColor(hexString: "f1f6f9")
    )

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 243.0 / 255.0, alpha: 1)
        view.addSubview(stackView.prepareForAutolayout())
        stackView
            .pinToSuperview(withSides: .left, .right)
            .bottom(to: view.bottom)
            .top(to: safeTop)
        stackView.separatorColor = .clear
        stackView.backgroundColor = .clear
        setupContent()
    }

    // MARK: - Private

    private func setupContent() {

        addSection(named: "Success")
        addRow("Basic success", cornersType: .first) {
            CMHUD.success(in: self.view)
        }
        addRow("Success that will disappear after 4 seconds", cornersType: .regular) {
            CMHUD.success(in: self.view, hideAfter: 4)
        }
        addRow("Success with custom appearance", cornersType: .last) {
            CMHUD.success(in: self.view, withAppearance: self.hudAppearance)
        }

        addSection(named: "Error")
        addRow("Basic error", cornersType: .first) {
            CMHUD.error(in: self.view)
        }
        addRow("Error with that will disappear after 4 seconds", cornersType: .regular) {
            CMHUD.error(in: self.view, hideAfter: 4)
        }
        addRow("Error with custom appearance", cornersType: .last) {
            CMHUD.error(in: self.view, withAppearance: self.hudAppearance)
        }

        addSection(named: "Loading")
        addRow("Activity indicator", cornersType: .first) {
            CMHUD.loading(in: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                CMHUD.hide(from: self.view)
            }
        }
        addRow("Activity indicator with custom appearance", cornersType: .regular) {
            CMHUD.loading(in: self.view, withAppearance: self.hudAppearance)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                CMHUD.hide(from: self.view)
            }
        }
        addRow("Animation", cornersType: .last) {
            let animationView = AnimationView()
            animationView.prepareForAutolayout().size(40)
            animationView.loopMode = .loop
            animationView.animation = Animation.named("r-loader")
            CMHUD.loading(
                contentView: animationView,
                in: self.view
            )
            animationView.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                CMHUD.hide(from: self.view)
            }
        }

        addSection(named: "Progress")
        addRow("Pie-chart style", cornersType: .first) {
            self.startProgressTimer {
                CMHUD.progress($0, in: self.view)
            }
        }
        addRow("Pie-chart style with custom appearance", cornersType: .regular) {
            self.startProgressTimer {
                CMHUD.progress(
                    $0,
                    in: self.view,
                    withAppearance: self.hudAppearance
                )
            }
        }
        addRow("Progress animation", cornersType: .last) {
            let animationView = AnimationView()
            animationView.prepareForAutolayout().size(40)
            animationView.loopMode = .playOnce
            animationView.animation = Animation.named("r-loader")
            CMHUD.loading(
                contentView: animationView,
                in: self.view
            )
            animationView.play()
            self.startProgressTimer {
                CMHUD.progress(
                    $0,
                    with: animationView,
                    in: self.view,
                    withAppearance: self.hudAppearance
                )
            }
        }
    }

    private func addSection(named name: String) {
        let sectionTitleLabel = UILabel()
        sectionTitleLabel.text = name.uppercased()
        sectionTitleLabel.font = UIFont(name: "Avenir-Book", size: 13)
        sectionTitleLabel.textColor = .lightGray
        stackView.addRow(sectionTitleLabel)
        stackView.setInset(forRow: sectionTitleLabel, inset: Constants.sectionInsets)
    }

    private func addRow(
        _ title: String,
        cornersType: UIView.SmoothCornerType,
        action: @escaping () -> ()
    ) {
        let inset: UIEdgeInsets
        switch cornersType {
        case .first:
            inset = UIEdgeInsets(top: 8, left: 13, bottom: 1, right: 13)
        case .last:
            inset = UIEdgeInsets(top: 1, left: 13, bottom: 8, right: 13)
        default:
            inset = UIEdgeInsets(top: 1, left: 13, bottom: 1, right: 13)
        }
        let row = ExampleStackViewCell(title: title)
        row.cornersType = cornersType
        stackView.addRow(row.prepareForAutolayout().height(52))
        stackView.setInset(forRow: row, inset: inset)
        stackView.setTapHandler(forRow: row) { _ in
            row.highlight()
            action()
        }
    }

    private func startProgressTimer(_ progressBlock: @escaping (Double) -> Void) {
        cancelTimer()
        var progress = 0.0
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            progress += 0.005
            progressBlock(progress)
            if progress >= 1 {
                self?.cancelTimer()
            }
        }
    }

    private func cancelTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
    }
}

// MARK: - ExampleStackViewCell

final class ExampleStackViewCell: UIView {

    // MARK: - Properties

    var isHighlighted: Bool = false {
        didSet {
            titleLabel.alpha = isHighlighted ? 0.38 : 1
        }
    }

    /// Main text label
    private let titleLabel = UILabel()

    /// Disclosure indicator view
    private let disclosureIndicatorImageView = UIImageView()

    /// Current corners type
    var cornersType: SmoothCornerType = .regular {
        didSet {
            smoothlyRoundCourners(cornersType, radius: Constants.cornerRadius)
        }
    }

    // MARK: - Initializers

    /// Default initializer
    /// - Parameters:
    ///   - title: main text
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.textColor = .black
        titleLabel.text = title
        setupTitleLabel()
        setupDisclosureIndicator()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func highlight(timeInterval: TimeInterval = 0.25) {
        isHighlighted = true
        UIView.animate(
            withDuration: timeInterval,
            delay: 0.25,
            options: .curveLinear
        ) { self.isHighlighted = false }
    }

    func updateConers(_ cornerRadiusType: SmoothCornerType) {
        self.cornersType = cornerRadiusType
    }
}

// MARK: - Layout

extension ExampleStackViewCell {

    private func setupTitleLabel() {
        let inset = Constants.contentInsets
        addSubview(titleLabel.prepareForAutolayout())
        titleLabel
            .centerY(to: centerY)
            .left(to: left + inset.left)
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 15)
    }

    private func setupDisclosureIndicator() {
        let inset = Constants.contentInsets
        addSubview(disclosureIndicatorImageView.prepareForAutolayout())
        disclosureIndicatorImageView
            .centerY(to: centerY)
            .right(to: right - inset.left)
            .left(to: titleLabel.right - inset.left)
            .size(Constants.disclosureIndicatorSize)
    }
}

// MARK: - Constants

enum Constants {
    static let sectionInsets = UIEdgeInsets(top: 16, left: 24, bottom: 1, right: 16)
    static let contentInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    static let imageViewSize = CGSize(width: 24, height: 24)
    static let spacing: CGFloat = 8
    static let cornerRadius: CGFloat = 13
    static let disclosureIndicatorSize = CGSize(width: 7, height: 11)
}

// MARK: - Progressable

extension AnimationView: Progressable {

    public func updateProgress(_ progress: Double) {
        currentProgress = AnimationProgressTime(progress)
    }
}
