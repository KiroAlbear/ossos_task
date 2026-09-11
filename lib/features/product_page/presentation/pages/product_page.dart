import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:ossos_task/imports.dart';

import '../../../inventory_session/presentation/blocs/inventory_session_bloc.dart';
import '../../../inventory_session/presentation/blocs/inventory_session_event.dart';

/// Counts are saved per store. Supply callbacks to connect submission/scanning
/// and image/status maps when these are available from the inventory service.
class ProductPage extends BaseStatefulWidget {
  final String storeName;
  final String storeId;

  final Map<int, String> imageUrls;
  final Map<int, ProductCountStatus> statuses;
  final Future<void> Function(Map<int, int> counts)? onSubmit;
  final Future<String?> Function()? onScan;

  const ProductPage({
    super.key,
    this.storeName = 'Cairo Store',
    this.storeId = 'cairo',
    this.imageUrls = const {},
    this.statuses = const {},
    this.onSubmit,
    this.onScan,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends BaseStatefullState<ProductPage> {
  static const _blue = Color(0xFF0074F5);
  static const _muted = Color(0xFF728098);
  static const _border = Color(0xFFE6EAF0);
  static const _pageSize = 10;
  final _scroll = ScrollController();
  final _search = TextEditingController();
  final _productCountsMap = <int, int>{};
  final _savedProductsCountsMap = <int, int>{};
  final _editedIds = <int>{};
  final _uiVersion = ValueNotifier<int>(0);
  final _controllers = <int, TextEditingController>{};
  int _page = 0;
  int? _total;
  bool _hasMore = true;
  bool _loading = false;
  bool _restoring = true;
  bool _submitting = false;
  String? _error;
  String? _storageError;
  void _refresh() => _uiVersion.value++;


  @override
  void onPopInvoked(bool didPop) {
    BlocProvider.of<InventorySessionBloc>(context).add(getProductsCountEvent('cairo'));
    super.onPopInvoked(didPop);
  }

  @override
  void initState() {
    super.initState();

    // Subscribe to the Bloc before the first request can finish.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      BlocProvider.of<ProductPageBloc>(context).add(
        RestoreProductCountsEvent(widget.storeId),
      );
      _loadMore();
    });
  }

  void _loadMore() {
    if (_loading || !_hasMore) return;
    _loading = true;
    _error = null;
    _refresh();
    BlocProvider.of<ProductPageBloc>(context).add(LoadProductsEvent(page: _page + 1, limit: _pageSize));
  }

  void _receive(BuildContext context, BaseBlocState state) {
    if (state is ProductPageState) {
      final didRestore = _restoring && !state.isRestoring;
      final previousCounts = Map<int, int>.of(_productCountsMap);
      final previousSavedCounts = Map<int, int>.of(_savedProductsCountsMap);
      if (didRestore) {
        _productCountsMap
          ..clear()
          ..addAll(state.restoredProductsCountsMap);
        _savedProductsCountsMap
          ..clear()
          ..addAll(state.restoredProductsCountsMap);
        _storageError = state.restoreError;
        _restoring = false;
      }
      _productCountsMap
        ..clear()
        ..addAll(state.productCountsMap);
      _savedProductsCountsMap
        ..clear()
        ..addAll(state.savedProductsCountsMap);
      _storageError = state.storageError ?? state.restoreError;
      _page = state.page;
      _hasMore = state.hasNextPage;
      _total = state.productPage.totalItems ?? (_hasMore ? null : state.products.length);
      _loading = state.isLoading;
      _error = state.errorMessage;
      _refresh();
      final countsChanged = previousCounts.length != _productCountsMap.length ||
          previousCounts.entries.any((entry) => _productCountsMap[entry.key] != entry.value);
      final savedCountsChanged = previousSavedCounts.length != _savedProductsCountsMap.length ||
          previousSavedCounts.entries.any((entry) => _savedProductsCountsMap[entry.key] != entry.value);
      if (didRestore || countsChanged || savedCountsChanged) {
        _updateCountFilters();
      }
      _fillViewport();
    } else if (state is ErrorState) {
      _loading = false;
      _error = state.errorMessage ?? 'Unable to load products.';
      _refresh();
    }
  }

