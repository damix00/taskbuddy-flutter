import 'package:taskbuddy/utils/validators.dart';
import 'package:test/test.dart';

void main() {
  group('e-mail validation', () {
    var validEmails = [
      "john.doe@example.co.uk",
      "jane_doe123@example-domain.com",
      "bob.smith+work@example.com",
      "info@subdomain.example.org",
      "support@123-website.io",
      "user.name@example.travel",
      "sales@company-name.co",
      "jenny_2022@example.email",
      "1234567890@example.com",
      "email+with_plus@gmail.com",
      "contact@very-long-domain-name-with-many-characters-for-example.com",
    ];

    var invalidEmails = [
      "user@example",
      "@example.com",
      "john@doe@company.com",
      "jane.doe@example..com",
      "user@-example.com",
      "user@example_domain.com",
      "user name@example.com",
      "user@com",
      "user@[IPv6:2001:db8:1::2]",
    ];

    test('Confirm valid E-Mails', () {
      for (var email in validEmails) {
        expect(Validators.isEmailValid(email), true);
      }
    });

    test('Detect invalid E-Mails', () {
      for (var email in invalidEmails) {
        expect(Validators.isEmailValid(email), false);
      }
    });
  });

  group('phone number validation', () {
    var validNumbers = [
      "+1 555 555 5555",
      "+1 (555) 555 5555",
      "+1-555-555-5555",
      "+1.555.555.5555",
      "+1 555-555-5555",
      "+1 (555) 555-5555",
      "+1-555-555-5555",
      "+15555555555",
      "1800 801 920"
    ];

    var invalidNumbers = [
      "555 555 5555",
      "555-555-5555",
      "5555555555",
      "55555555555",
      "555555555555",
      "5555555555555",
      "55555555555555",
      "555555555555555",
      "5555555555555555",
      "55555555555555555",
      "555555555555555555",
      "5555555555555555555",
      "55555555555555555555",
      "555555555555555555555",
      "5555555555555555555555",
      "55555555555555555555555",
      "555555555555555555555555",
      "5555555555555555555555555",
      "55555555555555555555555555",
      "555555555555555555555555555",
      "5555555555555555555555555555",
      "55555555555555555555555555555"
    ];

    test('Confirm valid phone numbers', () {
      for (var number in validNumbers) {
        expect(Validators.validatePhoneNumber(number), true);
      }
    });
  });
}
