import 'dart:math';

import 'package:MatrixScanSimpleSample/models/barcode_location.dart';
// Ordenamiento

List<BarcodeLocation> quickSort(List<BarcodeLocation> list, int low, int high) {
  if (low < high) {
    int pi = partition(list, low, high);
    print("pivot: ${list[pi]} now at index $pi");

    quickSort(list, low, pi - 1);
    quickSort(list, pi + 1, high);
  }
  return list;
}

int partition(List<BarcodeLocation> list, low, high) {
  // Base check
  if (list.isEmpty) {
    return 0;
  }
  // Take our last element as pivot and counter i one less than low
  BarcodeLocation pivot = list[high];

  int i = low - 1;
  for (int j = low; j < high; j++) {
    // When j is < than pivot element we increment i and swap arr[i] and arr[j]
    if (list[j].location["x"] < pivot.location["x"]) {
      i++;
      swap(list, i, j);
    }
  }
  // Swap the last element and place in front of the i'th element
  swap(list, i + 1, high);
  return i + 1;
}

// Swapping using a temp variable
void swap(List<BarcodeLocation> list, int i, int j) {
  BarcodeLocation temp = list[i];
  list[i] = list[j];
  list[j] = temp;
}
