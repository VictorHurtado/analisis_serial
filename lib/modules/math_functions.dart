//se puede mover
import 'dart:math';

import 'package:MatrixScanSimpleSample/barcode_location.dart';

// Promedios
double calculateMeanH(double sum, List<BarcodeLocation> listOfCodes) {
  return (sum / listOfCodes.length) * 0.05;
}

double calculateMeanY(List<BarcodeLocation> listOfCodes, String orientation) {
  double prom, sum = 0;
  for (BarcodeLocation barcode in listOfCodes) {
    sum = sum + barcode.location[orientation];
  }
  prom = sum / listOfCodes.length;
  print(prom);
  return prom;
}

// Desviación estandar
double calculateNumerator(List<BarcodeLocation> listOfCodes, String orientation, double media) {
  double sum = 0;
  for (BarcodeLocation barcode in listOfCodes) {
    sum = sum + pow(barcode.location[orientation] - media, 2);
  }

  return sum;
}

double calculateStandarDesviation(
    List<BarcodeLocation> listOfCodes, String orientation, double media) {
  return sqrt(calculateNumerator(listOfCodes, orientation, media) / listOfCodes.length - 1);
}

// Ordenamiento

List<BarcodeLocation> quickSort(List<BarcodeLocation> list, int low, int high) {
  if (low < high) {
    int pi = partition(list, low, high);

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
    if (list[j].location["y"] < pivot.location["y"]) {
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
