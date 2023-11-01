import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ItemListView(viewModel: ItemListViewModel())
                .navigationTitle("PicNix")
        }
    }
}


// View
struct ItemListView: View {
    @ObservedObject var viewModel: ItemListViewModel

    var body: some View {
        VStack {
            List(viewModel.items) { item in
                Text(item.username)
            }
            .foregroundColor(.black)
            /*Button("Add Item") {
                $viewModel.addItem(username: "Username")
            }*/
        }
        .onAppear {
                print("Items count: \(viewModel.items.count)")
            }

    }
}


// ViewModel
class ItemListViewModel: ObservableObject {
    @Published var items: [Post] = []

    init() {
        // Move your networking code inside an initializer
        if let url = URL(string: "https://www.jalirani.com/files/picnix.json") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else { return }
                if let data = data {
                    do {
                        // Parse JSON
                        let decodedData = try JSONDecoder().decode([Post].self, from: data)
                        DispatchQueue.main.async {
                            self.items = decodedData
                        }
                    } catch {
                        print("Error decoding JSON: \(error.localizedDescription)")
                    }
                } else if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

