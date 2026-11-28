import 'package:dompet_mahasiswa/database/database_helper.dart';
import 'package:dompet_mahasiswa/domain/entities/kategori.dart';
import 'package:dompet_mahasiswa/domain/value_objects/jenis_kategori.dart';
import 'package:dompet_mahasiswa/pages/kategori_form_page.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_assets.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/utils/snackbar_helper.dart';
import 'package:dompet_mahasiswa/widgets/app_badge.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:dompet_mahasiswa/widgets/app_filter_chip.dart';
import 'package:dompet_mahasiswa/widgets/app_page_header.dart';
import 'package:dompet_mahasiswa/widgets/category_card.dart';
import 'package:dompet_mahasiswa/widgets/confirm_dialog.dart';
import 'package:dompet_mahasiswa/widgets/empty_state.dart';
// Paket pengganti material_ui belum ada di SDK ini. development punya info yang sama.
// ignore: deprecated_member_use
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

  Future<void> _showTidakBisaDihapus() {
    return ConfirmDialog.show(
      context,
      title: AppStrings.kategoriTidakBisaDihapusJudul,
      message: AppStrings.kategoriTidakBisaDihapus,
      variant: ConfirmDialogVariant.info,
    );
  }

  Future<void> _openForm([Kategori? category]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => KategoriFormPage(id: category?.id)),
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
        if (mounted) await _showTidakBisaDihapus();
        return;
      }
      try {
        await _database.deleteKategori(id);
      } catch (_) {
        // A transaction can start using the category after the first check.
        if (!await _database.isKategoriUsedInTransaksi(id)) rethrow;
        if (mounted) await _showTidakBisaDihapus();
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.kategoriBackground, fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s22,
                AppSpacing.s28,
                AppSpacing.s22,
                AppSpacing.s28,
              ),
              child: Column(
                children: [
                  const AppPageHeader(title: AppStrings.kategori),
                  const SizedBox(height: AppSpacing.s24),
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadFailed) {
      return EmptyState(
        padding: EdgeInsets.zero,
        title: AppStrings.gagalMemuatKategori,
        actionLabel: AppStrings.cobaLagi,
        onAction: _load,
      );
    }
    if (_categories.isEmpty) {
      return EmptyState(
        padding: EdgeInsets.zero,
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
      padding: EdgeInsets.zero,
      children: [
        AppFilterChipBar<JenisKategori?>(
          selected: filter,
          onSelected: _deleting
              ? null
              : (value) => setState(() => _filter = value),
          options: const [
            AppFilterOption(value: null, label: AppStrings.semua),
            AppFilterOption(
              value: JenisKategori.pemasukan,
              label: AppStrings.pemasukan,
            ),
            AppFilterOption(
              value: JenisKategori.pengeluaran,
              label: AppStrings.pengeluaran,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s24),
        Row(
          children: [
            Text(_label(filter), style: AppTextStyles.heading19),
            const SizedBox(width: AppSpacing.s6),
            AppCountBadge(count: visible.length),
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
          CategoryCard(
            key: ValueKey(category.id),
            name: category.nama,
            jenis: category.jenis,
            style: CategoryCardStyle.forCategory(category.nama, category.jenis),
            margin: const EdgeInsets.only(bottom: AppSpacing.s16),
            onTap: _deleting ? null : () => _openForm(category),
            onEdit: _deleting ? null : () => _openForm(category),
            onDelete: _deleting ? null : () => _delete(category),
          ),
        AppButton(
          label: AppStrings.tambahKategoriAksi,
          variant: AppButtonVariant.secondary,
          onPressed: _deleting ? null : () => _openForm(),
        ),
      ],
    );
  }

  String _label(JenisKategori? type) => switch (type) {
    null => AppStrings.semuaKategori,
    JenisKategori.pemasukan => AppStrings.pemasukan,
    JenisKategori.pengeluaran => AppStrings.pengeluaran,
  };
}
