//
// Created by Karl Söderberg on 2018-03-19.
// Copyright (c) 2018 LemonandLime. All rights reserved.
//

import Foundation
import UIKit

class LocationDetailsView: UIStackView {
    @IBOutlet private var fromRow: LocationDetailsRow!
    @IBOutlet private var toRow: LocationDetailsRow!
    @IBOutlet private var departureRow: LocationTimeRow!

    func setFrom(title: String?) {
        fromRow.setTitle(title: title)
        setDepartureTime(time: nil)
    }

    func setTo(title: String?) {
        toRow.setTitle(title: title)
        setDepartureTime(time: nil)
    }

    func setDepartureTime(time: Date?) {
        departureRow.setTime(time: time)
    }
}

class LocationDetailsRow: UIView {

    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var activeIndicator: UIView?

    var isActive: Bool = false {
        didSet {
            setActive(active: isActive)
        }
    }

    func setTitle(title: String?) {
        locationLabel.text = title
        animate(hidden: title == nil)
    }


    private func setActive(active: Bool) {
        activeIndicator?.isHidden = !active
    }

    private func animate(hidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.isHidden = hidden
        }
    }
}

class LocationTimeRow: UIView {
    @IBOutlet private var timeLabel: UILabel!

    func setTime(time: Date?) {
        if let time = time {
            var formatter = DateFormatter()
            formatter.dateStyle = .none
            formatter.timeStyle = .medium
            timeLabel.text = formatter.string(from: time)
            animate(hidden: false)
        } else {
            animate(hidden: true)
        }
    }

    private func animate(hidden: Bool) {
        self.isHidden = hidden

        UIView.animate(withDuration: 0.3) {
            self.isHidden = hidden
        }
    }
}