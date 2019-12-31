//
//  CalViewController.swift
//  Calendar2020
//
//  Created by iOSDevLog on 2019/12/30.
//  Copyright © 2019 iOSDevLog. All rights reserved.
//

import AppKit
import Cocoa

class CalViewController: NSViewController {
    @IBOutlet var calImageView: CalImageView!
    @IBOutlet var collectionView: NSCollectionView!
    @IBOutlet var todayButton: NSButton!
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var gameNameLabel: NSTextField!
    @IBOutlet var gameImageView: NSImageView!

    let configName = "calendar2020.json"
    let itemName = "CalCollectionViewItem"
    let itemIdentifier = NSUserInterfaceItemIdentifier("CalCollectionViewItem")

    var cal2020 = CalTodoYear()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
//        dummyData()
        fetchData()

        gameNameLabel.stringValue = "RivenTails: Defense"

        DistributedNotificationCenter.default().addObserver(
            self, selector: #selector(darkModeChanged(noti:)), name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
    }

    @objc func darkModeChanged(noti: NSNotification) {
        collectionView.reloadData()
        calImageView.image = NSImage(named: "2020")
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        layoutToday()
    }

    @IBAction func saveImage(_ sender: Any) {
        saveNSViewToImage(imageName: "2020-01-01.jpg")
    }

    func saveNSViewToImage(imageName: String) {
        if let data = self.view.image().tiffRepresentation {
            let imageRep = NSBitmapImageRep(data: data)
            let fileType = imageName.contains("png") ? NSBitmapImageRep.FileType.png : NSBitmapImageRep.FileType.jpeg
            let imageData = imageRep?.representation(using: fileType, properties: [:])
            let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

            let fileURL = documentDirectory.appendingPathComponent(imageName)
            do {
                try imageData?.write(to: fileURL)
            } catch let error as NSError {
                print("Error: fileURL failed to read: \n\(error)")
            }
        }
    }

    func saveLayerToImage(imageName: String) {
        if let data = self.view.layer?.image().tiffRepresentation {
            let imageRep = NSBitmapImageRep(data: data)
            let imageData = imageRep?.representation(using: .png, properties: [:])
            let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

            let fileURL = documentDirectory.appendingPathComponent(imageName)
            do {
                try imageData?.write(to: fileURL)
            } catch let error as NSError {
                print("Error: fileURL failed to read: \n\(error)")
            }
        }
    }

    func layoutToday() {
        let todayImageSize = todayButton.bounds.width / 2

        let orignWidth: CGFloat = 595
        let orignHeight: CGFloat = 842
        let originCellOffsetX: CGFloat = 31
        let originCellOffsetY: CGFloat = 89
        let originCellPaddingX: CGFloat = 22
        let originCellPaddingY: CGFloat = 64

        let originCelDistanceX: CGFloat = 22
        let originCelDistanceY: CGFloat = 19

        let curWidth = calImageView.bounds.width
        let curHeight = calImageView.bounds.height
        let ratioX = curWidth / orignWidth
        let ratioY = curHeight / orignHeight

        let curOffsetX: CGFloat = (originCellOffsetX + originCellPaddingX + originCelDistanceX * 3) * ratioX
        let curOffsetY: CGFloat = (originCellOffsetY + originCellPaddingY + originCelDistanceY * 0) * ratioY

        topConstraint.constant = curOffsetY - todayImageSize
        leadingConstraint.constant = curOffsetX - todayImageSize
    }

    func fetchData() {
        let reuslt = readFromFile(fileName: configName)
        if !reuslt {
            toastAlert(alertInformation: "读取文件失败")
        }
    }

