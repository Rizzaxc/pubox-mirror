import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TagCarousel extends StatefulWidget {
  final List<String> tagLabels;
  final int maxSelected;
  final double height;
  final Function(Set<String>)? onSelectionChanged;
  final Set<String> initialSelection;

  const TagCarousel({
    super.key,
    required this.tagLabels,
    this.maxSelected = 3,
    this.height = 40,
    this.onSelectionChanged,
    this.initialSelection = const {},
  });

  @override
  State<TagCarousel> createState() => _TagCarouselState();
}

class _TagCarouselState extends State<TagCarousel> {
  final PageController _pageController = PageController();
  final ScrollController _selectedScrollController = ScrollController();
  final Set<String> _selectedTags = {};
  int _currentPage = 0;

  // Key for measuring container width
  final GlobalKey _containerKey = GlobalKey();
  List<List<String>> _pages = [];

  @override
  void initState() {
    super.initState();
    // Initial distribution will be updated in the first build
    _pages = [widget.tagLabels];

    // Initialize with provided initial selection
    if (widget.initialSelection.isNotEmpty) {
      // Only add tags that exist in tagLabels and respect maxSelected
      for (final tag in widget.initialSelection) {
        if (widget.tagLabels.contains(tag) &&
            _selectedTags.length < widget.maxSelected) {
          _selectedTags.add(tag);
        }
      }
    }

    // Add post-frame callback to measure and distribute tags
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _distributeTagsIntoPages();
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        // Only add if we haven't reached the max selected
        if (_selectedTags.length < widget.maxSelected) {
          _selectedTags.add(tag);
        }
      }

