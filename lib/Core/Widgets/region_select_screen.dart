import 'package:flutter/material.dart';

class RegionSelectScreen extends StatelessWidget {
  const RegionSelectScreen({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current selection
            _buildSelectionItem('Region', 'United States'),
            _buildSelectionItem('Review App', ''),
            
            Divider(),
            SizedBox(height: 24),
            
            // Select Region section
            Text(
              'Select Region',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Region options
            _buildRegionOption('United States (\$)', true),
            _buildRegionOption('Canada (CA\$)', false),
            _buildRegionOption('United Kingdom (£)', true),
            _buildRegionOption('Singapore (S\$)', true),
            _buildRegionOption('Germany (€)', true),
            _buildRegionOption('Italy (€)', false),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSelectionItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
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
  
  Widget _buildRegionOption(String title, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          Checkbox(value: isSelected, onChanged: (value) {}),
        ],
      ),
    );
  }
}