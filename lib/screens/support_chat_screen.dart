import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          'Hi, I am Foodie AI Support. Ask me about refunds, order cancellation, bookings, payment, delivery, login, or account help.',
      isUser: false,
    ),
  ];

  static const List<String> _quickTopics = [
    'Refund',
    'Cancel order',
    'Booking help',
    'Payment failed',
    'Delivery time',
    'Login issue',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? preset]) {
    final text = (preset ?? _messageController.text).trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _messages.add(_ChatMessage(text: _replyFor(text), isUser: false));
    });

    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _replyFor(String input) {
    final query = input.toLowerCase();

    if (_containsAny(query, [
      'refund',
      'money back',
      'return payment',
      'refund status',
    ])) {
      return 'Refund help: if an order was cancelled before preparation, the refund should be processed to the original payment method. If the food was incorrect or missing, raise the issue from Order History and include the order number. Typical refund review time is 3 to 7 working days.';
    }

    if (_containsAny(query, [
      'cancel',
      'cancel order',
      'stop order',
      'remove order',
    ])) {
      return 'Order cancellation help: orders can usually be cancelled before the restaurant starts preparing them. Open Order History, choose the latest order, and request cancellation. If preparation has already started, only a partial or support-reviewed cancellation may be possible.';
    }

    if (_containsAny(query, [
      'booking',
      'table',
      'seat',
      'reservation',
      'book seat',
    ])) {
      return 'Booking help: go to the booking section, choose the hotel, confirm the date/time slot, and review seat count before final confirmation. If a booking is already placed, check Booking History for the saved record.';
    }

    if (_containsAny(query, [
      'payment',
      'paid',
      'upi',
      'card',
      'transaction',
      'payment failed',
    ])) {
      return 'Payment help: if payment failed but money was deducted, first wait a few minutes and check Order History. If no order appears, treat it as a failed transaction and request payment support with the transaction time and amount. If the order exists, the payment is usually already linked to that order.';
    }

    if (_containsAny(query, [
      'delivery',
      'late',
      'time',
      'where is my order',
      'track order',
    ])) {
      return 'Delivery help: the home screen shows estimated delivery details at dish level, while placed orders appear in Order History. If delivery is delayed unusually, contact support with the order number and expected delivery time shown when the order was placed.';
    }

    if (_containsAny(query, [
      'login',
      'sign in',
      'google',
      'email',
      'password',
      'account',
    ])) {
      return 'Login help: use Google sign-in for account picker based login, or Continue with Email for email/password access. If login does not continue, restart the app and retry. If you forgot your password, update it from your profile after signing in through a working method.';
    }

    if (_containsAny(query, [
      'location',
      'address',
      'gps',
      'current location',
    ])) {
      return 'Location help: during onboarding, choose manual address entry or GPS-based setup. For GPS mode, enable location permission and then add your house or building number to complete the address.';
    }

    if (_containsAny(query, [
      'contact',
      'support',
      'help',
      'complaint',
    ])) {
      return 'Support help: for order, refund, booking, payment, or login issues, keep your account email or phone plus order or booking details ready. You can also review Order History and Booking History first before raising a complaint.';
    }

    return 'I can help with refunds, cancellations, bookings, payments, delivery, login, account, and location setup. Try asking something like "How do I get a refund?" or tap one of the quick topics.';
  }

  bool _containsAny(String query, List<String> tokens) {
    for (final token in tokens) {
      if (query.contains(token)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Foodie AI Support',
          style: AppTextStyles.h4.copyWith(color: AppColors.onPrimary),
        ),
        backgroundColor: AppColors.ink,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _quickTopics
                      .map(
                        (topic) => ActionChip(
                          onPressed: () => _sendMessage(topic),
                          avatar: const Icon(
                            Icons.bolt_rounded,
                            size: 18,
                            color: AppColors.ink,
                          ),
                          backgroundColor: AppColors.accent,
                          side: const BorderSide(color: AppColors.accent),
                          label: Text(
                            topic,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.ink,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _ChatBubble(message: message);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.creamDark)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 3,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Ask about refund, booking, payment...',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: _sendMessage,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.ink,
                      foregroundColor: AppColors.cream,
                    ),
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;

  const _ChatMessage({
    required this.text,
    required this.isUser,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final align = message.isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = message.isUser ? AppColors.ink : AppColors.surface;
    final textColor = message.isUser ? AppColors.cream : AppColors.textPrimary;

    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            border: message.isUser
                ? null
                : Border.all(color: AppColors.creamDark),
          ),
          child: Text(
            message.text,
            style: AppTextStyles.bodyMedium.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
