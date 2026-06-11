import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'models/pokemon.dart';
import 'services/pokemon_service.dart';

void main() {
  runApp(const PokemonApp());
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF0F8FF),
        colorSchemeSeed: const Color(0xFF90CAE4),
        useMaterial3: true,
        fontFamily: 'monospace',
      ),
      home: const PokemonPage(),
    );
  }
}

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  static const pageSize = 5;

  final TextEditingController _searchController = TextEditingController();

  Pokemon? searchedPokemon;

  late final PagingController<int, Pokemon> _pagingController =
      PagingController(
    getNextPageKey: (state) {
      if (state.lastPageIsEmpty) return null;
      return state.pages?.expand((e) => e).length ?? 0;
    },
    fetchPage: (pageKey) async {
      return PokemonService.fetchPokemons(pageKey, pageSize);
    },
  );

  Future<void> searchPokemon() async {
    final name = _searchController.text.trim().toLowerCase();
    if (name.isEmpty) return;
    try {
      final pokemon = await PokemonService.fetchPokemonByName(name);
      setState(() {
        searchedPokemon = pokemon;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFD8EFFC),
          content: Row(
            children: const [
              Icon(Icons.error_outline, color: Color(0xFF4A90B0)),
              SizedBox(width: 8),
              Text(
                "Pokémon no encontrado",
                style: TextStyle(color: Color(0xFF1A4A6A)),
              ),
            ],
          ),
        ),
      );
    }
  }

  void showAllPokemons() {
    setState(() {
      searchedPokemon = null;
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Pastel colors per type
  Color _typeColor(String typeName) {
    const typeColors = {
      'fire':     Color(0xFFFFB5A0),
      'water':    Color(0xFFA0C8FF),
      'grass':    Color(0xFFB5E8A0),
      'electric': Color(0xFFFFF0A0),
      'psychic':  Color(0xFFFFB5D8),
      'ice':      Color(0xFFB5E8F0),
      'dragon':   Color(0xFFB5A0FF),
      'dark':     Color(0xFFBBAA99),
      'fairy':    Color(0xFFFFB5E8),
      'normal':   Color(0xFFD8D8C0),
      'fighting': Color(0xFFFFAAA0),
      'flying':   Color(0xFFB5C8FF),
      'poison':   Color(0xFFD8A0D8),
      'ground':   Color(0xFFEEDDA0),
      'rock':     Color(0xFFD8C888),
      'bug':      Color(0xFFCCE888),
      'ghost':    Color(0xFFB5A0CC),
      'steel':    Color(0xFFCCCCDD),
    };
    return typeColors[typeName] ?? const Color(0xFFCCCCCC);
  }

  Color _typeTextColor(String typeName) {
    const textColors = {
      'fire':     Color(0xFF8B3A20),
      'water':    Color(0xFF1A4A7A),
      'grass':    Color(0xFF2A5A1A),
      'electric': Color(0xFF7A6A00),
      'psychic':  Color(0xFF8B2A55),
      'ice':      Color(0xFF1A6A7A),
      'dragon':   Color(0xFF3A1A8B),
      'dark':     Color(0xFF443322),
      'fairy':    Color(0xFF8B2A6A),
      'normal':   Color(0xFF555544),
      'fighting': Color(0xFF7A2020),
      'flying':   Color(0xFF1A3A7A),
      'poison':   Color(0xFF5A1A5A),
      'ground':   Color(0xFF6A5500),
      'rock':     Color(0xFF5A4A10),
      'bug':      Color(0xFF4A6000),
      'ghost':    Color(0xFF3A1A5A),
      'steel':    Color(0xFF404055),
    };
    return textColors[typeName] ?? const Color(0xFF444444);
  }

  Widget _buildTypeChip(String typeName) {
    final bg = _typeColor(typeName);
    final fg = _typeTextColor(typeName);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        typeName.toUpperCase(),
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF7AAABB),  // celeste medio apagado
                fontSize: 11,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2A4A5A),  // azul oscuro suave
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPokemonCard(Pokemon pokemon) {
    final types = pokemon.types
        .map<String>((e) => e['type']['name'] as String)
        .toList();
    final abilities = pokemon.abilities
        .map<String>((e) => e['ability']['name'] as String)
        .toList();

    final cardTint = types.isNotEmpty
        ? _typeColor(types.first).withOpacity(0.18)
        : const Color(0xFFE0F4FF);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF90CAE4).withOpacity(0.22),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top tinted header
          Container(
            decoration: BoxDecoration(
              color: cardTint,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemon.name.toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF2A4A5A),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: types.map(_buildTypeChip).toList(),
                    ),
                  ],
                ),
                Text(
                  '#${pokemon.id.toString().padLeft(3, '0')}',
                  style: const TextStyle(
                    color: Color(0xFF90CAE4),  // celeste acento
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          // Sprite
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFF0F8FF),  // fondo celeste muy suave
                shape: BoxShape.circle,
              ),
              child: Image.network(
                pokemon.image,
                height: 110,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.catching_pokemon,
                    size: 80,
                    color: Color(0xFFBEDEF5),
                  );
                },
              ),
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DATOS',
                  style: TextStyle(
                    color: Color(0xFF90CAE4),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(height: 6),
                _buildStatRow('Altura', '${pokemon.height}'),
                _buildStatRow('Peso', '${pokemon.weight}'),
                _buildStatRow('Experiencia base', '${pokemon.baseExperience}'),
                _buildStatRow('Orden', '${pokemon.order}'),
                _buildStatRow('Tipos', '${pokemon.types.length}'),
                _buildStatRow('Habilidades', '${abilities.length}'),
                _buildStatRow(
                    'Imagen disponible', pokemon.image.isNotEmpty ? 'Sí' : 'No'),
              ],
            ),
          ),

          // Abilities
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HABILIDADES',
                  style: TextStyle(
                    color: Color(0xFF90CAE4),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: abilities
                      .map(
                        (a) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF7FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            a,
                            style: const TextStyle(
                              color: Color(0xFF4F8F8F),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF90CAE4),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Nayely Ayol',
                  style: TextStyle(
                    color: Color(0xFF7BBBD4),
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F4FF),  // celeste muy claro
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF90CAE4),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'POKÉDEX',
              style: TextStyle(
                color: Color(0xFF2A6080),  // azul oscuro pastel
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFBEDEF5)),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: Color(0xFF2A4A5A),
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre...',
                      hintStyle: const TextStyle(color: Color(0xFF7BBBD4)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF7BBBD4),
                        size: 18,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Color(0xFFBEDEF5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Color(0xFFBEDEF5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Color(0xFF90CAE4), width: 2),
                      ),
                    ),
                    onSubmitted: (_) => searchPokemon(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: searchPokemon,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF90CAE4),  // celeste acento
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Show all button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: showAllPokemons,
                icon: const Icon(
                  Icons.refresh,
                  size: 14,
                  color: Color(0xFF5A9EBF),
                ),
                label: const Text(
                  'MOSTRAR TODOS',
                  style: TextStyle(
                    color: Color(0xFF5A9EBF),
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFBEDEF5)),
                  backgroundColor: const Color(0xFFFFFFFF),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: searchedPokemon != null
                ? ListView(
                    children: [buildPokemonCard(searchedPokemon!)],
                  )
                : PagingListener(
                    controller: _pagingController,
                    builder: (context, state, fetchNextPage) {
                      return PagedListView<int, Pokemon>(
                        state: state,
                        fetchNextPage: fetchNextPage,
                        builderDelegate:
                            PagedChildBuilderDelegate<Pokemon>(
                          itemBuilder: (context, pokemon, index) {
                            return buildPokemonCard(pokemon);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}