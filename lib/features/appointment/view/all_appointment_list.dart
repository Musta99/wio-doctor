import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:wio_doctor/core/theme/app_colors.dart';
import 'package:wio_doctor/core/theme/app_decoration.dart';
import 'package:wio_doctor/core/theme/app_text_styles.dart';
import 'package:wio_doctor/core/theme/theme_provider.dart';
import 'package:wio_doctor/features/appointment/view_model/appointment_view_model.dart';
import 'package:wio_doctor/features/appointment/widgets/appointment_card_widget.dart';

class AllAppointmentList extends StatefulWidget {
  const AllAppointmentList({super.key});

  @override
  State<AllAppointmentList> createState() => _AllAppointmentListState();
}

class _AllAppointmentListState extends State<AllAppointmentList> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentViewModel>().fetchDoctorsAppointmentsAll(context);
    });

    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<AppointmentViewModel>();

    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !provider.isPaginationLoading) {
      provider.fetchDoctorsAppointmentsAll(context, isLoadMore: true);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeViewModel>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text("All Appointments", style: AppTextStyles.title(20)),
        centerTitle: true,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bgTop(isDark), AppColors.bgBottom(isDark)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// SEARCH FIELD
              _searchField(context, isDark),

              const SizedBox(height: 16),

              /// LIST
              Expanded(
                child: Consumer<AppointmentViewModel>(
                  builder: (context, provider, _) {
                    /// LOADING
                    if (provider.isLoadingAllAppointmentsFetch) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    /// ERROR
                    if (provider.fetchError != null) {
                      return _errorView(provider);
                    }

                    /// EMPTY
                    if (provider.allAppointmentsList.isEmpty) {
                      return const Center(child: Text("No appointments found"));
                    }

                    /// LIST
                    return ListView.builder(
                      controller: scrollController,
                      itemCount:
                          provider.allAppointmentsList.length +
                          (provider.isPaginationLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= provider.allAppointmentsList.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final appointment = provider.allAppointmentsList[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AppointmentCardWidget(
                            appointment: appointment,
                            isDark: isDark,
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
    );
  }

  Widget _searchField(BuildContext context, bool isDark) {
    return TextField(
      controller: searchController,
      decoration: AppDecorations.inputDec(
        "Search by name or ID",
        LucideIcons.search,
        isDark,
      ),
      onChanged: (value) {
        context.read<AppointmentViewModel>().fetchDoctorsAppointmentsAll(
          context,
          query: value,
        );
      },
    );
  }

  Widget _errorView(provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(provider.fetchError ?? "Something went wrong"),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              provider.fetchDoctorsAppointmentsAll(context);
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
