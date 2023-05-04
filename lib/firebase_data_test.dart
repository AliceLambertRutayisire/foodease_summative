import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('Firestore Tests', () {
    final mockFirestore = MockFirestore();
    final mockVendorDocumentReference = MockDocumentReference();
    final mockMenuCollectionReference = MockCollectionReference();
    final mockQuerySnapshot = MockQuerySnapshot();
    final mockDocumentSnapshot = MockDocumentSnapshot();

    test('fetches menu data from Firestore', () async {
      // Define the data to be returned when Firestore is called
      final expectedData = [
        {'name': 'Tacos', 'price': 1500},
        {'name': 'Burger', 'price': 2500},
        {'name': 'Coffee', 'price': 2500},
      ];
      when(mockQuerySnapshot.docs).thenReturn([mockDocumentSnapshot, mockDocumentSnapshot, mockDocumentSnapshot]);
      when(mockDocumentSnapshot.data()).thenReturn(expectedData[0]);
      when(mockMenuCollectionReference.get()).thenAnswer((_) async => mockQuerySnapshot);
      when(mockVendorDocumentReference.collection('menu')).thenReturn(mockMenuCollectionReference as CollectionReference<Map<String, dynamic>>);
      when(mockFirestore.doc('vendors/vendorId')).thenReturn(mockVendorDocumentReference as DocumentReference<Map<String, dynamic>>);

      // Call the getMenu() function and wait for the data to be returned
      final menu = await getMenu(mockFirestore, 'vendorId');

      // Verify that the data returned matches the expected data
      expect(menu, expectedData);
    });
  });
}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String, dynamic>> {
  @override
  Map<String, dynamic> data() {
    return {};
  }

  @override
  String? get documentID {
    return '';
  }

  // @override
  // DocumentReference<Map<String, dynamic>> get reference {
  //   return MockDocumentReference();
  // }
}
Future<List<Map<String, dynamic>>> getMenu(FirebaseFirestore firestore, String vendorId) async {
  final menuSnapshot = await firestore.doc('vendor/$vendorId').collection('menu').get();
  final menuDocs = menuSnapshot.docs;
  final menu = menuDocs.map((doc) => doc.data()).toList();
  return menu;
}
