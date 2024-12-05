//
//  DetailView.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 29.11.2024.
//

import SwiftUI

struct DetailView: View {
    @StateObject var vm: DetailViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var abilities: [String] = []
    @State private var name: String = ""
    let onDelete: (_ pokemon: PokemonEntryModel) -> ()
    let pokemon: PokemonEntryModel
    
    init(onDelete: @escaping (_ pokemon: PokemonEntryModel) -> (), pokemon: PokemonEntryModel) {
        self.onDelete = onDelete
        self.pokemon = pokemon
        _vm = StateObject(wrappedValue: DetailViewModel(
            pokemonsUseCase: Injection.shared.provideGetPokemonsUseCase()
        ))
    }
    
    var body: some View {
        header
        
        descriptionSection
            .task {
                do {
                    try await vm.getDetails(pokemon: pokemon)
                    vm.editedAbilities = vm.pokemon?.abilities ?? []
                }
                catch {
                    print(error)
                }
            }
    }
    
    private var header: some View {
        Text("Pokemon Abilities")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View {
        VStack {
            PokemonCard(pokemon: pokemon)
                .padding()
            
            Text("Abilities:")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            
            ForEach(0..<vm.editedAbilities.count, id: \.self) { index in
                TextField("Ability \(index + 1)", text: $vm.editedAbilities[index])
                    .padding(10)
                    .background(Color.gray.opacity(0.3).clipShape(RoundedRectangle(cornerRadius: 10)))
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 16)

            }
            
            Spacer()
            
            saveButton
            
            deleteButton
            
            Spacer()
        }
    }
    
    private var deleteButton: some View {
        Button {
            onDelete(pokemon)
            dismiss.callAsFunction()
        } label: {
            Text("Delete the pokemon")
                .font(.title3)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.red).clipShape(RoundedRectangle(cornerRadius: 10))
                .padding([.horizontal, .top])
                .shadow(color: .red.opacity(0.3), radius: 10, x: 0, y: 16)

        }
    }
    
    private var saveButton: some View {
        Button {
            Task {
                await vm.saveDetails()
            }
        } label: {
            Text("Save changes")
                .font(.title3)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue).clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 16)
                
        }
    }
}

#Preview {
    DetailView(onDelete: { _ in
        
    }, pokemon: .init(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}


