import 'package:dompet_mahasiswa/pages/dashboard_page.dart';
import 'package:dompet_mahasiswa/pages/dompet_form_page.dart';
import 'package:dompet_mahasiswa/pages/kategori_list_page.dart';
import 'package:dompet_mahasiswa/theme/app_colors.dart';
import 'package:dompet_mahasiswa/theme/app_shadows.dart';
import 'package:dompet_mahasiswa/theme/app_spacing.dart';
import 'package:dompet_mahasiswa/theme/app_text_styles.dart';
import 'package:dompet_mahasiswa/utils/app_strings.dart';
import 'package:dompet_mahasiswa/widgets/app_button.dart';
import 'package:flutter/material.dart';

/// Urutan tab shell. Sama dengan urutan anak [IndexedStack] dan ikon bilah.
const _tabDashboard = 0;
const _tabDompet = 1;
const _tabTransaksi = 2;
const _tabRiwayat = 3;
const _tabKategori = 4;

/// Kerangka aplikasi. Lima tujuan tetap di memori lewat [IndexedStack],
/// jadi pindah tab tidak membuang state halaman.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = _tabDashboard;

  void _select(int index) {
    if (index == _index) {
      return;
    }
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          DashboardPage(
            isActive: _index == _tabDashboard,
            onLihatRiwayat: () => _select(_tabRiwayat),
            onOpenDompet: () => _select(_tabDompet),
          ),
          const _DompetTab(),
          const _PlaceholderTab(title: AppStrings.transaksi),
          const _PlaceholderTab(title: AppStrings.riwayat),
          const KategoriListPage(),
        ],
      ),
      bottomNavigationBar: RepaintBoundary(
        key: const Key('shell-navigation-bar'),
        child: ShellNavigationBar(selectedIndex: _index, onSelected: _select),
      ),
    );
  }
}

/// Bilah bawah frame Dashboard: empat ikon dan tombol tambah di tengah.
///
/// Urutan visual Figma: Dashboard, Dompet, tambah (Transaksi), Riwayat, Kategori.
/// Material [NavigationBar] tidak punya tombol tengah, jadi bilah ini disusun sendiri
/// dengan token yang sama.
class ShellNavigationBar extends StatelessWidget {
  const ShellNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Tinggi frame NavigationBar di Figma. Bukan token jarak.
  static const double frameHeight = 78;

  /// Tinggi jalur putih di bawah tombol tambah. Bukan token jarak.
  static const double trackHeight = 56;

  /// Diameter tombol tambah di frame. Bukan token jarak.
  static const double fabExtent = 44;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: frameHeight,
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: trackHeight,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.outline)),
                  ),
                  child: Row(
                    children: [
                      _NavButton(
                        semanticsId: 'nav_dashboard',
                        label: AppStrings.dashboard,
                        selected: selectedIndex == _tabDashboard,
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home_rounded,
                        onPressed: () => onSelected(_tabDashboard),
                      ),
                      _NavButton(
                        semanticsId: 'nav_dompet',
                        label: AppStrings.dompet,
                        selected: selectedIndex == _tabDompet,
                        icon: Icons.account_balance_wallet_outlined,
                        selectedIcon: Icons.account_balance_wallet,
                        onPressed: () => onSelected(_tabDompet),
                      ),
                      const SizedBox(width: fabExtent),
                      _NavButton(
                        semanticsId: 'nav_riwayat',
                        label: AppStrings.riwayat,
                        selected: selectedIndex == _tabRiwayat,
                        icon: Icons.receipt_long_outlined,
                        selectedIcon: Icons.receipt_long,
                        onPressed: () => onSelected(_tabRiwayat),
                      ),
                      _NavButton(
                        semanticsId: 'nav_kategori',
                        label: AppStrings.kategori,
                        selected: selectedIndex == _tabKategori,
                        icon: Icons.grid_view_outlined,
                        selectedIcon: Icons.grid_view_rounded,
                        onPressed: () => onSelected(_tabKategori),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: _AddButton(
                  semanticsId: 'nav_transaksi',
                  selected: selectedIndex == _tabTransaksi,
                  onPressed: () => onSelected(_tabTransaksi),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.semanticsId,
    required this.label,
    required this.selected,
    required this.icon,
    required this.selectedIcon,
    required this.onPressed,
  });

  /// Identifier semantik untuk alat uji di luar Flutter. Tidak tampil di layar.
  final String semanticsId;
  final String label;
  final bool selected;
  final IconData icon;
  final IconData selectedIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.primarySoft;
    return Expanded(
      child: Semantics(
        identifier: semanticsId,
        child: IconButton(
          tooltip: label,
          onPressed: onPressed,
          icon: Icon(selected ? selectedIcon : icon, color: color),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({
    required this.semanticsId,
    required this.selected,
    required this.onPressed,
  });

  final String semanticsId;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      identifier: semanticsId,
      child: Tooltip(
        message: AppStrings.transaksi,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: selected ? AppShadows.primary : AppShadows.hero,
          ),
          child: Material(
            color: AppColors.primary,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: SizedBox(
                width: ShellNavigationBar.fabExtent,
                height: ShellNavigationBar.fabExtent,
                child: Icon(
                  Icons.add,
                  color: AppColors.onPrimary,
                  size: AppSpacing.s28,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: AppSpacing.pad20,
          child: Text(
            AppStrings.halamanBelumSiap,
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// Daftar dompet (#5) belum ada. Tab ini membuka form yang sudah ada.
class _DompetTab extends StatelessWidget {
  const _DompetTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.dompet)),
      body: Padding(
        padding: AppSpacing.pad20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.halamanBelumSiap,
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s20),
            AppButton(
              label: AppStrings.tambahDompet,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const DompetFormPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
