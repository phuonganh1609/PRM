import 'package:flutter/material.dart';

class SaleFilterScreen extends StatelessWidget {
  const SaleFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Filter'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select All section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select All',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(value: false, onChanged: (value) {}),
              ],
            ),
            
            SizedBox(height: 24),
            
            // Push Notifications section
            Text(
              'Push Notifications',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Notification options
            _buildNotificationOption('Get notified about sales', false),
            _buildNotificationOption('Case', true),
            _buildNotificationOption('CPU', false),
            _buildNotificationOption('Motherboard', false),
            _buildNotificationOption('GPU', true),
            _buildNotificationOption('RAM', false),
            _buildNotificationOption('CPU Cooler', false),
            _buildNotificationOption('Storage', false),
            _buildNotificationOption('Power Supply', false),
            
            SizedBox(height: 24),
            
            Divider(),
            
            SizedBox(height: 24),
            
            // View Results button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('View Results (All)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNotificationOption(String title, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Switch(value: isChecked, onChanged: (value) {}),
        ],
      ),
    );
  }
}

// Bottom sheet version for modal display
class SaleFilterBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  
  const SaleFilterBottomSheet({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sales Filter',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(),
          // Content
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16.0),
              children: [
                // Select All section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select All',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(value: false, onChanged: (value) {}),
                  ],
                ),
                
                SizedBox(height: 24),
                
                // Push Notifications section
                Text(
                  'Push Notifications',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Notification options
                _buildNotificationOption('Get notified about sales', false),
                _buildNotificationOption('Case', false),
                _buildNotificationOption('CPU', false),
                _buildNotificationOption('Motherboard', false),
                _buildNotificationOption('GPU', false),
                _buildNotificationOption('RAM', false),
                _buildNotificationOption('CPU Cooler', false),
                _buildNotificationOption('Storage', false),
                _buildNotificationOption('Power Supply', false),
                _buildNotificationOption('Case Fan', false),
                _buildNotificationOption('Monitor', false),
                _buildNotificationOption('Mouse', false),
                _buildNotificationOption('Keyboard', false),
                _buildNotificationOption('Speaker', false),
                _buildNotificationOption('Headphones', false),
                _buildNotificationOption('Thermal Compound', false),
                _buildNotificationOption('Operating System', false),
                _buildNotificationOption('Sound Card', false),
                _buildNotificationOption('Network Card', false),
                _buildNotificationOption('Microphone', false),
                _buildNotificationOption('VR Headset', false),
                _buildNotificationOption('Capture Card', false),
                _buildNotificationOption('Webcam', false),
                _buildNotificationOption('Accessory', false),
                _buildNotificationOption('Other', false),
                
                SizedBox(height: 24),
                
                Divider(),
                
                SizedBox(height: 24),
                
                // View Results button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('View Results (All)'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationOption(String title, bool isChecked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Switch(value: isChecked, onChanged: (value) {}),
        ],
      ),
    );
  }
}
