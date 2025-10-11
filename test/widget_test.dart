// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// MyApp yerine artık MyAppWrapper'ı içe aktarmalıyız
import 'package:testapp/main.dart';

void main() {
  // Test, uygulamanın doğru yüklendiğini ve başlığı gösterdiğini doğrular.
  testWidgets('Uygulama basariyla yukleniyor ve Ana Sayfa basligi gorunuyor', (
    WidgetTester tester,
  ) async {
    // Uygulamanın ana widget'ını inşa et.
    await tester.pumpWidget(const MyAppWrapper());

    // Bir sonraki frame'i bekle (uygulama widget'larını yüklesin)
    await tester.pumpAndSettle();

    // 1. Ana Başlık Doğrulaması
    // AppBar'daki 'Hayvan Sahiplendirme' metnini ara.
    expect(find.text('Hayvan Sahiplendirme'), findsOneWidget);

    // 2. BottomNavigationBar Öğelerini Doğrulama
    // 'Ana Sayfa' ve 'Ara' etiketlerini ara.
    expect(find.text('Ana Sayfa'), findsOneWidget);
    expect(find.text('Ara'), findsOneWidget);

    // 3. FloatingActionButton (Pati İkonu) Doğrulaması
    // Ekleme butonu olarak kullandığımız Icons.pets ikonunu ara.
    expect(find.byIcon(Icons.pets), findsOneWidget);

    // Örnek: Ara butonuna tıklamayı simüle et
    await tester.tap(find.text('Ara'));
    await tester.pumpAndSettle(); // Yeni sayfaya geçişi bekle

    // Yeni sayfada arama çubuğunun varlığını doğrula (varsa)
    // Bu, arama sayfasının yüklendiğini gösterir.
    expect(find.byType(TextField), findsOneWidget);
  });
}
