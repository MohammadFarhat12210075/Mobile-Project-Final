import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'books.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchQuery = '';
  List<Book> _searchedBooks = [];
  bool _isLoading = false;

  Future<void> _searchBooks() async {
    if (_searchQuery.isEmpty) {
      setState(() {
        _searchedBooks = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'http://mohammadfarhat258.atwebpages.com/getBooks.php?search=$_searchQuery'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _searchedBooks = data.map((item) {
            return Book(
              bookId: int.parse(item['book_id']),
              price: double.parse(item['pr_price']),
              category: item['pr_category'] ?? 'Uncategorized',
              quantity: int.parse(item['pr_qty']),
              description: item['pr_desc'] ?? 'No description available',
              image: item['img'] ?? '',
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load searched books');
      }
    } catch (e) {
      setState(() {
        _searchedBooks = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching for books: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Books'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search for books',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
                _searchBooks();
              },
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _searchedBooks.isEmpty
                ? const Center(child: Text('No results found'))
                : Expanded(
              child: ListView.builder(
                itemCount: _searchedBooks.length,
                itemBuilder: (context, index) {
                  final book = _searchedBooks[index];
                  return BookCard(book: book);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
