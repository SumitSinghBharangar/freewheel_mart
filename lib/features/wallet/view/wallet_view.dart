import 'package:flutter/material.dart';
import 'package:freewheel_mart/features/auth/provider/auth_provider.dart';
import 'package:freewheel_mart/features/wallet/data/transection_model.dart';
import 'package:freewheel_mart/features/wallet/provider/wallet_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  void _showTopUpModal(
    BuildContext context,
    AuthProvider auth,
    WalletProvider wallet,
  ) {
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff242C3B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Top-Up Account",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter amount (\$)",
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4B4CED),
                ),
                onPressed: () async {
                  final double? val = double.tryParse(amountController.text);
                  if (val != null && val > 0) {
                    await wallet.depositFunds(authProvider: auth, amount: val);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child: const Text(
                  "CONFIRM DEPOSIT",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    final user = authProvider.currentUserModel;

    final String displayBalance = user?.balance ?? "0.00";

    return Scaffold(
      backgroundColor: const Color(0xff1A1A1A),
      appBar: AppBar(
        title: Text(
          "Digital Wallet",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // --- 1. PREMIUM CREDIT CARD HUD DISPLAY ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff353F54), Color(0xff222834)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "VeloHub token card",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      const Icon(
                        Icons.blur_on_rounded,
                        color: Color(0xff4B4CED),
                        size: 32,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "AVAILABLE BALANCE",
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$$displayBalance",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight(600),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user?.name.toUpperCase() ?? "RIDER MEMBER",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () => _showTopUpModal(
                          context,
                          authProvider,
                          walletProvider,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // --- 2. HISTORICAL RECORD TRANSACTIONS ---
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xff242C3B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                    child: Text(
                      "Transaction Log",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<List<TransactionModel>>(
                      stream: walletProvider.streamTransactions(
                        user?.uid ?? '',
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xff4B4CED),
                            ),
                          );
                        }
                        final txs = snapshot.data ?? [];
                        if (txs.isEmpty) {
                          return const Center(
                            child: Text(
                              "No transaction logs recorded yet.",
                              style: TextStyle(color: Colors.white38),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: txs.length,
                          padding: const EdgeInsets.only(bottom: 100),
                          itemBuilder: (context, index) {
                            final tx = txs[index];
                            final bool isDeposit =
                                tx.type == TransactionType.deposit;

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isDeposit
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                child: Icon(
                                  isDeposit
                                      ? Icons.arrow_downward_rounded
                                      : Icons.arrow_upward_rounded,
                                  color: isDeposit ? Colors.green : Colors.red,
                                  size: 18,
                                ),
                              ),
                              title: Text(
                                tx.description,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat(
                                  'dd MMM yyyy, hh:mm a',
                                ).format(tx.timestamp),
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                ),
                              ),
                              trailing: Text(
                                "${isDeposit ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: isDeposit
                                      ? Colors.green
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
