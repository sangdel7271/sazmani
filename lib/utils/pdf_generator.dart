import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/fighter.dart';
import '../models/payment.dart';

class PdfGenerator {
  static Future<void> generateReceipt({
    required Fighter fighter,
    required Payment payment,
    required String cityName,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  color: PdfColors.blue900,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('رسید پرداخت حقوق',
                          style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold)),
                      pw.Text('حسابداری سازمان',
                          style: pw.TextStyle(
                              color: PdfColors.amber, fontSize: 16)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                _buildInfoRow('نام مبارز:', fighter.fullName),
                _buildInfoRow('شهر:', cityName),
                _buildInfoRow('تاریخ پرداخت:', payment.paymentDate.toString()),
                _buildInfoRow('ماه:', '${payment.month}/${payment.year}'),
                pw.Divider(),
                pw.Text('جزئیات پرداخت',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                _buildInfoRow('کل حقوق:', '${payment.totalSalary} روپیه'),
                _buildInfoRow('مبلغ پرداختی:', '${payment.paidAmount} روپیه'),
                _buildInfoRow('کسر بدهی:', '${payment.debtDeducted} روپیه'),
                _buildInfoRow(
                    'بدهی باقیمانده:', '${payment.remainingDebt} روپیه'),
                pw.Divider(),
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  color: PdfColors.grey200,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('مبلغ نهایی پرداختی:',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold)),
                      pw.Text('${payment.paidAmount} روپیه',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Text(label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(width: 8),
          pw.Text(value),
        ],
      ),
    );
  }
}