  void _fillViewport() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _error != null || !_scroll.hasClients) return;
      if (_scroll.position.maxScrollExtent <= 0) {
        _loadMore();
      }
    });
  }

  void _changeProductCount(int id, String value) {
    _editedIds.add(id);
    BlocProvider.of<ProductPageBloc>(context).add(
      ChangeProductCountEvent(
        storeId: widget.storeId,
        productId: id,
        value: value,
      ),
    );
  }

  ProductCountStatus? _status(int id) {
    if (_productCountsMap.containsKey(id)) {
      if (_savedProductsCountsMap[id] != _productCountsMap[id]) return null;
      return _editedIds.contains(id)
          ? ProductCountStatus.savedLocally
          : widget.statuses[id] ?? ProductCountStatus.savedLocally;
    }
    return _editedIds.contains(id) ? null : widget.statuses[id];
  }

  void _updateCountFilters() {
    final ids = {...widget.statuses.keys, ..._productCountsMap.keys, ..._editedIds};
    BlocProvider.of<ProductPageBloc>(context).add(
      UpdateProductCountFiltersEvent(
        countedIds: _productCountsMap.keys.toSet(),
        statuses: {for (final id in ids) id: _status(id)},
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ProductPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateCountFilters();
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.create(
            context,
            fontSize: 14,
            color: Colors.white,
          ),
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    _submitting = true;
    _refresh();
    try {
      await BlocProvider.of<ProductPageBloc>(context).flushSaves();
      if (!mounted) return;
      if (_storageError != null) {
        _message(_storageError!);
        return;
      }
      if (widget.onSubmit == null) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Count saved locally',
              style: AppTextStyles.create(
                context,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              '${_productCountsMap.length} product counts are saved on this device. Server submission is not connected yet.',
              style: AppTextStyles.create(context, fontSize: 14),
              overflow: TextOverflow.visible,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Done',
                  style: AppTextStyles.create(
                    context,
                    fontSize: 14,
                    color: _blue,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        await widget.onSubmit!(Map<int, int>.unmodifiable(_productCountsMap));
        if (mounted) _message('Count submitted.');
      }
    } catch (_) {
      if (mounted) {
        _message('Unable to submit. Your local counts are retained.');
      }
    } finally {
      if (mounted) {
        _submitting = false;
        _refresh();
      }
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }

    _uiVersion.dispose();
    super.dispose();
  }

  @override
  String? appBarTitle() => 'Product Count';

  @override
  String? appBarSubtitle() => widget.storeName;

  @override
  Widget? customBottomNavBar() => _footer();

  @override
  Widget getBody(BuildContext context) {
    return BaseBloc<ProductPageBloc, BaseBlocState, ProductPageState>(
        listener: _receive,
        loadingWidget: const CircularProgressIndicator(color: _blue),
        errorWidget: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error ?? 'Unable to load products.',
                style: AppTextStyles.create(
                  context,
                  fontSize: 14,
                  color: _muted,
                ),
              ),
              TextButton(
                onPressed: _loadMore,
                child: Text(
                  'Retry',
                  style: AppTextStyles.create(
                    context,
                    fontSize: 14,
                    color: _blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        builder: (state) => Column(
          children: [
            _offlineBanner(),
            const SizedBox(height: 9),
            _searchField(),
            const SizedBox(height: 8),
            _filters(state),
            const SizedBox(height: 8),
            Expanded(child: _list(state)),
          ],
        ),
      );

  }

  Widget _offlineBanner() => Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: const Color(0xFFE7F2FF),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Icon(Icons.cloud_off_outlined, color: _blue, size: 21),
        SizedBox(width: 12),
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: _uiVersion,
            builder: (_, __, ___) => Text(
            _storageError ?? 'Offline mode — changes are saved locally',
            style: AppTextStyles.create(
              context,
              fontSize: 11.5,
              color: _storageError == null
                  ? const Color(0xFF005BCD)
                  : Colors.red,
              fontWeight: FontWeight.w600,
            ),
            ),
          ),
        ),
        SizedBox(
          width: 30,
          height: 24,
          child: IconButton(
            padding: EdgeInsets.zero,
            tooltip: 'About offline counts',
            icon: Icon(Icons.info_outline, color: _blue, size: 18),
            onPressed: () => _message(
              'Counts are stored on this device for ${widget.storeName}.',
            ),
          ),
        ),
      ],
    ),
  );

  Widget _searchField() => TextField(
    controller: _search,
    style: AppTextStyles.create(context, fontSize: 13),
    onChanged: (query) => BlocProvider.of<ProductPageBloc>(context).add(SearchProductsEvent(query)),
    decoration: InputDecoration(
      hintText: 'Search by product name, SKU, barcode',
      hintStyle: AppTextStyles.create(context, fontSize: 12.5, color: _muted),
      filled: true,
      fillColor: const Color(0xFFF2F4F7),
      contentPadding: EdgeInsets.symmetric(vertical: 13),
      prefixIcon: Icon(Icons.search, color: const Color(0xFF526075), size: 25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _blue),
      ),
    ),
  );

  Widget _filters(ProductPageState state) {
    final labels = [
      'All (${_total ?? state.products.length})',
      'Counted (${state.countedCount})',
      'Not Counted (${state.notCountedCount})',
      'Conflicts (${state.conflictCount})',
    ];
    const icons = [
      null,
      Icons.check_circle,
      Icons.access_time,
      Icons.warning_amber_rounded,
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(ProductCountFilter.values.length, (index) {
          final selected = state.filter == ProductCountFilter.values[index];
          return Padding(
            padding: EdgeInsets.only(right: 7),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: selected ? _blue : const Color(0xFFF0F3F6),
                foregroundColor: selected ? Colors.white : _muted,
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              onPressed: () {
                BlocProvider.of<ProductPageBloc>(context).add(
                  FilterProductsEvent(ProductCountFilter.values[index]),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icons[index] != null) ...[
                    Icon(icons[index], size: 18),
                    SizedBox(width: 6),
                  ],
                  Text(
                    labels[index],
                    style: AppTextStyles.create(
                      context,
                      fontSize: 11,
                      color: selected ? Colors.white : _muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _list(ProductPageState state) {
    if (_restoring || (state.products.isEmpty && _loading)) {
      return const Center(child: CircularProgressIndicator(color: _blue));
    }
    final visible = state.filteredProducts;
    return LazyLoadScrollView(
      isLoading: _loading || !_hasMore || _error != null,
      scrollOffset: 220,
      onEndOfPage: () {
        if (_error == null) _loadMore();
      },
      child: ListView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: visible.length + 1,
        itemBuilder: (context, index) {
          if (index < visible.length) return _card(visible[index]);
          return Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              children: [
                if (_loading)
                  const CircularProgressIndicator(color: _blue)
                else if (_error != null) ...[
                  Text(
                    _error!,
                    style: AppTextStyles.create(
                      context,
                      fontSize: 12,
                      color: _muted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: _loadMore,
                    child: Text(
                      'Retry',
                      style: AppTextStyles.create(
                        context,
                        fontSize: 14,
                        color: _blue,
                      ),
                    ),
                  ),
                ] else if (visible.isEmpty)
                  Text(
                    'No products found.',
                    style: AppTextStyles.create(
                      context,
                      fontSize: 13,
                      color: _muted,
                    ),
                  )
                else if (!_hasMore)
                  Text(
                    'All products loaded',
                    style: AppTextStyles.create(
                      context,
                      fontSize: 11,
                      color: _muted,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _card(ProductModel product) {
    final controller = _controllers.putIfAbsent(
      product.id,
      () => TextEditingController(text: _productCountsMap[product.id]?.toString() ?? ''),
    );
    final count = _productCountsMap[product.id];
    final difference = count == null ? null : count - product.systemQuantity;
    final imageUrl = widget.imageUrls[product.id];
    final thumbnail = Icon(Icons.inventory_2_outlined, color: _muted, size: 32);
    return Container(
      key: ValueKey(product.id),
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F263E),
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 60,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: imageUrl == null
                    ? thumbnail
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, error, stack) => thumbnail,
                      ),
              ),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: AppTextStyles.create(
                              context,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        _badge(product.id),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            tooltip: 'Product actions',
                            icon: Icon(
                              Icons.more_horiz,
                              color: _muted,
                              size: 22,
                            ),
                            onSelected: (_) {
                              controller.clear();
                              _changeProductCount(product.id, '');
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                value: 'clear',
                                enabled: count != null,
                                child: Text(
                                  'Clear count',
                                  style: AppTextStyles.create(
                                    context,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    _detail('SKU', product.sku),
                    SizedBox(height: 3),
                    _detail('Barcode', product.barcode),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Qty',
                        style: AppTextStyles.create(
                          context,
                          fontSize: 10,
                          color: _muted,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${product.systemQuantity}',
                        style: AppTextStyles.create(
                          context,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                _divider(),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Counted Qty',
                          style: AppTextStyles.create(
                            context,
                            fontSize: 10,
                            color: _muted,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          enabled: !_submitting,
                          style: AppTextStyles.create(context, fontSize: 12),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          onChanged: (value) => _changeProductCount(product.id, value),
                          decoration: InputDecoration(
                            hintText: '—',
                            hintStyle: AppTextStyles.create(
                              context,
                              fontSize: 12,
                              color: _muted,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color(0xFFB5C1D2),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color(0xFFB5C1D2),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: _blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _divider(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Difference',
                        style: AppTextStyles.create(
                          context,
                          fontSize: 10,
                          color: _muted,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        difference == null
                            ? '—'
                            : difference > 0
                            ? '+$difference'
                            : '$difference',
                        style: AppTextStyles.create(
                          context,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: difference == null || difference == 0
                              ? const Color(0xFF536076)
                              : difference < 0
                              ? const Color(0xFFE00027)
                              : const Color(0xFF009759),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail(String label, String value) => Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: '$label   ',
          style: AppTextStyles.create(context, fontSize: 11, color: _muted),
        ),
        TextSpan(
          text: value,
          style: AppTextStyles.create(
            context,
            fontSize: 11,
            color: const Color(0xFF354057),
          ),
        ),
      ],
    ),
  );

  Widget _divider() => Container(
    width: 1,
    height: 28,
    margin: EdgeInsets.symmetric(horizontal: 11),
    color: _border,
  );

  Widget _badge(int id) {
    final status = _status(id);
    final (label, color, background, icon) = switch (status) {
      ProductCountStatus.savedLocally => (
        'Saved locally',
        _blue,
        const Color(0xFFE2EFFF),
        Icons.description_outlined,
      ),
      ProductCountStatus.pendingSync => (
        'Pending sync',
        const Color(0xFFD77900),
        const Color(0xFFFFF0D7),
        Icons.access_time,
      ),
      ProductCountStatus.conflict => (
        'Conflict',
        const Color(0xFFE00027),
        const Color(0xFFFFE5E9),
        Icons.warning_amber_rounded,
      ),
      ProductCountStatus.synced => (
        'Synced',
        const Color(0xFF009454),
        const Color(0xFFDDF4E9),
        Icons.check_circle,
      ),
      null => (
        _productCountsMap.containsKey(id)
            ? (_storageError == null ? 'Saving…' : 'Not saved')
            : 'Not counted',
        _muted,
        const Color(0xFFF0F3F6),
        Icons.access_time,
      ),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.create(
              context,
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C1D334B),
            blurRadius: 18,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: _blue, size: 28),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: _uiVersion,
                    builder: (_, __, ___) => Text.rich(
                      TextSpan(
                      children: [
                        TextSpan(
                          text: '${_productCountsMap.length} / ${_total ?? '…'} ',
                          style: AppTextStyles.create(
                            context,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: 'products counted',
                          style: AppTextStyles.create(context, fontSize: 10.5),
                        ),
                      ],
                      ),
                    ),
                  ),
                  SizedBox(height: 7),
                  ValueListenableBuilder<int>(
                    valueListenable: _uiVersion,
                    builder: (_, __, ___) => ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: _total == null || _total == 0
                            ? 0.0
                            : (_productCountsMap.length / _total!).clamp(0.0, 1.0),
                        minHeight: 7,
                        color: _blue,
                        backgroundColor: const Color(0xFFE1E6EE),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            ValueListenableBuilder<int>(
              valueListenable: _uiVersion,
              builder: (_, __, ___) => ElevatedButton.icon(
                onPressed: _productCountsMap.isEmpty || _restoring || _submitting
                    ? null
                    : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              icon: _submitting
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(Icons.send_outlined, size: 22),
              label: Text(
                'Submit Count',
                style: AppTextStyles.create(
                  context,
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
