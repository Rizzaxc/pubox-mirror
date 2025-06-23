import 'dart:io';
import 'package:flutter/material.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:provider/provider.dart';

import 'avatar_state_provider.dart';

/// A reusable avatar component that displays either a user-uploaded image
/// or a generated avatar based on a string.
class PuboxAvatar extends StatelessWidget {
  /// The radius of the avatar
  final double radius;
  
  /// Callback when the avatar is tapped
  final VoidCallback? onTap;
  
  /// Whether to show the upload button
  final bool showUploadButton;
  
  /// Whether to show the regenerate button
  final bool showRegenerateButton;
  
  /// The username to use for generating the avatar (if no custom image)
  final String username;
  
  const PuboxAvatar({
    super.key,
    required this.username,
    this.radius = 72,
    this.onTap,
    this.showUploadButton = true,
    this.showRegenerateButton = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AvatarStateProvider(),
      child: Consumer<AvatarStateProvider>(
        builder: (context, avatarState, _) {
          // Initialize if needed
          if (avatarState.currentSeed.isEmpty) {
            // Use Future.microtask to avoid calling setState during build
            Future.microtask(() => avatarState.initialize(username));
          }
          
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar display
              GestureDetector(
                onTap: onTap,
                child: _buildAvatar(avatarState),
              ),
              
              // Action buttons
              if (showUploadButton || showRegenerateButton)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Upload button
                      if (showUploadButton)
                        _buildUploadButton(context, avatarState),
                      
                      // Regenerate button (only shown if no custom image)
                      if (showRegenerateButton && !avatarState.hasCustomImage)
                        _buildRegenerateButton(avatarState),
                      
                      // Clear image button (only shown if has custom image)
                      if (showUploadButton && avatarState.hasCustomImage)
                        _buildClearImageButton(avatarState),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
  
  /// Build the avatar widget (either custom image or generated avatar)
  Widget _buildAvatar(AvatarStateProvider avatarManager) {
    if (avatarManager.isLoading) {
      return SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: const CircularProgressIndicator(),
      );
    } else if (avatarManager.hasCustomImage) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(File(avatarManager.imagePath!)),
      );
    } else {
      return AvatarPlus(
        avatarManager.currentSeed,
        width: radius * 2,
        height: radius * 2,
      );
    }
  }
  
  /// Build the upload button
  Widget _buildUploadButton(BuildContext context, AvatarStateProvider avatarState) {
    return IconButton(
      icon: const Icon(Icons.photo_camera),
      tooltip: 'Upload image',
      onPressed: () {
        // Show a dialog to choose between camera and gallery
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Choose image source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement image picking from camera
                    // This requires adding the image_picker package
                    // For now, we'll just show a placeholder message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Camera functionality will be implemented with image_picker package'),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implement image picking from gallery
                    // This requires adding the image_picker package
                    // For now, we'll just show a placeholder message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gallery functionality will be implemented with image_picker package'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Build the regenerate button
  Widget _buildRegenerateButton(AvatarStateProvider avatarState) {
    return IconButton(
      icon: const Icon(Icons.refresh),
      tooltip: 'Generate new avatar',
      onPressed: () {
        avatarState.generateNewSeed(username);
      },
    );
  }
  
  /// Build the clear image button
  Widget _buildClearImageButton(AvatarStateProvider avatarState) {
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: 'Remove custom image',
      onPressed: () {
        avatarState.clearImage();
      },
    );
  }
}