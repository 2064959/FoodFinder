# FoodFinder

**FoodFinder** is an innovative mobile application designed to simplify and enhance the grocery shopping experience for users. Whether you're planning your weekly meals, managing a household budget, or aiming to reduce food waste, FoodFinder offers a comprehensive set of features to meet your needs.

## **Key Features**

1. **User Registration and Authentication**
   - Secure user accounts with email/password authentication.
   - Option for social media logins for quick access.

2. **Grocery List Management**
   - **Create and Edit Lists:** Easily create multiple grocery lists for different purposes (e.g., weekly shopping, parties).
   - **Categorization:** Organize items by categories such as Produce, Dairy, Bakery, etc., for streamlined shopping.
   - **Prioritization:** Mark items as essential or optional to prioritize your purchases.

3. **Barcode Scanning**
   - **Product Identification:** Use your device's camera to scan barcodes, automatically fetching product details like name, price, and nutritional information via an external API.
   - **Automatic Addition:** Quickly add scanned items to your grocery list without manual entry.

4. **Shared Shopping Groups**
   - **Collaborative Lists:** Create and manage shared grocery lists with family members or roommates, allowing multiple users to add or remove items in real-time.
   - **Notifications:** Receive updates when changes are made to shared lists, ensuring everyone stays informed.

5. **Purchase Tracking**
   - **History Log:** Keep a record of past purchases to track spending habits and frequently bought items.
   - **Analytics:** Generate reports and insights on your grocery spending and shopping frequency.

6. **Offline Capabilities**
   - **Access Anywhere:** Manage your grocery lists and view stored data even without an internet connection.
   - **Sync When Online:** Automatically sync data once the device reconnects to the internet, ensuring all information is up-to-date.

7. **Integration with External APIs**
   - **Product Details:** Leverage third-party APIs to retrieve detailed information about scanned products, including images, descriptions, and reviews.
   - **Price Comparison:** Compare prices of items across different stores to find the best deals.

## **Technologies Used**

- **Frontend:**
  - **Dart & Flutter:** For building a responsive and cross-platform mobile application.
- **Backend:**
  - **C++:** Handling performance-intensive tasks and ensuring smooth operation.
  - **Firebase:** Managing user authentication, real-time database, and cloud storage.
- **APIs:**
  - **Barcode Scanning API:** For accurate and efficient barcode recognition and product information retrieval.

## **Project Structure**

- **Modular Codebase:** Organized into distinct modules for authentication, list management, barcode scanning, and more, facilitating easy maintenance and scalability.
- **Version Control:** Utilizes Git for tracking changes and collaboration, hosted on GitHub for transparency and community engagement.
- **Documentation:** Comprehensive documentation is provided, including setup guides, API references, and contribution guidelines to assist developers and contributors.

## **Future Enhancements**

- **Recipe Integration:** Suggest recipes based on items in your grocery list to inspire meal planning.
- **Budgeting Tools:** Allow users to set and monitor grocery budgets, providing alerts when nearing limits.
- **Store Locator:** Help users find nearby grocery stores with the best prices and availability for their listed items.
- **Voice Commands:** Enable hands-free list management through voice recognition technology.


**FoodFinder** aims to make grocery shopping more organized, efficient, and enjoyable by leveraging modern technologies and user-centric design. Whether you're a solo shopper or managing a household, FoodFinder has the tools to support your grocery needs.
  
## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/2064959/FoodFinder.git
   cd FoodFinder
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

## Usage

1. **Create an account** or log in with your credentials.
2. **Create a grocery list**, scan items, and track purchase history.
3. **Invite others** to your group to share lists and manage groceries together.
4. Use **offline mode** for shopping without internet access.

## Contributing

Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/YourFeature`.
3. Commit your changes: `git commit -m 'Add feature'`.
4. Push to the branch: `git push origin feature/YourFeature`.
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

This README provides a clear overview of the project, its features, and how to get started. Let me know if you'd like to add or modify anything!
