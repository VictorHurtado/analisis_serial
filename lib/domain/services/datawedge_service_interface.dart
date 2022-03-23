abstract class DatawedgeServiceInterface {
  Future<void> activeSessionScanner();
  Future<void> printVersion();
  Future<void> createProfile(String profileName);
  void listenScanResult();
  void closeStreamController();
  Stream<Map<int, List<String>>> get eventOnDatawedge;
  Stream<List<String>> get eventListOnDatawedge;

  Future<void> modifySettings({numberOfCodes, timer, reportInstantly, beamWidth, aimType});
  void stablishMatrixOfCodes(Map<String, String> matrixReference);
  void stablishTotalQuantity(int quantity);
  void resetReportInstantlyVariables();
}
