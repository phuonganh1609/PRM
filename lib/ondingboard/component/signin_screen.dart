import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Selection items
            _buildSelectionItem('Region', 'United States'),
            _buildSelectionItem('Review App', ''),
            
            Spacer(),
            
            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('Contact Us'),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Affiliate Disclosure'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSelectionItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              if (value.isNotEmpty) Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(width: 8),
              Checkbox(value: title == 'Region', onChanged: (value) {}),
            ],
          ),
        ],
      ),
    );
  }
}