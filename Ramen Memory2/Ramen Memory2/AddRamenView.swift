//
//  AddRamenView.swift
//  Ramen Memory2
//
//  Created by Yusuke Tomatsu on 2020/08/02.
//  Copyright © 2020 Yusuke Tomatsu. All rights reserved.
//

import SwiftUI

struct AddRamenView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Ramen.entity(), sortDescriptors: []) var ramens: FetchedResults<Ramen>
    @State private var showingAddScreen = false
    
    @State private var name = ""
    @State private var shop = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var date = ""
    @State var image: Data = .init(count:0)
    @State var show = false
    //keyboard 調整用
    @State private var keyboardHeight: CGFloat = 0
    
   let genres = ["豚骨(Pork)","醤油(Soy sauce)","塩(salt)","味噌(miso)","家系","まぜそば(mixed noodles)"]
   var body: some View {
    
           NavigationView{
               Form{
                   Section{
                       TextField("Name of Ramen",text: $name)
                       TextField("Shop name",text: $shop)
                       
                       Picker("Genre",selection: $genre){
                           ForEach(genres, id: \.self){
                               Text($0)
                           }
                       }
                     TextField("Date",text: $date)
                   }
                   Section{
                       RatingView(rating: $rating)
                       TextField("Write a review", text: $review)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                   }
                Section{
                 
                    Button("Select Image"){
                        self.show = true
                    }
                    .sheet(isPresented: self.$show, content: {
                        ImagePicker(show: self.$show, image: self.$image)
                    })
                }
                   Section{
                       Button("save"){
                           let newRamen = Ramen(context: self.moc)
                           newRamen.name = self.name
                           newRamen.shop = self.shop
                           newRamen.rating = Int16(self.rating)
                           newRamen.genre = self.genre
                           newRamen.review = self.review
                           newRamen.date = self.date
                           newRamen.imageD = self.image
                           try? self.moc.save()
                           self.presentationMode.wrappedValue.dismiss()
                       }
                   }
               }
           .navigationBarTitle("Add Ramen")
           }
       }
    
   }

struct AddRamenView_Previews: PreviewProvider {
    static var previews: some View {
        AddRamenView()
    }
}
