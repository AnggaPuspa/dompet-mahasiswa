import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/pages/kategori_form_page.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_radius.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_assets.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/color_helper.dart';
import 'package:dompet_mahasiswa/utils/snackbar_helper.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:dompet_mahasiswa/widgets/app_card.dart';
import 'package:dompet_mahasiswa/widgets/confirm_dialog.dart';
import 'package:dompet_mahasiswa/widgets/empty_state.dart';
import 'package:flutter/material.dart';

class KategoriListPage extends StatefulWidget {
  const KategoriListPage({super.key});

  @override
  State<KategoriListPage> createState() => _KategoriListPageState();
}

class _KategoriListPageState extends State<KategoriListPage> {
  final _database = DatabaseHelper.instance;
  List<Kategori> _categories = [];
  JenisKategori? _filter;
  bool _loading = true;
  bool _loadFailed = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    try {
      final categories = await _database.getAllKategori();
      if (!mounted) return;
      setState(() => _categories = categories);
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadFailed = true);
      showErrorSnackbar(context, AppStrings.gagalMemuatKategori);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openForm([Kategori? category]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => KategoriFormPage(category: category)),
    );
    if (mounted && saved == true) {
      _filter = null;
      await _load();
    }
  }

  Future<void> _delete(Kategori category) async {
    final id = category.id;
    if (id == null || _deleting) return;
    setState(() => _deleting = true);
    try {
      final confirmed = await ConfirmDialog.show(
        context,
        title: AppStrings.hapusKategoriJudul,
        message: AppStrings.konfirmasiHapusKategori(category.nama),
        confirmLabel: AppStrings.hapus,
        cancelLabel: AppStrings.batal,
        isDanger: true,
      );
      if (!mounted || !confirmed) return;
      if (await _database.isKategoriUsedInTransaksi(id)) {
        if (mounted) {
          showInfoSnackbar(context, AppStrings.kategoriTidakBisaDihapus);
        }
        return;
      }
      try {
        await _database.deleteKategori(id);
      } catch (_) {
        // A transaction can start using the category after the first check.
        if (!await _database.isKategoriUsedInTransaksi(id)) rethrow;
        if (mounted) {
          showInfoSnackbar(context, AppStrings.kategoriTidakBisaDihapus);
        }
        return;
      }
      if (!mounted) return;
      await _load();
      if (mounted && !_loadFailed) {
        showSuccessSnackbar(context, AppStrings.kategoriDihapus);
      }
    } catch (_) {
      if (mounted) {
        showErrorSnackbar(context, AppStrings.gagalMenghapusKategori);
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showEmpty = !_loading && !_loadFailed && _categories.isEmpty;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(AppStrings.kategori, style: AppTextStyles.h2),
        centerTitle: true,
        backgroundColor: AppColors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.s12),
            child: AppButton(
              label: AppStrings.tambah,
              icon: const Icon(Icons.add),
              isExpanded: false,
              onPressed: _deleting ? null : _openForm,
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.kategoriBackground, fit: BoxFit.cover),
          SafeArea(
            top: !showEmpty,
            minimum: showEmpty
                ? const EdgeInsets.only(bottom: AppSpacing.s32)
                : EdgeInsets.zero,
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadFailed) {
      return EmptyState(
        title: AppStrings.gagalMemuatKategori,
        actionLabel: AppStrings.cobaLagi,
        onAction: _load,
      );
    }
    if (_categories.isEmpty) {
      return EmptyState(
        title: AppStrings.belumAdaKategori,
        message: AppStrings.pesanKategoriKosong,
        actionLabel: AppStrings.tambahKategori,
        onAction: _openForm,
      );
    }

    final filter = _filter;
    final visible = filter == null
        ? _categories
        : _categories
              .where((category) => category.jenis == filter.value)
              .toList();
    return ListView(
      padding: const EdgeInsets.only(
        left: AppSpacing.s22,
        right: AppSpacing.s22,
        bottom: AppSpacing.s24,
      ),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip(AppStrings.semua, null),
              const SizedBox(width: AppSpacing.s12),
              _filterChip(AppStrings.pemasukan, JenisKategori.pemasukan),
              const SizedBox(width: AppSpacing.s12),
              _filterChip(AppStrings.pengeluaran, JenisKategori.pengeluaran),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s20),
        Row(
          children: [
            Text(_label(filter), style: AppTextStyles.h2),
            const SizedBox(width: AppSpacing.s8),
            _Badge(
              label: '${visible.length}',
              color: AppColors.primary,
              background: AppColors.tintLilac,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        if (visible.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.s16),
            child: Text(
              AppStrings.kategoriFilterKosong,
              style: AppTextStyles.body,
            ),
          ),
        for (final category in visible)
          AppCard(
            key: ValueKey(category.id),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s10,
            ),
            margin: const EdgeInsets.only(bottom: AppSpacing.s16),
            onTap: _deleting ? null : () => _openForm(category),
            child: _CategoryRow(
              category: category,
              onEdit: _deleting ? null : () => _openForm(category),
              onDelete: _deleting ? null : () => _delete(category),
            ),
          ),
        AppButton(
          label: AppStrings.tambahKategori,
          icon: const Icon(Icons.add),
          variant: AppButtonVariant.secondary,
          onPressed: _deleting ? null : _openForm,
        ),
      ],
    );
  }

  Widget _filterChip(String label, JenisKategori? type) {
    final selected = _filter == type;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      side: BorderSide.none,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillAll),
      backgroundColor: AppColors.tintLilac,
      selectedColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      labelStyle: (selected ? AppTextStyles.bodyStrong : AppTextStyles.body)
          .copyWith(color: selected ? AppColors.onPrimary : AppColors.primary),
      onSelected: (_) => setState(() => _filter = type),
    );
  }

  String _label(JenisKategori? type) => switch (type) {
    null => AppStrings.semuaKategori,
    JenisKategori.pemasukan => AppStrings.pemasukan,
    JenisKategori.pengeluaran => AppStrings.pengeluaran,
  };
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  final Kategori category;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final income = category.jenis == JenisKategori.pemasukan.value;
    final foreground = colorForJenis(category.jenis);
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: income ? AppColors.successTint : AppColors.tintSky,
            borderRadius: AppRadius.tileAll,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s6),
            child: Image.asset(
              income ? AppAssets.kategoriIncome : AppAssets.kategoriTag,
              width: AppSpacing.s20,
              height: AppSpacing.s20,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(category.nama, style: AppTextStyles.body),
              const SizedBox(height: AppSpacing.s4),
              _Badge(
                label: income ? AppStrings.pemasukan : AppStrings.pengeluaran,
                color: income ? AppColors.successStrong : foreground,
                background: income
                    ? AppColors.successTint
                    : AppColors.dangerTint,
              ),
            ],
          ),
        ),
        _CategoryAction(
          label: AppStrings.ubahKategori,
          asset: AppAssets.kategoriEdit,
          background: AppColors.tintLilac,
          onPressed: onEdit,
        ),
        _CategoryAction(
          label: AppStrings.hapus,
          asset: AppAssets.kategoriDelete,
          background: AppColors.dangerTint,
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class _CategoryAction extends StatelessWidget {
  const _CategoryAction({
    required this.label,
    required this.asset,
    required this.background,
    required this.onPressed,
  });

  final String label;
  final String asset;
  final Color background;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      onPressed: onPressed,
      icon: Container(
        width: AppSpacing.s24,
        height: AppSpacing.s24,
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadius.smAll,
        ),
        alignment: Alignment.center,
        child: Image.asset(
          asset,
          width: AppSpacing.s14,
          height: AppSpacing.s14,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.fullAll,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s6,
          vertical: AppSpacing.s2,
        ),
        child: Text(label, style: AppTextStyles.label.copyWith(color: color)),
      ),
    );
  }
}
