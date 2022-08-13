//
//  CalculatorView.swift
//  CountOnMe
//
//  Created by Lorene Brocourt on 02/08/2022.
//  Copyright © 2022 Vincent Saluzzo. All rights reserved.
//

import Foundation
import UIKit

protocol CalculatorViewDelegate {
    func calculatorViewDelegateTappedAdditionButton()
    func calculatorViewDelegateTappedSubstractionButton()
    func calculatorViewDelegateTappedDivideButton()
    func calculatorViewDelegateTappedMultiplyButton()
    func calculatorViewDelegateTappedEqualButton()
    func calculatorViewDelegateTappedNumberButton(numberText: String?)
    func calculatorViewDelegateTappedClearButton()
}

class CalculatorView: UIView {
    var delegate: CalculatorViewDelegate?

    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!

    // View actions
    @IBAction func tappedClearButton(_ sender: UIButton) {
        delegate?.calculatorViewDelegateTappedClearButton()
    }
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        delegate?.calculatorViewDelegateTappedNumberButton(numberText: sender.title(for: .normal))
    }

    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        delegate?.calculatorViewDelegateTappedAdditionButton()
    }

    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        delegate?.calculatorViewDelegateTappedSubstractionButton()
    }

    @IBAction func tappedDivideButton(_ sender: UIButton) {
        delegate?.calculatorViewDelegateTappedDivideButton()
    }

    @IBAction func tappedMultiplyButton(_ sender: UIButton) {
        delegate?.calculatorViewDelegateTappedMultiplyButton()
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        delegate?.calculatorViewDelegateTappedEqualButton()
    }
}
