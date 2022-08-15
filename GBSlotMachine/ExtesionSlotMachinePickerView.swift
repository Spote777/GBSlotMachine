//
//  ExtesionSlotMachinePickerView.swift
//  GBSlotMachine
//
//  Created by Павел Заруцков on 15.08.2022.
//

import UIKit

extension SlotMachineViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return loopingMargin * maxPickerRow
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row % maxPickerRow]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currentIndex = row % maxPickerRow
        slotPickerView.selectRow((loopingMargin / 2) * maxPickerRow + currentIndex, inComponent: component, animated: false)
    }
}
