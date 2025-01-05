import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Define a Book model
class Book {
  final int bookId;
  final double price;
  final String category;
  final int quantity;
  final String description;
  final String image;

  Book({
    required this.bookId,
    required this.price,
    required this.category,
    required this.quantity,
    required this.description,
    required this.image,
  });

  @override
  String toString() {
    return '$description\nCategory: $category\nPrice: \$${price.toStringAsFixed(2)}\nQuantity: $quantity';
  }
}

// Fetch books from the server
Future<List<Book>> getBooks() async {
  final response = await http.get(Uri.parse('http://mohammadfarhat258.atwebpages.com/getBooks.php'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) {
      return Book(
        bookId: int.parse(item['book_id']),
        price: double.parse(item['pr_price']),
        category: item['pr_category'],
        quantity: int.parse(item['pr_qty']),
        description: item['pr_desc'] ?? 'No description available',
        image: item['img'],
      );
    }).toList();
  } else {
    throw Exception('Failed to load books');
  }
}

// Widget to display each book in a card
class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.network(
              book.image,
              width: width * 0.25,
              height: width * 0.25,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.image_not_supported),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                book.toString(),
                style: TextStyle(fontSize: width * 0.04),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
