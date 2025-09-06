import 'package:blog_client/core/common/extensions/padding_extensions.dart';
import 'package:blog_client/core/common/extensions/size_extensions.dart';
import 'package:blog_client/core/common/extensions/text_theme_extensions.dart';
import 'package:blog_client/core/common/models/blog_model.dart';
import 'package:blog_client/core/common/widgets/common_text.dart';
import 'package:blog_client/core/constants/constants.dart';
import 'package:blog_client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class BuildBlogCard extends StatelessWidget {
  const BuildBlogCard({required this.blog, super.key, this.onTap});
  final BlogModel blog;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: context.paddingBottom(numD02).padding,
        decoration: BoxDecoration(
          color: AppPallete.cardBackground,
          borderRadius: BorderRadius.circular(size.width * numD03),
          boxShadow: [
            BoxShadow(
              color: AppPallete.greyColor300.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blog Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * numD03),
                topRight: Radius.circular(size.width * numD03),
              ),
              child: Container(
                height: size.height * numD2,
                width: double.infinity,
                decoration: BoxDecoration(color: AppPallete.greyColor300),
                child: blog.imageUrl.isNotEmpty
                    ? Image.network(
                        blog.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppPallete.greyColor300,
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppPallete.greyColor400,
                              size: size.width * numD12,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppPallete.greyColor300,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppPallete.primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                      )
                    : Icon(
                        Icons.image_not_supported,
                        color: AppPallete.greyColor400,
                        size: size.width * numD12,
                      ),
              ),
            ),
            // Blog Content
            context.paddingAll(
              numD035,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  CommonText(
                    text: blog.title,
                    style: context.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppPallete.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  context.sizedBoxHeight(numD01),
                  // Description
                  CommonText(
                    text: blog.description,
                    style: context.bodyMedium.copyWith(
                      color: AppPallete.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  context.sizedBoxHeight(numD015),
                  // Author Info
                  Row(
                    children: [
                      // Author Avatar
                      Container(
                        width: size.width * numD08,
                        height: size.width * numD08,
                        decoration: BoxDecoration(
                          color: AppPallete.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child:
                            blog.author.avatar != null &&
                                blog.author.avatar!.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  blog.author.avatar!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      color: AppPallete.primaryColor,
                                      size: size.width * numD05,
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                Icons.person,
                                color: AppPallete.primaryColor,
                                size: size.width * numD05,
                              ),
                      ),
                      context.sizedBoxWidth(numD015),
                      // Author Name and Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText(
                              text: blog.author.username ?? 'Unknown Author',
                              style: context.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppPallete.textPrimary,
                              ),
                            ),
                            CommonText(
                              text: _formatDate(DateTime.parse(blog.createdAt)),
                              style: context.bodySmall.copyWith(
                                color: AppPallete.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Action Buttons
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              // TODO: Implement save functionality
                            },
                            icon: Icon(
                              Icons.bookmark_border,
                              color: AppPallete.greyColor400,
                              size: size.width * numD06,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // TODO: Implement upvote functionality
                            },
                            icon: Icon(
                              Icons.thumb_up_outlined,
                              color: AppPallete.greyColor400,
                              size: size.width * numD06,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
