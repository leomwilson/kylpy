//
//  ItemView.swift
//  kylpypt2
//
//  Created by Leo Wilson on 11/22/23.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

struct ItemView: View {
    @ObservedObject var webVM: jsonWebVM
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.id, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var review: Int = 0
    
    @State var id: String
    @State var bathroom: Bathroom
    
    static let defLoc = CLLocationCoordinate2D(latitude: 33.421, longitude: -111.934) // default is a central location on ASU's campus
    @State var region = MKCoordinateRegion(
            center: defLoc,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    @State var markers = [Location(name: "Loading...", coordinate: defLoc)]
    
    var body: some View {
        VStack {
            Text(bathroom.name)
                .font(.title)
            Text(bathroom.desc)
            if (bathroom.rating.n == 0) {
                Text("No reviews.")
            } else {
                Text("Rating: \(bathroom.rating.t / bathroom.rating.n) stars (\(bathroom.rating.n) reviews)")
            }
            if (review == 0) {
                HStack {
                    // yes, I know this is dumb
                    Text("Review (stars): ")
                    Button(action: {
                        webVM.review(id: id, val: 1)
                        let n = Item(context: viewContext)
                        n.id = id
                        n.rating = 1
                        review = 1
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }) {
                        Text("1")
                    }
                    Button(action: {
                        webVM.review(id: id, val: 2)
                        let n = Item(context: viewContext)
                        n.id = id
                        n.rating = 2
                        review = 2
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }) {
                        Text("2")
                    }
                    Button(action: {
                        webVM.review(id: id, val: 3)
                        let n = Item(context: viewContext)
                        n.id = id
                        n.rating = 3
                        review = 3
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }) {
                        Text("3")
                    }
                    Button(action: {
                        webVM.review(id: id, val: 4)
                        let n = Item(context: viewContext)
                        n.id = id
                        n.rating = 4
                        review = 4
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }) {
                        Text("4")
                    }
                    Button(action: {
                        webVM.review(id: id, val: 5)
                        let n = Item(context: viewContext)
                        n.id = id
                        n.rating = 5
                        review = 5
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }) {
                        Text("5")
                    }
                }
            } else {
                HStack {
                    Text("Your review: \(review) stars")
                    Button(action: {
                        webVM.unreview(id: id, val: review)
                        for item in items {
                            if item.id == id {
                                viewContext.delete(item)
                            }
                        }
                        review = 0
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }) {
                        Text("Clear")
                    }
                }
            }
            Spacer()
            Map(coordinateRegion: $region, interactionModes: .all, annotationItems: markers
            ){ location in
                MapAnnotation(coordinate: location.coordinate, content: {
                    VStack {
                        Circle()
                        Text(location.name)
                    }
                })
            }.task {
                region.center = CLLocationCoordinate2D(latitude: bathroom.lat, longitude: bathroom.lon)
                markers[0].coordinate = region.center
                markers[0].name = bathroom.name
                for item in items {
                    if item.id == id {
                        review = Int(item.rating)
                        break
                    }
                }
            }
        }.padding()
    }
}
