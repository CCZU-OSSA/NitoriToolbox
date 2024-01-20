import 'package:flutter/material.dart';

AsyncWidgetBuilder<T> snapshotLoading<T>(
    {required Widget Function(T data) builder}) {
  return (BuildContext context, AsyncSnapshot<T> snapshot) {
    if (snapshot.hasData) {
      return builder(snapshot.data as T);
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  };
}