    func dummyData() {
        for _ in 0 ..< 12 {
            var calTodoMonth = CalTodoMonth()
            for _ in 0 ..< 30 {
                var calTodoDay = CalTodoDay()
                for _ in 0 ..< 5 {
                    var calTodoSection = CalTodoSection()
                    calTodoSection.todoSection = "小武小久成长记"
                    var todoItem = CalTodoItem(todoKey: "打扫卫生", todoValue: "", finished: false)
                    calTodoSection.calTodoItems.append(todoItem)
                    todoItem = CalTodoItem(todoKey: "出动玩吧", todoValue: "", finished: false)
                    calTodoSection.calTodoItems.append(todoItem)
                    todoItem = CalTodoItem(todoKey: "乒乓球", todoValue: "", finished: false)
                    calTodoSection.calTodoItems.append(todoItem)
                    calTodoDay.calTodoSection.append(calTodoSection)
                }
                calTodoMonth.calTodoDays.append(calTodoDay)
            }
            cal2020.calTodoMonths.append(calTodoMonth)
        }
        if let jsonData = try? JSONEncoder().encode(cal2020) {
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                let result = writeToFile(fileName: configName, writeText: jsonString)
                if !result {
                    toastAlert(alertInformation: "文件写入失败")
                }
            }
        }
    }

    func toastAlert(alertInformation: String) {
        let alert = NSAlert()
        alert.messageText = "提示"
        alert.informativeText = alertInformation
        alert.helpAnchor = "NSAlert"
        alert.layout()
        alert.alertStyle = .warning
        alert.addButton(withTitle: "确定")
        alert.runModal()
    }

    func fileExist(path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let fm = FileManager.default
        return (fm.fileExists(atPath: path, isDirectory: &isDirectory))
    }

    func readFromFile(fileName: String) -> Bool {
        var readText: String?
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        let fileURL = documentDirectory.appendingPathComponent(fileName)

        if !fileExist(path: fileURL.path) {
            print("File Does Not Exist...")
            return false
        }

        print("File Path: \(fileURL.path)")

        do {
            readText = try String(contentsOf: fileURL)

            if let jsonData = readText?.data(using: String.Encoding.utf8) {
                if let calTodoYear = try? JSONDecoder().decode(CalTodoYear.self, from: jsonData) {
                    cal2020 = calTodoYear
                    collectionView.reloadData()
                }
            }
        } catch let error as NSError {
            print("Error: fileURL failed to read: \n\(error)")
            return false
        }
        return true
    }

    func writeToFile(fileName: String, writeText: String) -> Bool {
        let configURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        let fileURL = configURL.appendingPathComponent(fileName)

        do {
            try writeText.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Error: fileURL failed to write: \n\(error)")
            return false
        }
        return true
    }

    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: collectionView.bounds.size.width, height: 28)
        flowLayout.sectionInset = NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 4
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
        collectionView.layer?.backgroundColor = NSColor.black.cgColor

        collectionView?.register(NSNib(nibNamed: itemName, bundle: nil), forItemWithIdentifier: itemIdentifier)
    }
}

extension CalViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        if cal2020.calTodoMonths.count < 1 {
            return 0
        }
        return cal2020.calTodoMonths[0].calTodoDays[0].calTodoSection.count
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return cal2020.calTodoMonths[0].calTodoDays[0].calTodoSection[section].calTodoItems.count
    }

    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        let view = collectionView.makeSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CalSectionView"), for: indexPath) as! CalSectionView

        let calTodoSection = cal2020.calTodoMonths[0].calTodoDays[0].calTodoSection[indexPath.section]
        view.sectionTitle.stringValue = "\(indexPath.section + 1). \(String(describing: calTodoSection.todoSection))"

        return view
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: itemIdentifier, for: indexPath)
        guard let collectionViewItem = item as? CalCollectionViewItem else { return item }

        let calTodoItem = cal2020.calTodoMonths[0].calTodoDays[0].calTodoSection[indexPath.section].calTodoItems[indexPath.item]
        collectionViewItem.checkBox.image = calTodoItem.finished ? NSImage(named: "Check") : NSImage(named: "Uncheck")
        collectionViewItem.keyLabel.stringValue = calTodoItem.todoKey
        if let todoValue = calTodoItem.todoValue {
            collectionViewItem.valueLabel.stringValue = todoValue
        } else {
            collectionViewItem.valueLabel.stringValue = ""
        }

        return item
    }
}

extension CalViewController: NSCollectionViewDelegate {
}

extension CalViewController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        return NSSize(width: collectionView.bounds.size.width, height: 38)
    }
}
