//
//  MyFuncs.swift
//  core2
//
//  Created by WMIII on 2021/4/22.
//

import Foundation
import SwiftUI
import UIKit
import CoreData

/*

func QuickSort( list: inout [Application], first: Int, last: Int) {
    // 快速排序
    var i, j: Int
    var key: Application
    if first >= last {
        print("排序错误")
        return;
    }
    i = first
    j = last
    key = list[i]
    while i < j {
        //找出来比key小的 并排到key前面
        while i < j && list[j].section! > key.section! {
            j -= 1
        }
        if i < j {
            list[i] = list[j]
            i += 1
        }
        //找出来比key大的 并排到key后面
        while i < j && list[i].section! < key.section! {
            i += 1
        }
        if i < j {
            list[j] = list[i]
            j -= 1
        }
    }
    list[i] = key
    //将key前面元素递归的进行下一轮排序
    if first < i - 1 {
        QuickSort(list: &list, first: first, last: i - 1)
    }
    //将key后面的元素递归的进行下一轮排序
    if i + 1 < last {
        QuickSort(list: &list, first: i + 1, last: last)
    }
}


func ResultsToArray(apps: FetchedResults<Application>) -> [[Application]]{
    var applist = [Application]()
    for index_a in apps {
        applist.append(index_a)
    }
    QuickSort(list: &applist, first: 0, last: applist.count - 1)
    
    var array2D = [[Application]]()
    var row = [Application]()
    row.append(applist[0])
    
    for index_i in 1 ..< applist.count {
        if applist[index_i].section == row[0].section {
            row.append(applist[index_i])
        }
        else {
            array2D.append(row)
            row.removeAll()
            row.append(applist[index_i])
        }
    }
    
    return array2D
}
*/


