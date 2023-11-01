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
            List(viewModel.items, id: \.username) { item in
                Text(item.username)
            }
            /*Button("Add Item") {
                $viewModel.addItem(username: "Username")
            }*/
        }
    }
}


// ViewModel
class ItemListViewModel: ObservableObject {
    @Published var items: [Post] = []

        guard let url = URL(string: "https://www.jalirani.com/files/picnix.json.") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else { return }
            if let data = data {
                do {
                    //Parse JSON
                    let decodedData = try JSONDecoder().decode([Post].self, from: data)
                    self.posts = decodedData
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
}