      // Redistribute tags when selection changes
      _distributeTagsIntoPages();
    });

    // Notify listener of selection change
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(Set<String>.from(_selectedTags));
    }
  }

  void _distributeTagsIntoPages() {
    // Need to wait for the next frame to get accurate measurements
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get container width
      final RenderBox? renderBox =
          _containerKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      double containerWidth = renderBox.size.width;
      // Subtract space for navigation buttons (if they'll be shown)
      if (widget.tagLabels.length > 5) {
        containerWidth -= 80; // Approximate width for two navigation buttons
      }

      // Get unselected tags only
      List<String> unselectedList = widget.tagLabels
          .where((tag) => !_selectedTags.contains(tag))
          .toList();

      // Calculate how many rows we can fit
      int maxRowsPerPage = (widget.height / 36)
          .floor(); // Each tag is approximately 30px high + some margin
      maxRowsPerPage =
          maxRowsPerPage > 0 ? maxRowsPerPage : 1; // At least one row

      List<List<String>> newPages = [];
      List<String> currentPage = [];
      List<List<String>> currentPageRows = [];
      List<String> currentRow = [];
      double currentRowWidth = 0;

      // Create a temporary context for text measurement
      final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
      );

      // Calculate tags per page (only for unselected tags)
      for (String tag in unselectedList) {
        // Calculate tag width (text width + padding + border)
        textPainter.text = TextSpan(
          text: tag,
          style: const TextStyle(fontSize: 12),
        );
        textPainter.layout();

        // Add padding, border, and some margin
        double tagWidth = textPainter.width + 40; // Padding + border + margin

        // If this tag would overflow current row
        if (currentRow.isNotEmpty &&
            currentRowWidth + tagWidth > containerWidth) {
          // Add current row to page rows
          currentPageRows.add(List.from(currentRow));

          // If we've reached max rows for this page
          if (currentPageRows.length >= maxRowsPerPage) {
            // Flatten rows into a single list for the page
            currentPage = currentPageRows.expand((row) => row).toList();
            newPages.add(List.from(currentPage));

            // Start a new page
            currentPageRows = [];
            currentPage = [];
          }

          // Start a new row
          currentRow = [tag];
          currentRowWidth = tagWidth;
        } else {
          // Add to current row
          currentRow.add(tag);
          currentRowWidth += tagWidth;
        }
      }

      // Add the last row to current page rows if not empty
      if (currentRow.isNotEmpty) {
        currentPageRows.add(List.from(currentRow));
      }

      // Add the last page if not empty
      if (currentPageRows.isNotEmpty) {
        currentPage = currentPageRows.expand((row) => row).toList();
        if (currentPage.isNotEmpty) {
          newPages.add(currentPage);
        }
      }

      // Update state if distribution changed
      if (!_arePageListsEqual(newPages, _pages)) {
        setState(() {
          _pages = newPages;
        });
      }
    });
  }

  bool _arePageListsEqual(List<List<String>> a, List<List<String>> b) {
    if (a.length != b.length) return false;

    for (int i = 0; i < a.length; i++) {
      if (a[i].length != b[i].length) return false;
      for (int j = 0; j < a[i].length; j++) {
        if (a[i][j] != b[i][j]) return false;
      }
    }

    return true;
  }

  @override
  void didUpdateWidget(TagCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the tag list or height changes, redistribute
    if (widget.tagLabels != oldWidget.tagLabels ||
        widget.height != oldWidget.height) {
      _distributeTagsIntoPages();
    }

    // Update selected tags if initialSelection changed
    if (widget.initialSelection != oldWidget.initialSelection) {
      _selectedTags.clear();
      for (final tag in widget.initialSelection) {
        if (widget.tagLabels.contains(tag) &&
            _selectedTags.length < widget.maxSelected) {
          _selectedTags.add(tag);
        }
      }
      _distributeTagsIntoPages();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _selectedScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = _pages.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chọn: ${_selectedTags.length}/${widget.maxSelected}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _selectedTags.length == widget.maxSelected
                      ? Colors.red
                      : Colors.black87,
                ),
              ),
              if (totalPages > 1)
                Text(
                  '${_currentPage + 1}/$totalPages',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Selected tags section
        if (_selectedTags.isNotEmpty)
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _selectedScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  for (String tag in _selectedTags)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TagChip(
                        label: tag,
                        isSelected: true,
                        onTap: () => _toggleTag(tag),
                        isSelectable: true,
                      ),
                    ),
                ],
              ),
            ),
          ),

        if (_selectedTags.isNotEmpty) const SizedBox(height: 8),

        // Unselected tags section
        SizedBox(
          key: _containerKey,
          height: widget.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (totalPages > 1)
                IconButton(
                  icon: Icon(PlatformIcons(context).back, size: 16),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  onPressed: _currentPage > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  color: _currentPage > 0 ? Colors.blue : Colors.grey.shade400,
                ),
              Expanded(
                child: _pages.isEmpty
                    ? const SizedBox.shrink()
                    : PageView.builder(
                        controller: _pageController,
                        itemCount: _pages.length,
                        onPageChanged: (page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemBuilder: (context, pageIndex) {
                          if (pageIndex >= _pages.length ||
                              _pages[pageIndex].isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 8, // horizontal space between tags
                                runSpacing: 8, // vertical space between lines
                                alignment: WrapAlignment.start,
                                children: _pages[pageIndex].map((tag) {
                                  final isSelected =
                                      _selectedTags.contains(tag);
                                  return TagChip(
                                    label: tag,
                                    isSelected: isSelected,
                                    onTap: () => _toggleTag(tag),
                                    isSelectable: !isSelected ||
                                        _selectedTags.length <
                                            widget.maxSelected,
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (totalPages > 1)
                IconButton(
                  icon: Icon(PlatformIcons(context).forward, size: 16),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  onPressed: _currentPage < totalPages - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null,
                  color: _currentPage < totalPages - 1
                      ? Colors.blue
                      : Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class TagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSelectable;

  const TagChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isSelectable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSelectable ? onTap : null,
      child: Container(
        constraints: const BoxConstraints(minWidth: 60),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
