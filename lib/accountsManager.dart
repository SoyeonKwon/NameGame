import '../user.dart';

class accountsManager {

  List<Account>? accounts;

  bool contains(Account acc) {
    return accounts!.contains(acc);
  }

  void addAccount(Account acc) {
    accounts!.add(acc);
  }

}