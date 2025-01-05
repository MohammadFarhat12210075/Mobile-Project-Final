import 'package:flutter/material.dart';
import 'books.dart';
import 'search.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = true;
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final books = await getBooks();
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching books: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,  // First line for AppBar theme
        foregroundColor: Colors.white,  // Second line for AppBar theme
        actions: [
          IconButton(
            onPressed: _isLoading ? null : () => fetchBooks(),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Search()),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
        title: const Text('Book of Books'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _books.length,
          itemBuilder: (context, index) {
            final book = _books[index];
            return BookCard(book: book);
          },
        ),
      ),
    );
  }
}