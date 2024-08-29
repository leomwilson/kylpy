//
//  MapView.swift
//  kylpypt2
//
//  Created by Leo Wilson on 11/22/23.
//

import SwiftUI
import MapKit

struct LinkLocation: Identifiable {
    var name: String
    var coordinate: CLLocationCoordinate2D
    var id: String
    var br: Bathroom
}

struct MapView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var webVM: jsonWebVM
    
    static let defLoc = CLLocationCoordinate2D(latitude: 33.421, longitude: -111.934) // default is a central location on ASU's campus
    @State var region = MKCoordinateRegion(
            center: defLoc,
            span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        )
    @State var markers: [LinkLocation] = []
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, interactionModes: .all, annotationItems: markers
            ){ location in
                MapAnnotation(coordinate: location.coordinate, content: {
                    NavigationLink(destination: ItemView(webVM: webVM, id: location.id, bathroom: location.br).environment(\.managedObjectContext, viewContext)) {
                        VStack {
                            Circle()
                            Text(location.name)
                        }
                    }
                })
            }.task {
                markers = []
                for id in webVM.bathrooms!.keys {
                    let br = webVM.bathrooms![id]!
                    markers.append(LinkLocation(name: br.name, coordinate: CLLocationCoordinate2D(latitude: br.lat, longitude: br.lon), id: id, br: br))
                }
            }
        }
    }
}
