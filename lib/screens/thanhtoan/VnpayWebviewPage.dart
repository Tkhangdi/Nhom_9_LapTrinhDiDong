import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class VnpayPaymentPage extends StatefulWidget {
  final String orderId;
  final int amount; // Đơn vị VND
  final String returnUrl;

  VnpayPaymentPage({
    required this.orderId,
    required this.amount,
    required this.returnUrl,
  });

  @override
  State<VnpayPaymentPage> createState() => _VnpayPaymentPageState();
}

class _VnpayPaymentPageState extends State<VnpayPaymentPage> {
  late final WebViewController _controller;

  final String vnpTmnCode = "ADCSZEF6";
  final String vnpHashSecret = "D7WZUIXG0ZXZZOF9XKBX6SJ6ASXVJFDJ";
  final String vnpUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (navRequest) {
                if (navRequest.url.startsWith(widget.returnUrl)) {
                  final uri = Uri.parse(navRequest.url);
                  final vnpResponseCode =
                      uri.queryParameters['vnp_ResponseCode'];
                  if (vnpResponseCode == "00") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Thanh toán thành công!")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Thanh toán không thành công!")),
                    );
                  }
                  Navigator.of(context).pop(true);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(_buildVnpayUrl()));
  }

  String _generateVnpaySecureHash(Map<String, String> params) {
    var sortedKeys = params.keys.toList()..sort();
    var rawData = sortedKeys.map((key) => "$key=${params[key]!}").join('&');

    var hmac = Hmac(sha256, utf8.encode(vnpHashSecret));
    var digest = hmac.convert(utf8.encode(rawData));
    return digest.toString();
  }

  String _buildVnpayUrl() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMddHHmmss');
    final createDate = formatter.format(now);

    Map<String, String> vnpParams = {
      "vnp_Version": "2.1.0",
      "vnp_Command": "pay",
      "vnp_TmnCode": vnpTmnCode,
      "vnp_Amount": (widget.amount * 100).toString(),
      "vnp_CurrCode": "VND",
      "vnp_TxnRef": widget.orderId,
      "vnp_OrderInfo": "Thanh toán đơn hàng ${widget.orderId}",
      "vnp_OrderType": "other",
      "vnp_Locale": "vn",
      "vnp_ReturnUrl": widget.returnUrl,
      "vnp_CreateDate": createDate,
    };

    String vnpSecureHash = _generateVnpaySecureHash(vnpParams);
    vnpParams["vnp_SecureHashType"] = "SHA256";
    vnpParams["vnp_SecureHash"] = vnpSecureHash;

    String queryString = vnpParams.entries
        .map((e) => "${e.key}=${Uri.encodeComponent(e.value)}")
        .join('&');
    print("$vnpUrl?$queryString");
    return "$vnpUrl?$queryString";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thanh toán VNPAY")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
