//
//  ContentView.swift
//  core2
//
//  Created by WMIII on 2021/4/5.
//

import SwiftUI
import UIKit
import Combine
import CoreData
import CleanJSON


struct AppContent: Codable {
    var lighturl: String
    var darkurl: String
    var position: Bool
    var section: String
    var title: String
}

struct AppList: Codable {
    var contents: [AppContent]
}


struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Application.title, ascending: true)],
        animation: .default)
    private var apps: FetchedResults<Application>
    private var sorted_apps = [[Application]]()
    
    init() {
        sorted_apps = ResultsToArray(apps: apps)
    }
    
    var body: some View {
        VStack(alignment: .leading)
        {
            Text("App Center")
            ScrollView(Axis.Set.vertical)
            {
                // sorted_apps.count
                ForEach(0 ..< 5)
                {
                    row in
                    Text("List\(row + 1)")
                        .frame(width: UIScreen.main.bounds.width - 10, height: 20, alignment: .leading)
                    ScrollView(Axis.Set.horizontal) {
                        HStack {
                            ForEach(0 ..< 30)
                            {
                                i in
                                    Text("\(i)")
                            }
                        }
                    }
                }
            }
        }
    }

    
    func getAppJson()
    {
        // 测试用URL地址，本地Django服务器提供
        let urlAddress = "http://127.0.0.1:8000/api/getjson"
        
        guard let adurl = URL(string: urlAddress) else {return}
        URLSession.shared.dataTask(with: adurl) {
            (data, response, error) in
            do {
                if let d = data
                {
                    let contents:AppList = try CleanJSONDecoder().decode(AppList.self, from: d)
                    DispatchQueue.main.async {
                        for content in contents.contents
                        {
                            addApp(appjson: content)
                        }
                    }
                }
                else
                {
                    print("no data.")
                }
            }
            catch
            {
                print("error")
            }
        }.resume()
    }
    
    
    func isAppExist(appname: String) -> Bool {
        for app in apps {
            if appname == app.title
            {
                return true
            }
        }
        return false
    }
    
    
    private func addApp(appjson: AppContent) {
        if isAppExist(appname: appjson.title)
        {
            print("该应用已存在")
            return
        }
        
        withAnimation {
            
            let newApp = Application(context: viewContext)
            newApp.lightURL = appjson.lighturl
            newApp.darkURL = appjson.darkurl
            newApp.position = appjson.position
            newApp.section = appjson.section
            newApp.title = appjson.title
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    private func deleteApps(offsets: IndexSet) {
        withAnimation {
            offsets.map { apps[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    mutating func QuickSort( list: inout [Application], first: Int, last: Int) {
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


    mutating func ResultsToArray(apps: FetchedResults<Application>) -> [[Application]] {
        var applist = [Application]()
        var array2D = [[Application]]()
        print(apps.count)
        if apps.count == 0 {
            return array2D
        }
        
        for index_a in apps {
            applist.append(index_a)
        }
        QuickSort(list: &applist, first: 0, last: applist.count - 1)
        
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

    
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
