import SwiftUI
import UIKit

// View
struct ItemListView: View {
    @ObservedObject var viewModel: ItemListViewModel
    @State private var isSheetPresented: Bool = false
    @State private var selectedPost: Post?

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 255.0/255.0, alpha: 1.0))
                    .edgesIgnoringSafeArea(.all)
                List(viewModel.items) { item in
                    if item.isPrivate {
                        Text("\(item.username) has their posts set to private.")
                            .foregroundColor(.red)
                    } else {
                        if item.flow == "IMAGE"{
                            ZStack {
                                Text("👤 \(item.username)")
                                    .foregroundColor(.cyan)
                                    .padding(.trailing, 250)
                                    .onTapGesture {
                                        selectedPost = item
                                        isSheetPresented.toggle()
                                    }
                                Spacer()
                                Text("\(item.amount) Points")
                                    .background(Color.black.opacity(0.7))
                                    .padding(.leading, 275)
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        selectedPost = item
                                        isSheetPresented.toggle()
                                    }
                            }
                            AsyncImage(url: item.image, scale: 1.5)
                                .frame(maxHeight: 400)
                                .onTapGesture {
                                    selectedPost = item
                                    isSheetPresented.toggle()
                                }
                            Text("📍 \(item.businessName)")
                                .onTapGesture {
                                    selectedPost = item
                                    isSheetPresented.toggle()
                                }
                            
                        }
                    }
                }
                .navigationTitle("PicNix")
                .onAppear {
                    viewModel.posts()
                }
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            if let post = selectedPost {
                VStack {
                    HStack {
                        Spacer()
                        Button("X") {
                            isSheetPresented = false
                        }
                        .padding()
                    }

                    Text("Username: \(post.username)")
                    Text("Points earned: \(post.amount)")
                    AsyncImage(url: post.image, scale: 1.5)
                        .frame(maxHeight: 600)
                    Text("Restaurant name: \(post.businessName)")
                    Text("Caption: \(post.caption ?? "No Caption for this post")")
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
}

// ViewModel
class ItemListViewModel: ObservableObject {
    @Published var items: [Post] = []

    func posts() {
        // Move your networking code inside an initializer
        guard let url = URL(string: "https://www.jalirani.com/files/picnix.json") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else { return }
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Post].self, from: data)
                    self.items = decodedData
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct Post: Identifiable, Decodable {
    let id: Int
    let image: URL
    let flow: String
    let amount: Int
    let createdAt: String
    let businessName: String
    let businessId: Int
    let username: String
    let userId: Int
    let isPrivate: Bool
    let caption: String?
    
    enum CodingKeys: String, CodingKey {
        case id, image, flow, amount, createdAt, businessName, businessId, username, userId, caption
        case isPrivate = "private"
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView(viewModel: ItemListViewModel())
    }
}

