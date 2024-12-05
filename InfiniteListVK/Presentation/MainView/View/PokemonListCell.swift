//
//  PokemonListCell.swift
//  InfiniteListVK
//
//  Created by Никита Кисляков on 02.12.2024.
//

import SwiftUI

struct PokemonListCell: View {
    
    var pokemon: PokemonEntryModel
    
    var body: some View {
        HStack(alignment: .center) {
            
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100)
                    .padding(.leading)
                    .cornerRadius(10)
                    
            } placeholder: {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 100, height: 100)
            }
            
            Spacer()
            
            VStack {
                Text("Description")
                    .font(.title3)
                
                Text("\(pokemon.name) \(pokemon.name) \(pokemon.name) \(pokemon.name) \(pokemon.name) \(pokemon.name)")
                    .lineLimit(nil)
                    .font(.caption)
            }
            .frame(maxWidth: 110)
            
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(pokemon.name)
                    .lineLimit(1)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
        }
        
        Divider()
    }
}

#Preview {
    PokemonListCell(pokemon: .init(name: "Bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}
