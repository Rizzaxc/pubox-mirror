import 'package:flutter_test/flutter_test.dart';
import 'package:pubox/core/utils.dart';

void main() {
  group('StringExtension', () {
    group('removeDiacritics', () {
      test('should remove diacritics from Latin characters', () {
        expect('àáâãäå'.removeDiacritics(), equals('aaaaaa'));
        expect('èéêë'.removeDiacritics(), equals('eeee'));
        expect('ìíîï'.removeDiacritics(), equals('iiii'));
        expect('òóôõöø'.removeDiacritics(), equals('oooooo'));
        expect('ùúûü'.removeDiacritics(), equals('uuuu'));
        expect('ýÿ'.removeDiacritics(), equals('yy'));
        expect('ç'.removeDiacritics(), equals('c'));
        expect('ñ'.removeDiacritics(), equals('n'));
      });

      test('should remove diacritics from uppercase Latin characters', () {
        expect('ÀÁÂÃÄÅ'.removeDiacritics(), equals('AAAAAA'));
        expect('ÈÉÊË'.removeDiacritics(), equals('EEEE'));
        expect('ÌÍÎÏ'.removeDiacritics(), equals('IIII'));
        expect('ÒÓÔÕÖØ'.removeDiacritics(), equals('OOOOOO'));
        expect('ÙÚÛÜ'.removeDiacritics(), equals('UUUU'));
        expect('Ý'.removeDiacritics(), equals('Y'));
        expect('Ç'.removeDiacritics(), equals('C'));
        expect('Ñ'.removeDiacritics(), equals('N'));
      });

      test('should remove diacritics from Vietnamese characters', () {
        expect('ạảấầẩẫậắằẳẵặ'.removeDiacritics(), equals('aaaaaaaaaaaa'));
        expect('ẠẢẤẦẨẪẬẮẰẲẴẶ'.removeDiacritics(), equals('AAAAAAAAAAAA'));
        expect('ẹẻẽếềểễệ'.removeDiacritics(), equals('eeeeeeee'));
        expect('ẸẺẼẾỀỂỄỆ'.removeDiacritics(), equals('EEEEEEEE'));
        expect('ỉị'.removeDiacritics(), equals('ii'));
        expect('ỈỊ'.removeDiacritics(), equals('II'));
        expect('ọỏốồổỗộớờởỡợ'.removeDiacritics(), equals('ooooooooooo'));
        expect('ỌỎỐỒỔỖỘỚỜỞỠỢ'.removeDiacritics(), equals('OOOOOOOOOOO'));
        expect('ụủứừửữự'.removeDiacritics(), equals('uuuuuuu'));
        expect('ỤỦỨỪỬỮỰ'.removeDiacritics(), equals('UUUUUUU'));
        expect('ỳỵỷỹ'.removeDiacritics(), equals('yyyy'));
        expect('ỲỴỶỸ'.removeDiacritics(), equals('YYYY'));
        expect('đĐ'.removeDiacritics(), equals('dD'));
      });

      test('should handle mixed text correctly', () {
        expect('Xin chào thế giới!'.removeDiacritics(), equals('Xin chao the gioi!'));
        expect('VIỆT NAM'.removeDiacritics(), equals('VIET NAM'));
        expect('Đây là một câu tiếng Việt có dấu'.removeDiacritics(), 
               equals('Day la mot cau tieng Viet co dau'));
      });

      test('should not change ASCII characters', () {
        expect('Hello World!'.removeDiacritics(), equals('Hello World!'));
        expect('123456789'.removeDiacritics(), equals('123456789'));
        expect('!@#$%^&*()'.removeDiacritics(), equals('!@#$%^&*()'));
      });
    });
  });
}