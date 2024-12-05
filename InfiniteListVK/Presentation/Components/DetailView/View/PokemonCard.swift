//
//  PokemonCard.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 05.12.2024.
//

import SwiftUI

struct PokemonCard: View {
    let pokemon: PokemonEntryModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
            } placeholder: {
                Rectangle().fill(.ultraThinMaterial)
                    .frame(width: 160, height: 160)
            }

            Text(pokemon.name.capitalized)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .padding(.top, 4)
        }
        .padding(16)
        .background(.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 24, x: 0, y: 16)
    }
}

#Preview {
    PokemonCard(pokemon: .init(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}
