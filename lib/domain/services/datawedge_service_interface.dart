abstract class DatawedgeServiceInterface {
  Future<void> activeSessionScanner();
  Future<void> printVersion();
  Future<void> createProfile(String profileName);
  void listenScanResult();
  void closeStreamController();
  Stream<Map<int, List<String>>> get eventOnDatawedge;
  Future<void> modifySettings({numberOfCodes, timer, reportInstantly, beamWidth, aim_Type});
  void stablishMatrixOfCodes(int quantity);
}
