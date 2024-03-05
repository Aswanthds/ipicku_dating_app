import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class SnackBarManager {
  static SnackBar successCustomSnackBar(String message) {
    return SnackBar(
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(message),
          const Icon(Icons.done),
        ],
      ),
    );
  }

  static SnackBar errorCustomSnackBar(String message) {
    return SnackBar(
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(message),
          const Icon(Icons.error),
        ],
      ),
    );
  }

  static const SnackBar failedSignUp = SnackBar(
    backgroundColor: Colors.red,
    duration: Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Sign Up Failed"),
        Icon(Icons.error),
      ],
    ),
  );

  static const SnackBar profileFailedSnackBar = SnackBar(
    backgroundColor: Colors.red,
    content: Text("Submitting your details failed"),
    behavior: SnackBarBehavior.floating,
  );

  static const SnackBar profileSuccessSnackBar = SnackBar(
    backgroundColor: Colors.green,
    duration: Durations.medium3,
    content: Row(
      children: [
        Text("Details Submitted Successfully"),
        Icon(EvaIcons.doneAll),
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );

  static const SnackBar profileLoading = SnackBar(
    backgroundColor: Colors.grey,
    duration: Durations.long2,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Details are submitting....."),
        CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Colors.white,
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );

  static const SnackBar profileGetSuccess = SnackBar(
    backgroundColor: Colors.grey,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Details are fetching....."),
        CircularProgressIndicator(
          strokeWidth: 2.0,
          color: Colors.white,
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );
  static const deleteLoadingSnackbar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppTheme.red,
    duration: Duration(seconds: 3),
    content: Row(
      children: [
        Text("Deleting your data"),
        CircularProgressIndicator(
          strokeWidth: 5.0,
        ),
      ],
    ),
  );
  static const deletefailedSnackbar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppTheme.red,
    duration: Duration(seconds: 3),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Deleting your data failed !!!"),
        Icon(EvaIcons.alertCircle),
      ],
    ),
  );
  static const deleteDoneSnackbar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppTheme.green,
    duration: Duration(seconds: 3),
    content: Row(
      children: [
        Text("Deleted your data !!"),
        Icon(EvaIcons.doneAll),
      ],
    ),
  );

  static SnackBar userBlockedSnackbar(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(EvaIcons.alertCircleOutline),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "User Blocked",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.black),
            ),
          ),
        ],
      ),
      duration: Durations.long2,
      backgroundColor: AppTheme.red,
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  static SnackBar userUnblocked(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(EvaIcons.alertCircleOutline),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "User UnBlocked",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.black),
            ),
          ),
        ],
      ),
      duration: Durations.long2,
      backgroundColor: AppTheme.green,
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  static SnackBar userMuted(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(EvaIcons.alertCircleOutline),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Chat Notification Muted",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.black),
            ),
          ),
        ],
      ),
      duration: Durations.long2,
      backgroundColor: AppTheme.red,
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  static SnackBar userUnMuted(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(EvaIcons.alertCircleOutline),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Chat Notification Unmuted",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.black),
            ),
          ),
        ],
      ),
      duration: Durations.long2,
      backgroundColor: AppTheme.green,
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  static SnackBar chatHistorydeleted(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(EvaIcons.alertCircleOutline),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Chat History Unmuted",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppTheme.black),
            ),
          ),
        ],
      ),
      duration: Durations.long2,
      backgroundColor: AppTheme.secondaryColor,
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
