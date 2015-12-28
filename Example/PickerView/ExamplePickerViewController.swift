//
//  NumberPickerViewController.swift
//  PickerView
//
//  Created by Filipe Alvarenga on 09/08/15.
//  Copyright (c) 2015 Filipe Alvarenga. All rights reserved.
//

import UIKit
import PickerView

class ExamplePickerViewController: UIViewController {

    // MARK: - Nested Types

    enum PresentationType {
        case Numbers(Int, Int), Names(Int, Int) // NOTE: (Int, Int) represent the rawValue's of PickerView style enums.
    }

    // MARK: - Properties

    @IBOutlet weak var examplePicker: PickerView!
    
    let numbers: [String] = {
        var numbers = [String]()
        
        for index in 1...10 {
            numbers.append(String(index))
        }
    
        return numbers
    }()
    
    let osxNames = ["Cheetah", "Puma", "Jaguar", "Panther", "Tiger", "Leopard", "Snow Leopard", "Lion", "Montain Lion",
                    "Mavericks", "Yosemite", "El Capitan"]
    
    var presentationType = PresentationType.Numbers(0, 0)
    
    var currentSelectedValue: String?
    var updateSelectedValue: ((newSelectedValue: String) -> Void)?
    
    var itemsType: PickerExamplesTableViewController.ItemsType = .Label
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureExamplePicker()
    }
    
    // MARK: - Configure Subviews
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
    }
    
    private func configureExamplePicker() {
        examplePicker.dataSource = self
        examplePicker.delegate = self
        
        let scrollingStyle: PickerView.ScrollingStyle
        let selectionStyle: PickerView.SelectionStyle
        
        switch presentationType {
        case let .Numbers(scrollingStyleRaw, selectionStyleRaw):
            scrollingStyle = PickerView.ScrollingStyle(rawValue: scrollingStyleRaw)!
            selectionStyle = PickerView.SelectionStyle(rawValue: selectionStyleRaw)!
            
            examplePicker.scrollingStyle = scrollingStyle
            examplePicker.selectionStyle = selectionStyle
            
            if let currentSelected = currentSelectedValue, indexOfCurrentSelectedValue = numbers.indexOf(currentSelected) {
                examplePicker.currentSelectedRow = indexOfCurrentSelectedValue
            }
        case let .Names(scrollingStyleRaw, selectionStyleRaw):
            scrollingStyle = PickerView.ScrollingStyle(rawValue: scrollingStyleRaw)!
            selectionStyle = PickerView.SelectionStyle(rawValue: selectionStyleRaw)!
            
            examplePicker.scrollingStyle = scrollingStyle
            examplePicker.selectionStyle = selectionStyle
            
            if let currentSelected = currentSelectedValue, indexOfCurrentSelectedValue = osxNames.indexOf(currentSelected) {
                examplePicker.currentSelectedRow = indexOfCurrentSelectedValue
            }
        }
        
        if selectionStyle == .Image {
            examplePicker.selectionImageView.image = UIImage(named: "SelectionImage")!
        }
    }
    
    // MARK: Actions
    
    @IBAction func close(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func setNewPickerValue(sender: UIBarButtonItem) {
        if let updateValue = updateSelectedValue, currentSelected = currentSelectedValue {
            updateValue(newSelectedValue: currentSelected)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ExamplePickerViewController: PickerViewDataSource {
    
    // MARK: - PickerViewDataSource
    
    func pickerViewNumberOfRows(pickerView: PickerView) -> Int {
        switch presentationType {
        case .Numbers(_, _):
            return numbers.count
        case .Names(_, _):
            return osxNames.count
        }
    }
    
    func pickerView(pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        switch presentationType {
        case .Numbers(_, _):
            return numbers[index]
        case .Names(_, _):
            return osxNames[index]
        }
    }
    
}

extension ExamplePickerViewController: PickerViewDelegate {
    
    // MARK: - PickerViewDelegate
    
    func pickerViewHeightForRows(pickerView: PickerView) -> CGFloat {
        return 50.0
    }
    
    func pickerView(pickerView: PickerView, didSelectRow row: Int, index: Int) {
        switch presentationType {
        case .Numbers(_, _):
            currentSelectedValue = numbers[index]
        case .Names(_, _):
            currentSelectedValue = osxNames[index]
        }

        print(currentSelectedValue)
    }
    
    func pickerView(pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .Center
        if #available(iOS 8.2, *) {
            if (highlighted) {
                label.font = UIFont.systemFontOfSize(26.0, weight: UIFontWeightLight)
            } else {
                label.font = UIFont.systemFontOfSize(16.0, weight: UIFontWeightLight)
            }
        } else {
            if (highlighted) {
                label.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
            } else {
                label.font = UIFont(name: "HelveticaNeue-Light", size: 26.0)
            }
        }
        
        if (highlighted) {
            label.textColor = view.tintColor
        } else {
            label.textColor = UIColor(red: 161.0/255.0, green: 161.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        }
    }
    
    func pickerView(pickerView: PickerView, viewForRow row: Int, index: Int, highlited: Bool, reusingView view: UIView?) -> UIView? {
        
        if (itemsType != .CustomView) {
            return nil
        }
        
        var customView = view
        
        let imageTag = 100
        let labelTag = 101
        
        if (customView == nil) {
            var frame = pickerView.frame
            frame.origin = CGPointZero
            frame.size.height = 50
            customView = UIView(frame: frame)
            
            let imageView = UIImageView(frame: frame)
            imageView.tag = imageTag
            imageView.contentMode = .ScaleAspectFill
            imageView.image = UIImage(named: "AbstractImage")
            imageView.clipsToBounds = true
            
            customView?.addSubview(imageView)
            
            let label = UILabel(frame: frame)
            label.tag = labelTag
            label.textColor = UIColor.whiteColor()
            label.shadowColor = UIColor.blackColor()
            label.shadowOffset = CGSizeMake(1.0, 1.0)
            label.textAlignment = .Center
            
            if #available(iOS 8.2, *) {
                label.font = UIFont.systemFontOfSize(26.0, weight: UIFontWeightLight)
            } else {
                label.font = UIFont(name: "HelveticaNeue-Light", size: 26.0)
            }
            
            customView?.addSubview(label)
        }
        
        let imageView = customView?.viewWithTag(imageTag) as? UIImageView
        let label = customView?.viewWithTag(labelTag) as? UILabel
        
        switch presentationType {
        case .Numbers(_, _):
            label?.text = numbers[index]
        case .Names(_, _):
            label?.text = osxNames[index]
        }
        
        let alpha : CGFloat = highlited ? 1.0 : 0.5
        
        imageView?.alpha = alpha
        label?.alpha = alpha
        
        return customView
    }
    
}
