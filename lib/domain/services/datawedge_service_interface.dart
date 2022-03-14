abstract class DatawedgeServiceInterface {
  Future<void> activeSessionScanner();
  Future<void> printVersion();
  Future<void> createProfile(String profileName);
  void listenScanResult();
  void closeStreamController();
  Stream<String> get eventOnDatawedge;
}
