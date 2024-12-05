//
//  MainView.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 29.11.2024.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm: MainViewModel = .init(
        pokemonsUseCase: Injection.shared.provideGetPokemonsUseCase()
    )
    @State private var isPresented: Bool = false
    @State private var selectedPokemon: PokemonEntryModel? = nil
    
    var body: some View {
        VStack(alignment: .center) {
            
            logo
            
            pokemonList
                .overlay {
                    if vm.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
        }
        .background(
            background
        )
        .onAppear {
            Task {
                do {
                    try await vm.loadInitialPokemons()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private var logo: some View {
        HStack {
            Spacer()
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 50)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 45)
    }
    
    private var background: some View {
        VStack{
            Image("background")
                .padding(.top, -100)
            Spacer()
        }
    }
    
    private var pokemonList: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.pokemons, id: \.id) { pokemon in
                    PokemonListCell(pokemon: pokemon)
                        .onAppear {
                            if vm.shouldLoadMore(pokemon: pokemon) {
                                Task {
                                    await vm.loadMorePokemons()
                                }
                            }
                        }
                        .background(Color.black.opacity(0.0001))
                        .onTapGesture {
                            selectedPokemon = pokemon
                            isPresented.toggle()
                        }
                }
            }
        }
        .sheet(item: $selectedPokemon) {
            selectedPokemon = nil
        } content: {
            DetailView(onDelete: { pokemon in
                Task {
                    try await vm.deletePokemon(pokemon: pokemon)
                }
            }, pokemon: $0)
        }
    }
}


#Preview {
    MainView()
}
