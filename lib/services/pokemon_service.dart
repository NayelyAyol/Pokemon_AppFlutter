import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  static Future<List<Pokemon>> fetchPokemons(
    int offset,
    int limit,
  ) async {
    try {
      final url = Uri.parse(
        'https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception(
          'Error al obtener la lista de Pokémon',
        );
      }

      final data = jsonDecode(response.body);

      List results = data['results'];

      List<Pokemon> pokemons = [];

      for (var item in results) {
        try {
          final detailResponse =
              await http.get(Uri.parse(item['url']));

          if (detailResponse.statusCode == 200) {
            final detailData =
                jsonDecode(detailResponse.body);

            pokemons.add(
              Pokemon.fromJson(detailData),
            );
          }
        } catch (e) {
          print(
            'Error cargando Pokémon: ${item['name']}',
          );
        }
      }

      print(
        'Pokémons cargados: ${pokemons.length}',
      );

      return pokemons;
    } catch (e) {
      print('ERROR GENERAL: $e');
      rethrow;
    }
  }

  static Future<Pokemon> fetchPokemonByName(
    String name,
  ) async {
    final response = await http.get(
      Uri.parse(
        'https://pokeapi.co/api/v2/pokemon/$name',
      ),
    );

    if (response.statusCode == 200) {
      final data =
          jsonDecode(response.body);

      return Pokemon.fromJson(data);
    }

    throw Exception(
      'Pokémon no encontrado',
    );
  }
}