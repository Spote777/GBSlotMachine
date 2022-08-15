//
//  SlotMachineViewController.swift
//  GBSlotMachine
//
//  Created by Павел Заруцков on 15.08.2022.
//

import UIKit
import Combine
import CombineCocoa

class SlotMachineViewController: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    var isSpinning = false
    var isPlaying = false
    let loopingMargin: Int = 4000
    let slotItems = ["🍒", "💎", "🍋"]
    lazy var pickerData = [self.slotItems, self.slotItems, self.slotItems]
    lazy var maxPickerRow = self.pickerData[0].count
    
    // MARK: - Outlets
    @IBOutlet weak var slotPickerView: UIPickerView!
    @IBOutlet weak var spinButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSubscriptions()
        setupPickerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for i in 0...2 { spinByRandom(for: i) }
        self.isPlaying = true
    }
}

// MARK: - Private function
extension SlotMachineViewController {
    
    private func setupUI() {
        titleLabel.text = "Крути эту штуку..."
    }
    
    private func setupSubscriptions() {
        let timerPublisher = Timer.publish(every: 0.01, on: .main, in: .default).autoconnect().share()
        timerPublisher.sink { _ in
            guard self.isSpinning else { return }
            for i in 0...2 { self.spinByRandom(for: i) }
        }.store(in: &subscriptions)
        
        spinButton.tapPublisher.sink { _ in
            self.isSpinning.toggle()
            
            if self.isPlaying {
                let slotEmoji1 = self.pickerData[0][self.slotPickerView.selectedRow(inComponent: 0) % self.maxPickerRow]
                let slotEmoji2 = self.pickerData[1][self.slotPickerView.selectedRow(inComponent: 1) % self.maxPickerRow]
                let slotEmoji3 = self.pickerData[2][self.slotPickerView.selectedRow(inComponent: 2) % self.maxPickerRow]
                
                if slotEmoji1 == slotEmoji2 && slotEmoji2 == slotEmoji3 {
                    self.titleLabel.text = "Поздравляем, ты выиграл!"
                } else {
                    self.titleLabel.text = "Не повезло, попробуй еще раз!"
                }
                
            } else {
                self.titleLabel.text = self.isSpinning ? "Удачи!" : "Крути эту штуку..."
            }
            if self.isSpinning {
                self.titleLabel.text = "Удачи!"
            }
            
            self.spinButton.setTitle(self.isSpinning ? "Стоп!" : "Погнали!", for: .normal)
        }.store(in: &subscriptions)
    }
    
    private func setupPickerView() {
        slotPickerView.delegate = self
        slotPickerView.dataSource = self
        
        slotPickerView.selectRow(loopingMargin / 2 * maxPickerRow, inComponent: 0, animated: false)
        slotPickerView.selectRow(loopingMargin / 2 * maxPickerRow, inComponent: 1, animated: false)
        slotPickerView.selectRow(loopingMargin / 2 * maxPickerRow, inComponent: 2, animated: false)
    }
    
    private func spinByOne(for row: Int) {
        slotPickerView.selectRow(slotPickerView.selectedRow(inComponent: row) + 1, inComponent: row, animated: true)
    }
    
    private func spinByRandom(for row: Int) {
        slotPickerView.selectRow(slotPickerView.selectedRow(inComponent: row) + Int.random(in: 1...maxPickerRow), inComponent: row, animated: true)
    }
}
