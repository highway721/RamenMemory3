//
//  ContentView.swift
//  Ramen Memory2
//
//  Created by Yusuke Tomatsu on 2020/08/02.
//  Copyright © 2020 Yusuke Tomatsu. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Ramen.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Ramen.name, ascending: true),
        NSSortDescriptor(keyPath: \Ramen.rating, ascending: true),
        NSSortDescriptor(keyPath: \Ramen.imageD, ascending: true)
    ]) var ramens: FetchedResults<Ramen>
    @State private var showingAddScreen = false
    
    
    var body: some View {
        NavigationView {
           List {
               ForEach(ramens, id: \.self) { ramen in
                NavigationLink(destination:DetailView(ramen: ramen)) {
                       EmojiRatingView(rating: ramen.rating)
                           .font(.largeTitle)

                       VStack(alignment: .leading) {
                           Text(ramen.name ?? "Unknown Title")
                               .font(.headline)
                           Text(ramen.shop ?? "Unknown Author")
                               .foregroundColor(.secondary)
                        Text(ramen.date ?? "Unknown Date")
                               .font(.caption)
                       }
                   }
               }
           .onDelete(perform: deleteRamens)
           }
           .navigationBarTitle("Ramen Memory2")
           .navigationBarItems(leading:EditButton(), trailing: Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddScreen) {
                    AddRamenView().environment(\.managedObjectContext, self.moc)
                }
        }
    }
    func deleteRamens(at offsets: IndexSet){
        for offset in offsets{
            // find this ramne in our fetch request
            let ramen = ramens[offset]
            //delete it from the context
            moc.delete(ramen)
        }
        //save the context
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
