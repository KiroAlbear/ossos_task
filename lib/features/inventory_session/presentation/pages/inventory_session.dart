import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ossos_task/core/base/base_bloc.dart';
import 'package:ossos_task/core/base/base_bloc_state.dart';
import 'package:ossos_task/core/base/base_stateful_widget.dart';
import 'package:ossos_task/core/core.dart';
import 'package:ossos_task/core/routes/routes.dart';
import 'package:ossos_task/core/utils/product_utils.dart';
import 'package:ossos_task/features/inventory_session/inventory_session.dart';

import '../blocs/inventory_session_bloc.dart';
import '../blocs/inventory_session_state.dart';

class InventorySessionPage extends BaseStatefulWidget {
  const InventorySessionPage({super.key});

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color lightBlue = Color(0xFFEFF6FF);
  static const Color pageBg = Color(0xFFF5F7FB);
  static const Color darkText = Color(0xFF111827);
  static const Color greyText = Color(0xFF6B7280);
  static const Color orange = Color(0xFFF97316);
  static const Color lightOrange = Color(0xFFFFF7ED);

  @override
  State<InventorySessionPage> createState() => _InventorySessionPageState();
}

class _InventorySessionPageState
    extends BaseStatefullState<InventorySessionPage> {
  @override
  String? appBarTitle() => 'Product Count';

  @override
  String? appBarSubtitle() => 'Cairo Store';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!mounted) return;
      BlocProvider.of<InventorySessionBloc>(context)
          .add(getProductsCountEvent());
    });

    super.initState();
  }

  @override
  Widget getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        BaseBloc<InventorySessionBloc, BaseBlocState, ProductsProgressState>(
          showErrorToast: false,
          builder: (ProductsProgressState state) {
            if (state.isLoadingProgress && state.total == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return (state.counted > 0 && (state.total ?? 0) > 0)
                ? ActiveSessionCard(counted: state.counted, total: state.total!)
                : const SizedBox();
          },
        ),
        const SizedBox(height: 14),
        const QuickActionsCard(),
        BlocBuilder<InventorySessionBloc, BaseBlocState>(
          builder: (context, state) {
            if (state is! ProductsProgressState ||
                !state.hasSubmittedProducts) {
              return const SizedBox.shrink();
            }
            return const Padding(
              padding: EdgeInsets.only(top: 14),
              child: PendingSyncCard(),
            );
          },
        ),
      ],
    );
  }
}

class ActiveSessionCard extends StatefulWidget {
  final int counted;
  final int total;
  const ActiveSessionCard({
    super.key,
    required this.counted,
    required this.total,
  });

  @override
  State<ActiveSessionCard> createState() => _ActiveSessionCardState();
}

class _ActiveSessionCardState extends State<ActiveSessionCard> {
  @override
  Widget build(BuildContext context) {
    final counted = widget.counted;
    final total = widget.total;
    final double progress = counted / total;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: InventorySessionPage.primaryBlue,
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Active Session',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: InventorySessionPage.darkText,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.more_horiz_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'September Count Session',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: InventorySessionPage.darkText,
                  ),
                ),
              ),
              StatusChip(
                icon: Icons.description_outlined,
                label: 'Draft',
                backgroundColor: Color(0xFFF3F4F6),
                textColor: Color(0xFF374151),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '$counted / $total products counted',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: InventorySessionPage.darkText,
                ),
              ),
              Spacer(),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: InventorySessionPage.greyText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(
                InventorySessionPage.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const InfoRow(
            icon: Icons.access_time_rounded,
            text: 'Last saved: 05:42 PM',
          ),
          const SizedBox(height: 8),
          const InfoRow(
            icon: Icons.person_outline_rounded,
            text: 'Employee: Ahmed Samy',
          ),
          const SizedBox(height: 8),
          const InfoRow(
            icon: Icons.cloud_done_outlined,
            text: 'Sync status: Saved locally',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Routes.navigateToScreen(
                      Routes.productsScreen,
                      NavigationType.pushNamed,
                      context,
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Resume Counting'),
                  style: FilledButton.styleFrom(
                    backgroundColor: InventorySessionPage.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            icon: Icons.flash_on_rounded,
            title: 'Quick Actions',
            iconBackground: InventorySessionPage.lightBlue,
            iconColor: InventorySessionPage.primaryBlue,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ActionTile(
                  icon: Icons.add_circle_rounded,
                  title: 'Start New\nSession',
                  onTap: () async {
                    final Map<int, int> products = await ProductUtils()
                        .getProductsSharedPrefrences();
                    if (products.isEmpty) {
                      Routes.navigateToScreen(
                        Routes.productsScreen,
                        NavigationType.pushNamed,
                        context,
                      );
                    } else {
                      AppUtils.showAppToast(
                        context: context,
                        message: "You have session in progress",
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ActionTile(
                  icon: Icons.assignment_rounded,
                  title: 'Submitted\nSessions',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PendingSyncCard extends StatelessWidget {
  const PendingSyncCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              SectionTitle(
                icon: Icons.cloud_upload_outlined,
                title: 'Pending Synchronization',
                iconBackground: InventorySessionPage.lightOrange,
                iconColor: InventorySessionPage.orange,
              ),
              Spacer(),
              StatusChip(
                icon: Icons.access_time_rounded,
                label: 'Pending Sync',
                backgroundColor: InventorySessionPage.lightOrange,
                textColor: InventorySessionPage.orange,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 session waiting to sync',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: InventorySessionPage.darkText,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Last updated: 05:42 PM',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: InventorySessionPage.greyText,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.sync_rounded, size: 18),
                label: const Text('Sync Now'),
                style: FilledButton.styleFrom(
                  backgroundColor: InventorySessionPage.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppCard extends StatelessWidget {
  final Widget child;

  const AppCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconBackground;
  final Color iconColor;

  const SectionTitle({
    super.key,
    required this.icon,
    required this.title,
    required this.iconBackground,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: iconBackground,
          child: Icon(icon, color: iconColor, size: 17),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: InventorySessionPage.darkText,
          ),
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: InventorySessionPage.darkText),
        const SizedBox(width: 9),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12.5,
            color: InventorySessionPage.greyText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const StatusChip({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: InventorySessionPage.lightBlue,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 78,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: InventorySessionPage.primaryBlue, size: 24),
              const SizedBox(height: 7),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: InventorySessionPage.darkText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
