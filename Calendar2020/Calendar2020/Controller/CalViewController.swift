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

    let itemName = "CalCollectionViewItem"
    let itemIdentifier = NSUserInterfaceItemIdentifier("CalCollectionViewItem")

    var cal2020 = CalTodoYear()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        fetchData()

        calImageView.image = NSImage(named: "2020")
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func fetchData() {
        for _ in 0 ..< 12 {
            var calTodoMonth = CalTodoMonth()
            for _ in 0 ..< 30 {
                var calTodoDay = CalTodoDay()
                for _ in 0..<5 {
                    var calTodoSection = CalTodoSection()
                    calTodoSection.todoSection = "小武小久成长记"
                    var todoItem = CalTodoItem(todo: "打扫月卫生", finished: false)
                    calTodoSection.calTodoItems.append(todoItem)
                    todoItem = CalTodoItem(todo: "我想要去", finished: true)
                    calTodoSection.calTodoItems.append(todoItem)
                    todoItem = CalTodoItem(todo: "我还想要去", finished: true)
                    calTodoSection.calTodoItems.append(todoItem)
                    calTodoDay.calTodoSection.append(calTodoSection)
                }
                calTodoMonth.calTodoDays.append(calTodoDay)
            }
            cal2020.calTodoMonths.append(calTodoMonth)
        }
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
        collectionViewItem.sectionLabel.stringValue = "\(String(describing: calTodoItem.todo))"

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
